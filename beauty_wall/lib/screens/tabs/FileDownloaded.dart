import 'dart:io';
import 'package:beauty_wall/screens/fullScreens/FileDownloadedFullScreen.dart';
import 'package:beauty_wall/utils/helper/helper.dart';
import 'package:flutter/material.dart';

class FileDownloaded extends StatefulWidget {
  @override
  _FileDownloadedState createState() => _FileDownloadedState();
}

class _FileDownloadedState extends State<FileDownloaded> {

  // Instances
  final Directory directory = Directory(dataDirectory);
  List images;

  // Init $ Dispose
  @override
  void initState() {
    super.initState();
    if(images == null)
    setState(() {
      images = directory.listSync(recursive: true);
      //pt('downloaded img length : ${images.length}');
    });
  }
  @override
  Widget build(BuildContext context) {
    return images != null ? images.length == 0 ? SizedBox(width:MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height-200,child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.save_alt),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text('Your Downloads Will Go Here!'),
        ),
      ],
    )) : GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6, crossAxisSpacing: 4, mainAxisSpacing: 4),
        itemCount: images.length,
        padding: EdgeInsets.all(4),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index){
          String tag = 'dw$index';
          return Stack(
            children: <Widget>[
              SizedBox.expand(
                child: Hero(
                  tag: tag,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:Material(
                        color: Colors.black26,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => FileDownloadedFullScreen(images[index],tag)));
                          },
                          child: Image.file(images[index], fit: BoxFit.cover,),
                        ),
                      )),
                ),
              ),
            ],
          );
        }
    ) :  SizedBox(width:MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height-200,child: Center(child: CircularProgressIndicator()));
  }
}
