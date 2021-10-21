import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/user.dart';
import 'package:urbansensor/src/preferences/user_preferences.dart';
import 'package:urbansensor/src/services/api_auth.dart';
import 'package:urbansensor/src/utils/loading_indicators_c.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/utils/text_style_c.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    final _caption = Theme.of(context)
        .textTheme
        .caption!
        .copyWith(fontWeight: FontWeight.w300, color: Palettes.gray3);

    ApiAuth apiAuth = ApiAuth();

    apiAuth.getMyUser(context);

    User? user = UserPreferences().getUser;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 52),
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
          Positioned(
            left: MediaQuery.of(context).size.width / 2 + 60,
            top: 25,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                await uploadFile(context, apiAuth);
              },
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  UniconsLine.image_plus,
                  color: Palettes.lightBlue,
                  size: 30,
                ),
              ),
            ),
          ),
          Center(
            child: IntrinsicHeight(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: user?.avatar != null
                        ? CachedNetworkImage(
                            imageUrl: user!.avatar!,
                            errorWidget: (context, url, error) =>
                                const Text('Error'),
                            placeholder: (context, url) =>
                                LoadingIndicatorsC.ballScale,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          )
                        : Image.asset(
                            'assets/img/anid.png',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${user?.name} ${user?.lastName}',
                              style: TextStyleC.bodyText1(
                                  context: context, fontWeight: 'semi')),
                          Text('${user?.email}', style: _caption),
                          Text(
                            'Plan ${user?.plan?.name}',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: Palettes.lightBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> uploadFile(BuildContext context, ApiAuth apiAuth) async {
    final ImagePicker _picker = ImagePicker();
    final scaffold = ScaffoldMessenger.of(context);

    // Pick an image
    // Capture a photo
    // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (await Permission.storage.request().isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File? avatarToUpload = File.fromUri(Uri(path: image.path));

        bool res = await apiAuth.uploadAvatar(
            context: context, avatarFile: avatarToUpload);

        if (res) {
          scaffold.showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: Palettes.lightBlue,
            content: const Text('Subido con exito'),
          ));

          setState(() {});
        } else {
          scaffold.showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: Palettes.lightBlue,
            content: const Text('Error en la subida'),
          ));
        }
      }
    }

    return true;
  }
}
