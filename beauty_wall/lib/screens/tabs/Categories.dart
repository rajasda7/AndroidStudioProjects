import 'dart:async';
import 'package:beauty_wall/screens/fullScreens/CategoriesFullScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Instance Variables
  StreamSubscription<QuerySnapshot> subscription;
  CollectionReference collectionReference = Firestore.instance.collection('Home');
  List<DocumentSnapshot> categoriesWL;

  // Init and Dispose
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
  void getSubscription() async{
    subscription =  collectionReference.snapshots().listen((dataSnapshot){
      setState(() {
        categoriesWL = dataSnapshot.documents;
      });
    });
}

  @override
  Widget build(BuildContext context) {
    return categoriesWL != null ? categoriesWL.length != 0 ? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,childAspectRatio: 2.5, mainAxisSpacing: 4),
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        itemCount: categoriesWL.length,
        physics: ScrollPhysics(),
        itemBuilder: (context, index){
          String tag = categoriesWL[index].data['tag'];
          String cName = categoriesWL[index].data['Cname'];
          String imgUrl = '${categoriesWL[index]
              .data['url']}';
          return  Container(
            child:  GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return CategoriesFullScreen(cName,index,tag,1);
                  }
                ));
              },
              child: Container(
                child: Align(alignment:Alignment.bottomLeft, child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(tag, style: TextStyle(fontFamily: 'Squada One', color: Colors.white, fontSize:30, fontWeight: FontWeight.w600),),
                ),),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black26,
                  image: DecorationImage( image: CachedNetworkImageProvider('${imgUrl}crop=entropy&cs=srgb&dl=i.jpg&fit=crop&fm=jpg&h=360&w=640', ), fit: BoxFit.cover),
                ),
              ),
            ),
          );
        },
    ):SizedBox(width:MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height-200,child: Center(child: CircularProgressIndicator())): SizedBox(width:MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height-200,child: Center(child: CircularProgressIndicator()));
  }
}
