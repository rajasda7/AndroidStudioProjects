import 'package:beauty_wall/utils/sharedPreferences/FavouriteSharedPreference.dart';
import 'package:beauty_wall/utils/bloc/ScrollBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavIcon extends StatefulWidget {
  String imgUrl;
  String index;
  double size;
  Color color;
  FavIcon(this.imgUrl, this.index, this.size, this.color);
  @override
  _FavIconState createState() => _FavIconState(this.imgUrl, this.index, this.size, this.color);
}

class _FavIconState extends State<FavIcon> {
  // Constructor
  String imgUrl;
  String index;
  double size;
  Color color;
  _FavIconState(this.imgUrl, this.index, this.size, this.color);

  // Instances
  FavouriteSharedPreference favouriteSharedPreference = new FavouriteSharedPreference();

  @override
  void initState() {
    super.initState();
    initialIsFav();
  }

  initialIsFav() async {
    bool contains = await FavouriteSharedPreference().containKey(imgUrl);
    if (contains) {
      BlocProvider.of<ScrollBloc>(context).add(ScrollEvents.changeAppBarView);
      //pt('contains $index : $imgUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScrollBloc, bool>(builder: (context, snapshot) {
      // initialIsFav(_MyBloc);
      bool favIcon = snapshot;
      return favIcon == false
          ? GestureDetector(
              onTap: () {
                favouriteSharedPreference.putFavSharedValue(imgUrl, index);
                BlocProvider.of<ScrollBloc>(context).add(ScrollEvents.changeAppBarView);
                //pt('$imgUrl 0f $index added to shared preference  $snapshot');
              },
              child: Icon(
                Icons.favorite_border,
                color: color,
                size: size,
              ))
          : GestureDetector(
              onTap: () {
                favouriteSharedPreference.removeFavValue(imgUrl);
                BlocProvider.of<ScrollBloc>(context).add(ScrollEvents.changeAppBarView);
                //pt('$imgUrl of $index removed from SP  $snapshot');
              },
              child: Icon(
                Icons.favorite,
                color: color,
                size: size,
              ));
    });
  }
}
