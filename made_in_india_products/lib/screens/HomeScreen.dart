import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:made_in_india_products/utils/Data.dart';
import 'package:made_in_india_products/utils/MyList.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instances
  String text = 'Done';
  StreamSubscription<QuerySnapshot> subscription;
  StreamSubscription<QuerySnapshot> searchItemSubscription;
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection("Categories");
  final CollectionReference searchItemCollectionReference = FirebaseFirestore.instance.collection("SearchItemsList");

  // Init & Dispose
  @override
  void initState() {
    super.initState();
    debugPrint('init called');                  // debug print used
    subscription = collectionReference.snapshots().listen((dataSnapshot) {
      //if(dataSnapshot.)
      print('subscription set state called');
      categoriesList = dataSnapshot.docs;
      text = categoriesList.length.toString();
      print('length of list is $text');
      // var imgPath = categoriesList[0].data();
      // print(imgPath);
      setState(() {
        print('set state of homeScreen subscription called');
        print(categoriesList.contains('Gadgets'));
      });
    });
    searchItemSubscription = searchItemCollectionReference.snapshots().listen((dataSnapshot) {
      searchItemsList = dataSnapshot.docs;
      for(int i=0; i<searchItemsList.length; i++){
        searchItemsStringList.add('0');
        searchItemsStringList[i] =searchItemsList[i].get('name');
      }
      print('list of strings created.. $searchItemsStringList');
      setState(() {
        print('set state of serchItem subscription called');
      });
    });
    print('init called after subscription line');      // debug print used

  }

  @override
  void dispose() {
    subscription?.cancel();
    searchItemSubscription?.cancel();
    print('subscription close caled');   // debug print called
    super.dispose();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return categoriesList != null ? Stack(
      children: <Widget>[
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            color: Colors.orangeAccent.shade700,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 90, bottom: 20),
          height: 279,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(160),
              bottomLeft: Radius.circular(290),
              bottomRight: Radius.circular(160),
              topRight: Radius.circular(10),
            ),
            color: Colors.orangeAccent.shade400,
          ),
        ),
        CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(26.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Good Morning', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),),
                    Text('Everyone', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 32, color: Colors.white),),
                    SizedBox(
                      height: 40,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: TextField(
                        controller: TextEditingController(text: 'Search...'),
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(suffixIcon: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Icon(Icons.search),
                        ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(26.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((BuildContext context, int index){
                  return  Container(
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
                                  imageUrl: categoriesList[index].get('url'),
                                  height: 120,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                ),
                                Text(categoriesList[index].get('name'), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, CupertinoPageRoute(builder: (context) => MyList(categoriesList[index].get('name'))));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: categoriesList.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              ),
            ),
          ],
        ),
      ],
    ) : CircularProgressIndicator();
  }

}




