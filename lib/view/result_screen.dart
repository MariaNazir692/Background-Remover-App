
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remove_bg/utills/string.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../utills/color.dart';

class ResultScreen extends StatelessWidget {
  final Uint8List image;
  const ResultScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _saveImage() async {
      final result = await ImageGallerySaver.saveImage(image);
      Fluttertoast.showToast(
          msg: "Image is Saved to Gallery",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

    void _shareImage() async {
      // Save the image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(image);

      // Check if permission to access external storage is granted
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
        status = await Permission.storage.status;
      }

      // Share the image using the share_plus plugin
      if (status.isGranted) {
        final xFile = XFile(file.path);
        await Share.shareXFiles([xFile]);

      } else {
        // Handle permission denied
      }
    }

    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        title: const Text(appName, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: appBarClr,
        toolbarHeight: 70,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [firstGradientClr, secondGradientClr, forthGradientClr],
            tileMode: TileMode.clamp,
            stops: [
              0.1,
              0.6,
              0.9,
            ],
          ),
        ),
        child: Column(

          children: [
            const SizedBox(height: 50,),
            CircleAvatar(
              backgroundColor: circleClr,
              radius: 40,
              child: Image.asset("assets/images/done.png", height: 40, width: 40,),
            ),
            const SizedBox(height: 20,),
            const Text(
              bg_removed,
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 250,
              width: double.infinity,
              child: Image.memory(image, fit: BoxFit.fill,),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save, color: Colors.white,size: 40,),
                onPressed: () {
                if(image!=null){
                  _saveImage();
                }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: btn2Clr,
                fixedSize: const Size(200, 70)),
                label: const Text(
                 save,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
                icon: const Icon(Icons.share, color: Colors.white,size: 40,),
                onPressed: () {

                    _shareImage();

                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: btn2Clr,
                    fixedSize: const Size(200, 70)),
                label: const Text(
                 share,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
