import 'dart:async';
import 'dart:io';
import 'package:beauty_wall/screens/fullScreens/CategoriesFullScreen.dart';
import 'package:beauty_wall/screens/fullScreens/FullScreen.dart';
import 'package:beauty_wall/screens/widgets/FavIcon.dart';
import 'package:beauty_wall/utils/bloc/ScrollBloc.dart';
import 'package:beauty_wall/utils/helper/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beauty_wall/utils/sharedPreferences/FavouriteSharedPreference.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instance Variables
 StreamSubscription<QuerySnapshot> swiperSubscription;
 StreamSubscription<QuerySnapshot> categoriesSubscription;
 StreamSubscription<QuerySnapshot> homeSubscription;
 List<DocumentSnapshot> swiperWL;
 List<DocumentSnapshot> categoriesWL;
 List<DocumentSnapshot> homeWL;
 final CollectionReference swiperCollectionReference = Firestore.instance.collection('Swiper');
 final CollectionReference categoriesCollectionReference = Firestore.instance.collection('Home');
 final CollectionReference homeCollectionReference = Firestore.instance.collection('Main');
 FavouriteSharedPreference favouriteSharedPreference = new FavouriteSharedPreference();
 List<String> allKeys;
 List<String> allValues = [];

 //Init and Dispose\
 @override
  void initState() {
    super.initState();
    getSwiperSubscription();
    getCategoriesSubscription();
    getHomeSubscription();
    getDataDirectory();
  }
  @override
  void dispose() {
    swiperSubscription?.cancel();
    categoriesSubscription?.cancel();
    homeSubscription?.cancel();
   //pt('Subscription Disposed');
    super.dispose();
  }

// Methods
  void getSwiperSubscription() async{
    swiperSubscription = swiperCollectionReference.snapshots().listen((dataSnapshot){
      setState(() {
        //pt('Subscription Called updated wallpaper list for swiper');
        swiperWL = dataSnapshot.documents;
      });
    });
  }
  void getCategoriesSubscription() async{
   categoriesSubscription = categoriesCollectionReference.snapshots().listen((dataSnapshots){
     setState(() {
       //pt(' Set state called for categoriesSubscription');
       categoriesWL = dataSnapshots.documents;
     });
   });
  }
  void getHomeSubscription() async{
    homeSubscription = homeCollectionReference.snapshots().listen((dataSnapshot){
      setState(() {
        //pt('Subscription Called updated wallpaper list : Home');
        homeWL = dataSnapshot.documents;
        homeMaxLength = homeWL.length;
      });
    });
  }
  void getDataDirectory() async{
    if(dataDirectory == null){
      Directory dir = await getExternalStorageDirectory();
      dataDirectory = dir.path;
      //pt('Data directory is : $dataDirectory');
    }
  }

//Widgets
 @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white));

   // //pt('rebuild and homewl length : ${homeWL.length}');
    return (homeWL != null  && swiperWL != null && categoriesWL != null) ? (homeWL.length != 0  && swiperWL.length != 0 && categoriesWL.length != 0) ?  Column(
      children: <Widget>[
        Container(
          height: 225,
         // color: Colors.white,
          padding: EdgeInsets.all(4),
          child: Swiper(
            fade: 0.0,
            physics: ScrollPhysics(),
            itemBuilder: (BuildContext context, int index){
              String quality = 'crop=entropy&cs=srgb&dl=i.jpg&fit=crop&fm=jpg&h=360&w=640';
              String imgUrl = '${swiperWL[index]
                  .data['url']}';
              String tag = 'sw$index';
              return Stack(
                children: <Widget>[
                  Hero(
                    tag:tag,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Material(
                        color: Colors.black26,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => FullScreen(imgUrl,tag,'s$index'),
                            ));
                          },
                          child: CachedNetworkImage(
                            imageUrl: '$imgUrl$quality',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: swiperWL.length,
            pagination: SwiperPagination(
              margin: EdgeInsets.only(bottom: 18),
              builder:DotSwiperPaginationBuilder(
                activeColor: Colors.grey,size: 5, activeSize: 5,
              ),
            ),
            autoplay: true,
            scale:0.9,
            //viewportFraction: 0.8,
          ),
        ),
        Container(
          //color: Colors.white,
          height: 150,
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: categoriesWL.length,
            itemBuilder:(context, index){
              String tag = categoriesWL[index].data['tag'];
              String cName = categoriesWL[index].data['Cname'];
              String quality = 'crop=entropy&cs=srgb&dl=i.jpg&fit=crop&fm=jpg&h=360&w=640';
              String imgUrl = '${categoriesWL[index]
                  .data['url']}';
              ////pt('tag for $index img : $tag');
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                width: 150,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child:  GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return CategoriesFullScreen(cName, index,tag,0);
                              }
                          ));
                        },
                        child: Container(
                          child: Center(child: Text(tag, style: TextStyle(fontFamily: 'Squada One', color: Colors.white, fontSize:30, fontWeight: FontWeight.w600),),),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black26,
                            image: DecorationImage( image: CachedNetworkImageProvider('$imgUrl$quality'), fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              );
            },
          ),
        ),
        GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6, crossAxisSpacing: 4, mainAxisSpacing: 4),
            itemCount: homeItems,
            padding: EdgeInsets.all(4),
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index){

              String imgUrl = '${homeWL[index]
                  .data['url']}';
              String tag = 'h$index';
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
                                  builder: (context) => FullScreen(imgUrl,tag,'h$index')));
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
                          child: FavIcon(imgUrl,'h$index', 28.0, Colors.white)),
                    ),
                  )
                ],
              );
            }
        ),
      ],
    ) : SizedBox(width:MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height-200,child: Center(child: CircularProgressIndicator())): SizedBox(width:MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height-200,child: Center(child: CircularProgressIndicator()))
    ;
  }
}
