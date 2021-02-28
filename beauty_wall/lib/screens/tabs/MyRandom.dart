import 'dart:async';
import 'package:beauty_wall/screens/fullScreens/FullScreen.dart';
import 'package:beauty_wall/screens/widgets/FavIcon.dart';
import 'package:beauty_wall/utils/bloc/ScrollBloc.dart';
import 'package:beauty_wall/utils/helper/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyRandom extends StatefulWidget {
  @override
  _MyRandomState createState() => _MyRandomState();
}

class _MyRandomState extends State<MyRandom> {
  // Instances
  List<String> collections = ['NatureWallpapers', 'LoveWallpapers', 'Space Wallpapers','Abstract', 'Car', 'Quotes','Main'];
  List<DocumentSnapshot> randomWL;
  bool doneSubscriptions = false;


  //Methods
  void getSubscription() async{
    for(int i = 0; i<collections.length; i++){
      StreamSubscription<QuerySnapshot> subscription;
      final CollectionReference collectionReference = Firestore.instance.collection(collections[i]);
      subscription = collectionReference.snapshots().listen((dataSnapshot){
        if(randomWL == null){
          randomWL = dataSnapshot.documents;
        } else{
          randomWL += dataSnapshot.documents;
          if(i==collections.length-1 && randomWL.length != 0){
            setState(() {
              //pt('set state called for doneSubscriptions $doneSubscriptions : ');
              //pt('random WL length is : ${randomWL.length}');
              randomMaxLength = randomWL.length;
              randomWL.shuffle();
              doneSubscriptions = true;
            });
          }

        }
      });
    }

  }

  // Init * Dispose
  @override
  void initState() {
    super.initState();
    getSubscription();
  }
  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return doneSubscriptions == true ? GridView.builder(
      padding: EdgeInsets.all(3),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6, crossAxisSpacing: 4, mainAxisSpacing: 4),
      itemCount: randomItems,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context,index){
        String imgUrl = randomWL[index].data['url'];
        String tag ='r$index';
        //pt('random items $randomItems');
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
                    child: FavIcon(imgUrl,'mr$index', 28.0, Colors.white)),
              ),
            )
          ],
        );

      },
    ) : SizedBox(width:MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height-200,child: Center(child: CircularProgressIndicator()));
  }
}


//StreamBuilder<List<String>>(
//stream: manager.contactListNow,
//builder: (context, snapshot) {
//List<String> contacts = snapshot.data;
//return ListView.separated(itemBuilder: (context, index){
//return ListTile(
//title: Text(contacts[index]),
//);
//}, separatorBuilder: (context, index)=> Divider() , itemCount: contacts.length);
//}
//)