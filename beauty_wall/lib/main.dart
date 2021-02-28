import 'dart:async';

import 'package:beauty_wall/screens/fullScreens/WelcomeScreen.dart';
import 'package:beauty_wall/screens/tabs/Categories.dart';
import 'package:beauty_wall/screens/tabs/Favourites.dart';
import 'package:beauty_wall/screens/tabs/FileDownloaded.dart';
import 'package:beauty_wall/screens/tabs/MyRandom.dart';
import 'package:beauty_wall/utils/bloc/ScrollBloc.dart';
import 'package:beauty_wall/utils/helper/helper.dart';
import 'package:beauty_wall/utils/sharedPreferences/FavouriteSharedPreference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launch_review/launch_review.dart';
import 'screens/tabs/HomeScreen.dart';

void main(){
  runApp(  MaterialApp(
    title: 'AwesomeWall',
    debugShowCheckedModeBanner: false,
    home: GetScreen(),
    theme: ThemeData(
      primaryColor: Colors.white,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
    ),
  ));

}

class GetScreen extends StatefulWidget {
  @override
  _GetScreenState createState() => _GetScreenState();
}

class _GetScreenState extends State<GetScreen> {

  Future doWelcome() async{
    bool seen =  await FavouriteSharedPreference().containKey('welcomed');
    //pt('seen : $seen');

    if(seen){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BlocProvider<ScrollBloc>(
          create: (context) => ScrollBloc(true),
          child: MainScreen()
      )));
    }else{
      await Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      FavouriteSharedPreference().putFavSharedValue('welcomed', 'true');
        doWelcome();
    }
  }

  @override
  void initState() {
    super.initState();
   Timer(Duration(milliseconds: 200), (){doWelcome();});
  }
  @override
  Widget build(BuildContext context) {
    //Timer(Duration(milliseconds: 200), (){doWelcome();});
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Instance Variables
  int _currentTabIndex = 0;
  bool isScrollingDown = false;
  ScrollController scrollController = new ScrollController();

  // Methods
  Widget getTabScreen(int index){
    switch (index){
      case 0:
        return HomeScreen();
        break;
      case 1:
        return CategoriesScreen();
        break;
      case 2:
        return Favourites();
      case 3:
        return MyRandom();
      case 4:
        return FileDownloaded();
      default: return Center();
    }
  }
  String getTitle(int index){
    switch (index){
      case 0:
        return 'Home';
      case 1:
        return 'Categories';
      case 2:
        return 'Favourites';
      case 3:
        return 'Random';
      case 4:
        return 'Downloads';
      default:
        return 'Home';
    }
  }
  void myScroll() async{
    scrollController.addListener((){

      if(scrollController.position.userScrollDirection == ScrollDirection.reverse){
        if(!isScrollingDown){
          isScrollingDown = true;
          BlocProvider.of<ScrollBloc>(context).add(ScrollEvents.changeAppBarView);
        }
      }
      if(scrollController.position.userScrollDirection == ScrollDirection.forward){
        if(isScrollingDown){
          isScrollingDown = false;
          BlocProvider.of<ScrollBloc>(context).add(ScrollEvents.changeAppBarView);

        }
      }

      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent-100){
        //pt('max extent ${scrollController.position.pixels}');
          switch(_currentTabIndex) {
            case 0:
              if(homeItems < homeMaxLength)
                if(homeMaxLength-homeItems < 10){
                  setState(() {
                    homeItems = homeMaxLength;
                  });
                } else{
                  setState(() {
                    homeItems += 10;
                  });
                }
              break;
            case 3:
              if(randomItems < randomMaxLength)
                if(randomMaxLength-randomItems < 10){
                  setState(() {
                    randomItems = randomMaxLength;
                  });
                } else{
                  setState(() {
                    randomItems += 10;
                  });
                }
              break;
        }

      }
      //_counterBloc.close();
    });
  }

// Init and Dispose
  @override
  void initState() {
    super.initState();
    getPermission();
    myScroll();
  }
  @override
  void dispose() {
    scrollController.removeListener((){});
    super.dispose();
  }

// Widgets / UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child:Column(
          children: <Widget>[
            SafeArea(child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('assets/img_logoo.png', height: 80,),
            )),
            ListTile(leading: Icon(Icons.home),title: Text('Home'),onTap: (){
              setState(() {
                Navigator.pop(context);
                _currentTabIndex = 0;
            });

            },),
            ListTile(leading: Icon(Icons.category),title: Text('Categories'),onTap: (){setState(() {
              Navigator.pop(context);
              _currentTabIndex = 1;
            });},),
            ListTile(leading: Icon(Icons.favorite_border),title: Text('Favourites'),onTap: (){setState(() {
              Navigator.pop(context);
              _currentTabIndex = 2;
            });},),
            ListTile(leading: Icon(Icons.shuffle),title: Text('Random'),onTap: (){setState(() {
              Navigator.pop(context);
              _currentTabIndex = 3;
            });},),
            ListTile(leading: Icon(Icons.favorite),title: Text('Rate this App'),onTap: (){LaunchReview.launch();},),

          ],
        ),
      ),
      appBar:  PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,56),
        child: BlocBuilder<ScrollBloc,bool>(
          builder: (BuildContext context, bool state){
            return Visibility(
              visible: state,
              child: AppBar(
                title: Text(getTitle(_currentTabIndex)),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: (){
                      _currentTabIndex = 2;
                      setState(() {

                      });
                    },
                  )
                ],
                elevation: 0,
              ),
            );
          },
        ),
      ),
      body:  SingleChildScrollView(
          controller: scrollController,
          child: getTabScreen(_currentTabIndex)),
      bottomNavigationBar: BlocBuilder<ScrollBloc, bool>(
        builder: (context, state){
          return Visibility(
            visible: state,
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home,),title: Text(''),),
                BottomNavigationBarItem(icon: Icon(Icons.category),title: Text('')),
                BottomNavigationBarItem(icon: Icon(Icons.favorite),title: Text('')),
                BottomNavigationBarItem(icon: Icon(Icons.shuffle),title: Text('')),
                BottomNavigationBarItem(icon: Icon(Icons.file_download),title: Text('')),
              ],
              currentIndex: _currentTabIndex,
              selectedIconTheme: IconThemeData(size: 30),
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.black,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index){
                setState(() {
                  _currentTabIndex = index;
                });
              },
            ),
          );
        },
      ) ,
    );
  }
}

