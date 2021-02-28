import 'package:beauty_wall/screens/fullScreens/FullScreen.dart';
import 'package:beauty_wall/screens/widgets/FavIcon.dart';
import 'package:beauty_wall/utils/bloc/ScrollBloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:beauty_wall/utils/sharedPreferences/FavouriteSharedPreference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  FavouriteSharedPreference favouriteSharedPreference = new FavouriteSharedPreference();
  List<String> keys;

  @override
  void initState() {
    super.initState();
    getAllKeys();
  }

  void getAllKeys() async{
    keys = await favouriteSharedPreference.getAllKeys();
    keys.remove('welcomed');
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return keys != null ? keys.length == 0 ? SizedBox(width:MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height-200,child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.favorite_border),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text('Your Favourites Will Go Here!'),
        ),
      ],
    )) : GridView.builder(
      padding: EdgeInsets.all(3),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6, crossAxisSpacing: 4, mainAxisSpacing: 4),
      itemCount: keys.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context,index){
        String imgUrl = keys[index];
        String tag ='f$index';
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
                              builder: (context) => FullScreen(imgUrl,tag,'f$index')));
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
