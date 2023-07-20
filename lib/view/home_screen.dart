import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remove_bg/utills/color.dart';
import 'package:remove_bg/utills/string.dart';
import 'package:remove_bg/view/result_screen.dart';

import '../repository/api_url.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imgPath = '';
  Uint8List? image;
  bool imgPicked = false;
  bool isloading=false;

  pickImg() async {
    final img = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (img != null) {
      imgPath = img.path;
      imgPicked = true;
      setState(() {});
    } else {
      if (kDebugMode) {
        print("Image not picked");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      final isLastindex = index == widgets.length - 1;
      setState(() => index = isLastindex ? 0 : index + 1);
    });
  }

  int index = 0;
  final widgets = [
    Image.asset(
      "assets/images/pic.png",
      width: double.infinity,
      height: 250,
      fit: BoxFit.fill,
      key: const Key('1'),
    ),
    Image.asset(
      "assets/images/img.png",
      width: double.infinity,
      height: 250,
      fit: BoxFit.fill,
      key: const Key('2'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
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
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                        color: appBarClr,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30))),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Center(
                          child: Text(
                        appName,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                      Container(
                        padding: const EdgeInsets.all(30.0),
                        child: AnimatedSwitcher(
                          switchOutCurve: Curves.decelerate,
                          switchInCurve: Curves.decelerate,
                          duration: const Duration(milliseconds: 2000),
                          reverseDuration: const Duration(milliseconds: 1000),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                          child: widgets[index],
                        ),
                      )
                    ],
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  pickImg();
                },
                child: imgPicked
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.file(
                              File(imgPath),
                              fit: BoxFit.fill,
                            )),
                      )
                    : Container(
                        padding: const EdgeInsets.all(30),
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: double.infinity,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          color: borderClr,
                          dashPattern: const [15, 10],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.image,
                                  size: 40,
                                ),
                                Text(
                                  selectImg,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: ()async{
                    if(imgPath.isNotEmpty){
                      setState(() {
                        isloading = true;
                      });
                      image = await ApiUrl.removeBg(imgPath);
                      if (image != null) {
                        isloading = false;
                        setState(() {});
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(image: image!),
                          ),
                        );
                      }
                    }else{
                      Fluttertoast.showToast(
                          msg: "Image not selected",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: btn1Clr,
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.65, 60)),
                  child:isloading ? const CircularProgressIndicator(color: Colors.white,): const Text(
                    removeBg,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
