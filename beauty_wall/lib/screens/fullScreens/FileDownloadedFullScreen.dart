import 'dart:io';
import 'package:beauty_wall/utils/helper/helper.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FileDownloadedFullScreen extends StatefulWidget {
  File image;
  String tag;
  FileDownloadedFullScreen(this.image, this.tag);
  @override
  _FileDownloadedFullScreenState createState() => _FileDownloadedFullScreenState(this.image, this.tag,);
}

class _FileDownloadedFullScreenState extends State<FileDownloadedFullScreen> {
  File image;
  String tag;
  _FileDownloadedFullScreenState(this.image, this.tag);

  // Instances
  static const platform = const MethodChannel('wallpaperChannel');
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
                    setWallpaper(1);
                },),
                ListTile(title: Text('Lock Screen'),onTap: (){
                  Navigator.pop(context);
                    setWallpaper(2);
                },),
                ListTile(title: Text('Both Home & Lock'),onTap: (){
                  Navigator.pop(context);
                    setWallpaper(3);
                },)
              ],
            ),
          );
        }
    );
  }
  Future<void> setWallpaper(int wallpaperType) async{
    try{
      await platform.invokeMethod('setWallpaper', [image.path,wallpaperType]);
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
      Directory directory = Directory('$path/Wallpapers');
      bool isExist = await directory.exists();
      if(isExist){
        image.copy('$path/Wallpapers/$name').then((v){
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
          image.copy('$path/Wallpapers/$name').then((v){
            Fluttertoast.showToast(msg: 'Saved to Gallery');
            Future.delayed((Duration(seconds: 2))).then((f){
              Fluttertoast.showToast(msg: '$path/Wallpapers/$name');
            });
          }).catchError((e){
            //pt('Access Denied');
            Fluttertoast.showToast(msg: 'Unable to save to gallery');
          });
        }).catchError((e){
          image.copy('$path/$name').then((v){
            Fluttertoast.showToast(msg: 'Saved to Gallery');
            Future.delayed((Duration(seconds: 2))).then((f){
              Fluttertoast.showToast(msg: '$path/$name');
            });
          });
        });
      }

    });
  }
  void shareImage() async{
    await Share.file('Share Image', 'Image.jpeg', image.readAsBytesSync(), 'image/jpeg', text: 'Get more from : https://play.google.com/store/apps/details?id=com.rktechhub.beauty_wall');
    //pt('shared image');
  }

  // Init and dispose
  @override
  void initState() {
    super.initState();
    setState(() {
      name = image.path.split('/').last;
    });
    //pt('image name : $name');
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
              child: Image.file(image,fit: BoxFit.cover,),
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
                        icon: Icon(Icons.save_alt,size: 30,color: Colors.blueGrey,),
                        tooltip: 'Save to Gallery',
                        onPressed: (){
                          saveToGallery();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.share,size: 30,color: Colors.blueGrey,),
                        tooltip: 'Share Image',
                        onPressed: (){
                            shareImage();
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
