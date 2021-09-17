import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/services/api_project.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/widgets/input.dart';
import 'package:urbansensor/src/widgets/navigators/back_app_bar.dart';
import 'package:urbansensor/src/widgets/title_page.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({Key? key, this.isEdit}) : super(key: key);
  final bool? isEdit;

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  TextEditingController textController = TextEditingController();
  bool isLoading = false;
  bool error = false;
  bool successful = false;

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TitlePage(
                  title: 'Crear Proyecto',
                  caption: 'Crea tu Proyecto y genera tus reportes.',
                  iconData: UniconsLine.folder_plus,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Input(
                      label: 'Nombre',
                      placeholder: 'Proyecto calles',
                      controller: textController,
                      func: (String value) {
                        if (value.length < 3) {
                          setState(() {
                            error = true;
                          });
                        } else {
                          setState(() {
                            error = false;
                          });
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'Debe tener minimo 3 caracteres.',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              color: error ? Palettes.rose : Palettes.gray3,
                            ),
                      ),
                    )
                  ],
                ),
              ),
              _createButton(context, textController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createButton(BuildContext ctx, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 52),
      child: Stack(
        children: [
          Positioned(
            left: -58,
            child: Image.asset(
              'assets/img/frame-square.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              height: 150,
            ),
          ),
          Positioned(
            right: -58,
            child: Image.asset(
              'assets/img/frame-square.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              height: 150,
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(error ? 10 : 100),
                color: error ? Palettes.rose : Palettes.lightBlue,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    bool validation = await validateInput(ctx);
                    if (!validation) {
                      setState(() {
                        error = true;
                        isLoading = false;
                      });
                      return;
                    }
                    await createProject(ctx);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: _getIcon(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getIcon() {
    return isLoading
        ? SizedBox(
            height: 50,
            width: 50,
            child: LoadingIndicator(
                indicatorType: Indicator.ballRotate,
                colors: const [Colors.white]))
        : successful
            ? const Icon(UniconsLine.check, color: Colors.white, size: 50)
            : error
                ? const Icon(UniconsLine.times, color: Colors.white, size: 50)
                : const Icon(UniconsLine.message,
                    color: Colors.white, size: 50);
  }

  Future<bool> validateInput(BuildContext context) async {
    String value = textController.text;
    FocusScope.of(context).unfocus();
    if (value.trim().isEmpty || value.length < 3) {
      setState(() {
        error = true;
      });
      return false;
    }

    setState(() {
      error = false;
    });
    return true;
  }

  Future createProject(BuildContext context) async {
    bool success = false;
    ApiProject api = ApiProject();

    Project? project =
        await api.createProject(name: textController.text, context: context);
    final scaffold = ScaffoldMessenger.of(context);

    if (project == null) {
      success = false;
      error = true;
      setState(() {
        successful = success;
        isLoading = false;
        textController.clear();
      });
      return;
    }

    await Future.delayed(const Duration(seconds: 1));
    scaffold.showSnackBar(const SnackBar(
      content: Text('Creado con éxito.'),
      duration: Duration(seconds: 1),
    ));

    await Navigator.popAndPushNamed(context, 'project', arguments: project);
  }
}
