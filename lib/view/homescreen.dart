import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remove_bg/repository/api_url.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var loaded=false;
  var removebg=false;
  var isloading=false;

  String imgPath='';
  Uint8List? image;

   pickImg()async{
     final img=await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);

     if(img!=null){
       imgPath=img.path;
       loaded=true;
       setState(() {});
     }else{

     }
  }


  Future<void> _saveImage() async {
    final result = await ImageGallerySaver.saveImage(image!);
    Fluttertoast.showToast(
        msg: "Image is Saved to Gallery",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0
    );
    // Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){
              if(image==null){
                Fluttertoast.showToast(
                    msg: "Image is empty",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }else{
                _saveImage();
              }
            },
            icon: const Icon(Icons.save),
          )
        ],
        leading: const Icon(Icons.sort),
        title: const Text(
          "AI Background Remover",
        ),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: Center(
      child: removebg? Image.memory(image!): loaded ?Container(
            height: MediaQuery.of(context).size.height*0.70,
            child: GestureDetector(
                onTap: (){
                  pickImg();
                },
                child: Image.file(File(imgPath))),
          ):ElevatedButton(onPressed: () {
            pickImg();
          }, child: const Text("Select an Image")),

      ),
      bottomNavigationBar:  SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: loaded?()async {

              setState(() {
                isloading=true;
              });

              image=await ApiUrl.removeBg(imgPath);
              if(image!=null){
                removebg=true;
                isloading=false;
                setState(() {});
              }
            }:null,
            child: isloading ? CircularProgressIndicator(color: Colors.white,): Text("Remove Background"),

          )),
    );
  }
}
