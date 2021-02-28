import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentIndex = 0;
  SwiperController swiperController = new SwiperController();
  // Methods
  Widget getPages(int index){
    switch(index){
      case 0:
        return Material(
          color: Colors.white,
          child: SafeArea(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Welcome!',textAlign: TextAlign.center, style: TextStyle(
                    fontSize: 30, fontFamily: 'Squada One' ),),
              ),
              
              Align(alignment: Alignment.center,
              child: Image.asset('assets/img_0.jpg'),
              ),
              Align(alignment: Alignment.bottomCenter,child: Padding(
                padding: const EdgeInsets.all(64.0),
                child: Text('Thanks for downloading our App'),
              ),)
            ],
          )),
        );
        break;
      case 1:
        return Material(
          color: Colors.white,
          child: SafeArea(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Awesome Wallpapers',textAlign: TextAlign.center, style: TextStyle(
                    fontSize: 28, fontFamily: 'Squada One' ),),
              ),
              Align(alignment: Alignment.center,
                child: Image.asset('assets/img_1.jpg'),
              ),
              Align(alignment: Alignment.bottomCenter,child: Padding(
                padding: const EdgeInsets.all(64.0),
                child: Text('Large Collection Of Wallpapers'),
              ),)
            ],
          )),
        );
        break;
        case 2:
      return Material(
        color: Colors.white,
        child: SafeArea(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Download and share',textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 28, fontFamily: 'Squada One' ),),
            ),
            Align(alignment: Alignment.center,
              child: Image.asset('assets/img_2.jpg'),
            ),
            Align(alignment: Alignment.bottomCenter,child: Padding(
              padding: const EdgeInsets.all(64.0),
              child: Text('Download and Share among your friends'),
            ),)
          ],
        )),
      );
      break;
      case 3:
      return Material(
        color: Colors.white,
        child: SafeArea(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Favourites',textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 30, fontFamily: 'Squada One' ),),
            ),
            Align(alignment: Alignment.center,
              child: Image.asset('assets/img_3.jpg'),
            ),
            Align(alignment: Alignment.bottomCenter,child: Padding(
              padding: const EdgeInsets.all(64.0),
              child: Text('Save to Favourites'),
            ),)
          ],
        )),
      );
      break;
      default:
        return Container();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Swiper(
            itemCount: 4,
              controller: swiperController,
              onIndexChanged: (index){
              setState(() {
                currentIndex = index;
              });
              },
              itemBuilder: (context, index){
            return getPages(index);
          },
            loop: false,
          pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
            color: Colors.grey,
              activeColor: Colors.blue,
              activeSize: 15
            )
          ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FlatButton(
              child: Text('Skip'),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
              child: Icon(currentIndex != 3 ? Icons.arrow_forward : Icons.check),
              onPressed: (){
              if(currentIndex != 3 ) swiperController.next();
              else Navigator.pop(context);
              setState(() {

              });
              },
            ),
          )
        ],
      ),
    );
  }
}
