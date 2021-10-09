import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/pages/image_viewer.dart';
import 'package:urbansensor/src/pages/video_viewer.dart';
import 'package:urbansensor/src/services/api_project.dart';
import 'package:urbansensor/src/services/api_report.dart';
import 'package:urbansensor/src/streams/project_stream.dart';
import 'package:urbansensor/src/utils/debouncer.dart';
import 'package:urbansensor/src/utils/format_date.dart';
import 'package:urbansensor/src/utils/loading_indicators_c.dart';
import 'package:urbansensor/src/utils/theme.dart';
import 'package:urbansensor/src/widgets/button.dart';
import 'package:urbansensor/src/widgets/cards/project_card.dart';
import 'package:urbansensor/src/widgets/file_type.dart';
import 'package:urbansensor/src/widgets/input.dart';
import 'package:urbansensor/src/widgets/input_search.dart';
import 'package:urbansensor/src/widgets/navigators/back_app_bar.dart';
import 'package:video_player/video_player.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({
    Key? key,
    required this.fileType,
    this.recordDuration,
    this.audioLocation,
    this.lostFile,
  }) : super(key: key);

  final FileType fileType;
  final String? recordDuration;
  final String? audioLocation;
  final XFile? lostFile;

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  File? _file;
  String? _dateTime;
  LatLng? _latLng;
  String? _address;
  late CameraPosition _kGooglePlex;
  Set<Marker> _markers = {};
  BitmapDescriptor? mapMarker;
  final Completer<GoogleMapController> _controller = Completer();
  final Completer<GoogleMapController> _fullMapController = Completer();
  final ApiProject _apiProject = ApiProject();
  final ApiReport _apiReport = ApiReport();
  final ProjectStream _stream = ProjectStream();

  VideoPlayerController? _videoController;

  final _formKey = GlobalKey<FormState>();
  final _projectController = TextEditingController();
  final _observationsController = TextEditingController();
  final _labelsController = TextEditingController();
  Widget? _projectFeedback;
  Widget? _observationsFeedback;
  Widget? _labelsFeedback;
  bool _isLoading = false;
  String? _projectId;

  final _debouncer = Debouncer(duration: const Duration(milliseconds: 500));
  String _searchValue = '';
  bool _apiSuccess = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _setCustomMarker();
    _retrieveData();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_apiSuccess) {
          if (_apiProject.isSearching) {
            _apiSuccess =
                await _apiProject.searchMyProjects(name: _searchValue);
          } else {
            _apiSuccess = await _apiProject.getAllMyProjects();
          }
          _scrollController.animateTo(_scrollController.position.pixels + 30,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn);
        }
      }
    });
  }

  void _retrieveData() async {
    _captureData(widget.lostFile);
  }

  @override
  void dispose() {
    if (widget.audioLocation == null) {
      _file?.delete();
      _file = null;
    }
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const BackAppBar(),
      body: Builder(builder: (context) {
        return SafeArea(
          child: _file == null &&
                  _dateTime == null &&
                  _latLng == null &&
                  _address == null
              ? Center(
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballClipRotateMultiple,
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 42.0, right: 42.0, bottom: 32.0),
                    child: Column(
                      children: [
                        Text(
                          'Crear Reporte',
                          style: theme.textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        _reportData(
                          icon: UniconsLine.calendar_alt,
                          content: _dateTime!,
                        ),
                        const SizedBox(height: 12.0),
                        _reportData(
                          icon: UniconsLine.compass,
                          content:
                              "${_latLng!.latitude}, ${_latLng!.longitude}",
                        ),
                        const SizedBox(height: 12.0),
                        _reportData(
                          icon: UniconsLine.location_pin_alt,
                          content: _address!,
                        ),
                        const SizedBox(height: 16.0),
                        _handlePreview(),
                        const SizedBox(height: 16.0),
                        Container(
                          width: double.infinity,
                          height: 164,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: CustomTheme.gray3),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: _kGooglePlex,
                                  markers: _markers,
                                  zoomControlsEnabled: false,
                                  zoomGesturesEnabled: false,
                                  tiltGesturesEnabled: false,
                                  scrollGesturesEnabled: false,
                                  rotateGesturesEnabled: false,
                                  mapToolbarEnabled: false,
                                  onCameraMove: null,
                                  onMapCreated: _onMapCreated,
                                  myLocationEnabled: false,
                                  myLocationButtonEnabled: false,
                                ),
                              ),
                              SizedBox.expand(
                                child: GestureDetector(
                                  onTap: _mapPreview,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        _formData(),
                      ],
                    ),
                  ),
                ),
        );
      }),
    );
  }

  Widget _handlePreview() {
    switch (widget.fileType) {
      case FileType.photo:
        return _imagePreview();
      case FileType.video:
        return _videoPreview();
      case FileType.mic:
        return Row(
          children: [
            const Icon(UniconsLine.clock),
            const SizedBox(width: 20.0),
            Text(
              'Duración: ${widget.recordDuration}s',
            ),
          ],
        );
    }
  }

  Widget _reportData({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 24.0),
        Flexible(
          child: Text(
            content,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _formData() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Input(
            controller: _projectController,
            label: "Proyecto",
            placeholder: "Buscar Proyecto",
            readOnly: true,
            onTap: () {
              _apiProject.getAllMyProjects();
              _projectSearch();
            },
            validator: _validateProject,
            feedback: _projectFeedback,
          ),
          const SizedBox(height: 32.0),
          Input(
            controller: _observationsController,
            label: "Observaciones (Opcional)",
            placeholder: "Escribe tu Observación",
            height: 112.0,
            maxLines: 5,
            minLines: 5,
            validator: _validateObservations,
            feedback: _observationsFeedback,
          ),
          const SizedBox(height: 32.0),
          Input(
            controller: _labelsController,
            label: "Etiquetas",
            placeholder: "#Etiqueta1 #Etiqueta2",
            validator: _validateLabels,
            feedback: _labelsFeedback,
          ),
          const SizedBox(height: 32.0),
          Button(
            fillColor: CustomTheme.lightBlue,
            padding: _isLoading
                ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0)
                : null,
            content: _isLoading
                ? SizedBox(
                    height: 48,
                    width: 48,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballClipRotateMultiple,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Enviar"),
                      SizedBox(width: 10),
                      Icon(UniconsLine.message),
                    ],
                  ),
            onPressed: _isLoading
                ? null
                : () {
                    _createReport();
                  },
          )
        ],
      ),
    );
  }

  void _createReport() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });

      bool isCreated = await _apiReport.createReport(
        _file!.path,
        _latLng!.latitude.toString(),
        _latLng!.longitude.toString(),
        _address!,
        _observationsController.text,
        _labelsController.text.toString(),
        _projectId!,
      );
      setState(() {
        _isLoading = false;
      });
      if (isCreated) {
        if (widget.audioLocation != null) {
          _file?.delete();
          _file = null;
        }

        Navigator.of(context)
            .pushNamedAndRemoveUntil("home", (Route<dynamic> route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ha ocurrido un error, intenta nuevamente'),
        ));
      }
    }
  }

  String? _validateProject(String? value) {
    if (value == null || value.isEmpty || _projectId == null) {
      setState(() {
        _projectFeedback = const InputFeedback(label: "Campo Requerido");
      });
      return "";
    } else {
      setState(() {
        _projectFeedback = null;
      });
      return null;
    }
  }

  String? _validateObservations(String? value) {
    return null;
  }

  String? _validateLabels(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _labelsFeedback = const InputFeedback(label: "Campo Requerido");
      });
      return "";
    } else {
      setState(() {
        _labelsFeedback = null;
      });
      return null;
    }
  }

  void _setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/img/location_marker.png');
  }

  Widget _imagePreview() {
    return SizedBox(
      width: double.infinity,
      height: 164,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: GestureDetector(
          onTap: () {
            showGeneralDialog(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ImageViewer(
                    image: _file!,
                  );
                });
          },
          child: Image.file(
            _file!,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  Widget _videoPreview() {
    return Stack(
      children: [
        SizedBox(
          height: 164,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: GestureDetector(
              onTap: () {
                showGeneralDialog(
                    context: context,
                    pageBuilder: (_, __, ___) => VideoViewer(file: _file!));
              },
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              // padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                // color: Colors.redAccent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: FloatingActionButton(
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0.75),
                onPressed: () {
                  showGeneralDialog(
                      context: context,
                      pageBuilder: (_, __, ___) => VideoViewer(file: _file!));
                },
                child: const Icon(UniconsLine.play),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _mapPreview() {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return StatefulBuilder(builder: (context, setStateSecondary) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                extendBodyBehindAppBar: true,
                appBar: const BackAppBar(),
                body: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      markers: _markers,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      onMapCreated: _onFullMapCreated,
                      onTap: (latLng) {
                        setStateSecondary(() {
                          setState(() {
                            _updatePosition(latLng);
                          });
                        });
                      },
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  _address!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    UniconsLine.crosshairs,
                    color: CustomTheme.lightBlue,
                  ),
                  onPressed: () {
                    _setCurrentPosition(setStateSecondary);
                  },
                ),
              ),
            );
          });
        });
  }

  void _projectSearch() {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return StatefulBuilder(builder: (context, setStateSecondary) {
            return WillPopScope(
              onWillPop: () async {
                _apiProject.cleanSearch();
                _apiProject.cleanProjects();
                return true;
              },
              child: Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 20.0, top: 20),
                        child: InputSearch(func: (value) {
                          _searchMyProjects(value);
                        }),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: StreamBuilder(
                            stream: _stream.projectsStream,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return Stack(
                                  children: [
                                    Positioned.fill(
                                        child: _scrollView(snapshot.data)),
                                    Positioned(
                                      bottom: 0,
                                      left: (MediaQuery.of(context).size.width /
                                              2) -
                                          50,
                                      child: _loading(),
                                    )
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return const Icon(Icons.error_outline);
                              } else {
                                return LoadingIndicatorsC.ballRotateChase;
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void _searchMyProjects(String text) {
    _apiProject.searchPage = 1;
    _apiProject.cleanProjects();
    _debouncer.value = '';
    _debouncer.onValue = (value) async {
      if (value.toString().isEmpty) {
        _apiProject.cleanSearch();
        _apiProject.getAllMyProjects();
      } else {
        setState(() {
          _searchValue = value;
        });
        _apiProject.searchMyProjects(name: value);
      }
      FocusScope.of(context).unfocus();
    };

    final timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      _debouncer.value = text;
    });

    Future.delayed(const Duration(milliseconds: 251))
        .then((_) => timer.cancel());
  }

  Widget _scrollView(List<Project>? projects) {
    return projects!.isNotEmpty
        ? CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                        child: ProjectCard(
                      project: projects[index],
                      onTap: () {
                        _projectController.text = projects[index].name!;
                        setState(() {
                          _projectId = projects[index].id!;
                        });
                        Navigator.of(context).pop();
                        _apiProject.cleanSearch();
                        _apiProject.cleanProjects();
                      },
                    )),
                  );
                }, childCount: projects.length),
              ),
            ],
          )
        : Center(
            child: Text(
            _apiProject.isSearching
                ? _apiProject.isSearchEmpty
                    ? 'No hemos podido encontrar '
                    : 'Buscando...'
                : !_apiSuccess
                    ? 'No cuentas con proyectos aun, crea uno y empieza a compartir tus reportes'
                    : '',
            textAlign: TextAlign.center,
          ));
  }

  Widget _loading() {
    return StreamBuilder(
        stream: _stream.projectLoadedStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return !snapshot.data
                ? LoadingIndicatorsC.ballRotateChaseSmall
                : Container();
          } else {
            return Container();
          }
        });
  }

  void _setCurrentPosition(
      void Function(void Function()) setStateSecondary) async {
    Location location = Location();

    bool _serviceEnabled;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    if (await Permission.location.request().isGranted) {
      _locationData = await location.getLocation();
      setStateSecondary(() {
        setState(() {
          LatLng latLng =
              LatLng(_locationData.latitude!, _locationData.longitude!);
          _updatePosition(latLng);
        });
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _updatePosition(LatLng latLng) async {
    geo.Placemark placemark = (await geo.placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
      localeIdentifier: "es_CL",
    ))
        .first;

    _latLng = latLng;
    _address =
        "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}";
    _kGooglePlex = CameraPosition(
      target: latLng,
      zoom: 15.8,
    );
    _markers = {};
    _latLng = latLng;
    _markers.add(Marker(
      icon: mapMarker!,
      markerId: MarkerId(latLng.toString()),
      position: latLng,
    ));
    _moveCamera(latLng);
    _animateCamera(latLng);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _moveCamera(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15.8)));
  }

  void _onFullMapCreated(GoogleMapController controller) {
    _fullMapController.complete(controller);
  }

  void _animateCamera(LatLng latLng) async {
    final GoogleMapController controller = await _fullMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15.8)));
  }

  void _captureData(XFile? lostFile) async {
    XFile? file;

    Location location = Location();

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    if (lostFile != null) {
      file = lostFile;
    } else if (widget.fileType != FileType.mic) {
      if (await Permission.camera.request().isGranted &&
          await Permission.location.request().isGranted) {
        final ImagePicker _picker = ImagePicker();
        file = widget.fileType == FileType.video
            ? await _picker.pickVideo(
                source: ImageSource.camera,
                maxDuration: const Duration(seconds: 10),
              )
            : await _picker.pickImage(source: ImageSource.camera);
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Debes aceptar los permisos para usar la aplicación'),
        ));
        return;
      }
    } else {
      file = XFile(widget.audioLocation!);
    }

    if (await Permission.location.request().isGranted) {
      LocationData _location = await location.getLocation();
      if (file != null) {
        geo.Placemark placemark = (await geo.placemarkFromCoordinates(
          _location.latitude!,
          _location.longitude!,
          localeIdentifier: "es_CL",
        ))
            .first;

        File? fileCaptured = File.fromUri(Uri(path: file.path));

        setState(() {
          _file = fileCaptured;
          _dateTime = FormatDate.dateTime(DateTime.now());
          _latLng = LatLng(_location.latitude!, _location.longitude!);
          _address =
              "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}";
          _kGooglePlex = CameraPosition(
            target: LatLng(_location.latitude!, _location.longitude!),
            zoom: 15.8,
          );
          _markers.add(Marker(
            icon: mapMarker!,
            markerId: MarkerId(_location.toString()),
            position: LatLng(_location.latitude!, _location.longitude!),
          ));
          if (widget.fileType == FileType.video) {
            _videoController = VideoPlayerController.network(_file!.path)
              ..initialize().then((_) {
                setState(() {}); //when your thumbnail will show.
              });
          }
        });
      } else {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Debes aceptar los permisos para usar la aplicación'),
      ));
      return;
    }
  }
}