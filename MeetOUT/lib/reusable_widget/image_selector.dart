import 'dart:convert';

import 'package:flutter/material.dart';

class ImageSelectionDialog extends StatelessWidget {
  final Function(String)? onImageSelected;

  const ImageSelectionDialog({super.key, this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      title: const Text('Select an Icon'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: SizedBox(
          height: 300,
          width: double.maxFinite,
          child: FutureBuilder<List<String>>(
            future: _getAssetImages(context, "assets/events_icons/"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<String>? imagePaths = snapshot.data;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: imagePaths!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (onImageSelected != null) {
                          onImageSelected!(imagePaths[index]);
                        }
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        imagePaths[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<String>> _getAssetImages(BuildContext context, String uri) async {
    var assetsFile =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);

    List<String> listImage = manifestMap.keys
        .where((String key) => key.contains('.png') && key.contains(uri))
        .toList();

    return listImage;
  }
}
