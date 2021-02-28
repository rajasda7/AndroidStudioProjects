import 'dart:async';
import 'package:beauty_wall/screens/widgets/FavIcon.dart';
import 'package:beauty_wall/utils/bloc/ScrollBloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'FullScreen.dart';

class CategoriesFullScreen extends StatefulWidget {
  String cName;
  int cIndex;
  String tag;
  int caller;
  CategoriesFullScreen(this.cName, this.cIndex, this.tag,this.caller);
  @override
  _CategoriesFullScreenState createState() => _CategoriesFullScreenState(this.cName, this.cIndex,this.tag,this.caller);
}

class _CategoriesFullScreenState extends State<CategoriesFullScreen> {
  String cName;
  int cIndex;
  String tag;
  int caller;
  _CategoriesFullScreenState(this.cName, this.cIndex, this.tag, this.caller);

  // Instances
  StreamSubscription<QuerySnapshot> subscription;
  CollectionReference collectionReference;
  List<DocumentSnapshot> categoriesFullScreenWL;
  int items = 10;

  // Init and Disposed
  @override
  void initState() {
    super.initState();
    getSubscription();
  }
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
  // Methods
  void getSubscription(){
    collectionReference = Firestore.instance.collection(cName);
    subscription = collectionReference.snapshots().listen((dataSnapshot){
      setState(() {
        //pt('$cName subscription categoriesFullScreen Called');
        categoriesFullScreenWL = dataSnapshot.documents;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(tag),
      ),
      body:categoriesFullScreenWL != null ?NotificationListener<ScrollNotification>(

          onNotification: (scrollNotification){
            //pt('on notification');
            if(scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent){

                if(items < categoriesFullScreenWL.length)
                  if(categoriesFullScreenWL.length-items < 10){
                    setState(() {
                      items = categoriesFullScreenWL.length;
                    });
                  } else{
                    setState(() {
                      items += 10;
                    });
                  }

            }
            return true;
          },
          child:  GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6, crossAxisSpacing: 4, mainAxisSpacing: 4),
          itemCount: items,
          padding: EdgeInsets.all(4),
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index){
            String imgUrl = '${categoriesFullScreenWL[index]
                .data['url']}';
            String tag = 'cf$cName$index$caller';
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
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => FullScreen(imgUrl, tag, '$cIndex$index'),
                              ));
                            },
                            child: CachedNetworkImage(
                              imageUrl: '${imgUrl}crop=entropy&cs=srgb&dl=i.jpg&fit=crop&fm=jpg&h=402&w=256',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(),
                            ),
                          ),
                        )),
                  ),
                ),
                Align(
                  alignment:Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocProvider<ScrollBloc>(
                        create:(context) => ScrollBloc(false),
                        child: FavIcon(imgUrl,'h$index',28.0,Colors.white)),
                  ),
                )
              ],
            );
          }
      )):Center(child: CircularProgressIndicator(),),
    );
  }
}
