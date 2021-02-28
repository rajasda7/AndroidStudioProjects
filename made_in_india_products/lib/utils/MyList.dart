import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Data.dart';
import 'MyFullList.dart';

class MyList extends StatefulWidget {
  String listName;
  MyList(this.listName);
  @override
  _MyListState createState() => _MyListState(this.listName);
}

class _MyListState extends State<MyList> {
  String listName;
  _MyListState(this.listName);
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> listItems;

  void getSubscription(){
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(listName);
    subscription = collectionReference.snapshots().listen((dataSnapshot) {
      print('Subscription listen Complete');
      listItems = dataSnapshot.docs;
      print(listItems);
      setState(() {});
    });
  }
  @override
  void initState() {
    super.initState();
    if(listItems == null) {
      getSubscription();
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70.withOpacity(0.9),
      appBar: AppBar(title: Text(listName),),
      body: SafeArea(
        child: listItems != null ? Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16,),
          child: GridView.builder(
            itemCount: listItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 10, crossAxisCount: 2, crossAxisSpacing: 10),
            itemBuilder: (BuildContext context, int index){
              String listItemName = listItems[index].get('name');
              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6.0
                  )],
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: listItems[index].get('url'),
                              height: 120,
                              placeholder: (context, url) => CircularProgressIndicator(),
                            ),
                            Text(listItemName, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => MyFullList(listName,listItemName)));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ) : Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
