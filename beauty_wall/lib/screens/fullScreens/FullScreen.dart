import 'dart:io';
import 'package:beauty_wall/screens/widgets/FavIcon.dart';
import 'package:beauty_wall/utils/bloc/ScrollBloc.dart';
import 'package:beauty_wall/utils/helper/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FullScreen extends StatefulWidget {
  String imgUrl;
  String tag;
  String index;
  FullScreen(this.imgUrl, this.tag, this.index);
  @override
  _FullScreenState createState() => _FullScreenState(this.imgUrl, this.tag, this.index);
}

class _FullScreenState extends State<FullScreen> {
  String imgUrl;
  String tag;
  String index;
  _FullScreenState(this.imgUrl, this.tag, this.index);

  // Instances
  static const platform = const MethodChannel('wallpaperChannel');
  bool isFileExist = false;
  bool getImg = false;
  double downloadProgress = 1;
  String name;

  // Methods
  void showBottomDialog(context){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (context){
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(title: Text('Home Screen'),onTap: (){
                  Navigator.pop(context);
                  if(!isFileExist){
                    setState(() {
                      getImg = true;
                    });
                    downloadImage(0,1);
                  }else{
                      setWallpaper(1);
                  }
                },),
                ListTile(title: Text('Lock Screen'),onTap: (){
                  Navigator.pop(context);
                  if(!isFileExist){
                    setState(() {
                      getImg = true;
                    });
                    downloadImage(0,2);
                  }else{
                    setWallpaper(2);
                  }
                },),
                ListTile(title: Text('Both Home & Lock'),onTap: (){
                  Navigator.pop(context);
                  if(!isFileExist){
                    setState(() {
                      getImg = true;
                    });
                    downloadImage(0,3);
                  }else{
                    setWallpaper(3);
                  }
                },)
              ],
            ),
          );
        }
    );
  }
  void fileExist() async{
    if(name == null){
      int id = imgUrl.lastIndexOf('/');
      name = 'IMG_${imgUrl.substring(33,id)}.jpeg';
      //pt('name is : $name 0f $id $imgUrl');
    }
    File file = File('$dataDirectory/$name');
    isFileExist = await file.exists();
    setState(() {
    });
  }
  void downloadImage(int sender, int wallpaperType) async{
    if(!isFileExist && dataDirectory != null) {
      //pt('Downloading img');
      Dio dio = new Dio();
      File file = File('$dataDirectory/$name');
      await dio.download('${imgUrl}crop=entropy&cs=srgb&dl=a.jpg&fit=crop&fm=jpg&h=3222&w=2048', '$dataDirectory/$name',onReceiveProgress:(rec, total){
        setState(() {
          downloadProgress = ((rec/total) * 100);
        });
      }).catchError((e){
        file.delete(recursive: true);
      });
      setState(() {
        getImg = false;
        switch(sender){
          case 0:
            setWallpaper(wallpaperType);
            isFileExist = true;
            break;
          case 1:
            isFileExist = true;
            Fluttertoast.showToast(msg: 'Image Downloaded');
            break;
          case 2:
            isFileExist = true;
            saveToGallery();
            break;
          case 3:
            isFileExist = true;
            shareImage();
            break;
        }
      });
    }
  }
  Future<void> setWallpaper(int wallpaperType) async{
    try{
       await platform.invokeMethod('setWallpaper', ['$dataDirectory/$name',wallpaperType]);
      //pt('Set wallpaper successful');
      Fluttertoast.showToast(msg: 'Set Wallpaper Successful'
      );

    } on PlatformException catch (e){
      //pt('Failed to set wallpaper ${e.message}');
      Fluttertoast.showToast(msg: 'Something Went Wrong');
    }
  }
  void saveToGallery() async{
    await getPermission().whenComplete(() async{
      //pt('when complete called');
      Directory downloadsDirectory;
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
      var path = downloadsDirectory.path;
      var file = File('$dataDirectory/$name');
      Directory directory = Directory('$path/Wallpapers');
      bool isExist = await directory.exists();
      if(isExist){
        file.copy('$path/Wallpapers/$name').then((v){
          Fluttertoast.showToast(msg: 'Saved to Gallery');
          Future.delayed((Duration(seconds: 2))).then((f){
            Fluttertoast.showToast(msg: '$path/Wallpapers/$name');
          });
        }).catchError((e){
          //pt('Access Denied unable to save to gallery');
          Fluttertoast.showToast(msg: 'Unable to save to gallery');
        });
      } else{
        directory.create().then((v){
          file.copy('$path/Wallpapers/$name').then((v){
            Fluttertoast.showToast(msg: 'Saved to Gallery');
            Future.delayed((Duration(seconds: 2))).then((f){
              Fluttertoast.showToast(msg: '$path/Wallpapers/$name');
            });
          }).catchError((e){
            //pt('Access Denied');
            Fluttertoast.showToast(msg: 'Unable to save to gallery');
          });
        }).catchError((e){
          file.copy('$path/$name').then((v){
            Fluttertoast.showToast(msg: 'Saved to Gallery');
            Future.delayed((Duration(seconds: 2))).then((f){
              Fluttertoast.showToast(msg: '$path/Wallpapers/$name');
            });
          });
        });
      }

    });
  }
  void shareImage() async{
    File file = File('$dataDirectory/$name');
    await Share.file('Share Image', 'Image.jpeg', file.readAsBytesSync(), 'image/jpeg', text: 'Get more from : https://play.google.com/store/apps/details?id=com.rktechhub.beauty_wall');
    //pt('shared image');
  }
  // Init and dispose
  @override
  void initState() {
    super.initState();
    fileExist();
  }

  // Widgets & UI
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        SizedBox.expand(
          child: Hero(
            tag: tag,
            child: Material(
              color: Colors.black26,
              child: isFileExist ? Image.file(File('$dataDirectory/$name'),fit: BoxFit.cover,): CachedNetworkImage(
                imageUrl: '${imgUrl}crop=entropy&cs=srgb&dl=i.jpg&fit=crop&fm=jpg&h=402&w=256',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.black26,
                    child: Center(child: CircularProgressIndicator())),
              ),
            ),
          ),
        ),
        Visibility(
          visible: getImg,
          child: Align(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap:(){
                    },
                    child: CircularPercentIndicator(
                      percent: downloadProgress/100,
                      radius: 60,
                      lineWidth: 7,
                      center: Text('${downloadProgress.toInt().toString()}%',style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                      progressColor: Colors.blueGrey,
                    ),
                  ),
                ),
                Center(child: Container(margin: EdgeInsets.only(top: 200),child: Material(type:MaterialType.transparency,child: Text('Downloading HD Image', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),),)
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 56,
            child: Material(
              color: Colors.white,
              child: Wrap(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.image,size: 30,color: Colors.blueGrey,),
                        tooltip: 'Set as Wallpaper',
                        onPressed: (){
                          showBottomDialog(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.file_download,size: 30,color: Colors.blueGrey,),
                        tooltip: 'Get HD Image',
                        onPressed: (){
                          if(!isFileExist){
                            setState(() {
                              getImg = true;
                              downloadImage(1, 0);
                            });
                          } else{
                            Fluttertoast.showToast(msg: 'Image Downloaded');
                          }
                        },
                      ),
                      BlocProvider<ScrollBloc>(
                          create:(context) => ScrollBloc(false),
                          child: FavIcon(imgUrl,index, 28.0, Colors.blueGrey)),

                      IconButton(
                        icon: Icon(Icons.save_alt,size: 30,color: Colors.blueGrey,),
                        tooltip: 'Save to Gallery',
                        onPressed: (){
                          if(!isFileExist){
                            setState(() {
                              getImg = true;
                              downloadImage(2, 0);
                            });
                          } else{
                            saveToGallery();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.share,size: 30,color: Colors.blueGrey,),
                        tooltip: 'Share Image',
                        onPressed: (){
                            if(!isFileExist){
                              setState(() {
                                getImg = true;
                                downloadImage(3, 0);
                              });
                            } else{
                              shareImage();
                            }
                        },
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
