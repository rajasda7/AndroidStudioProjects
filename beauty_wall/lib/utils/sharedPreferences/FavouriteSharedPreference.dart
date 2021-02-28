import 'package:shared_preferences/shared_preferences.dart';

class FavouriteSharedPreference{
  putFavSharedValue(String key, String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    //pt('Saved to shared pref $key : $value');
  }

  Future<String> getFavSharedValue(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key);
  //  //pt('getted from shared pref of key $key == $value');
    return value;
  }

  Future<bool> containKey(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool contains = prefs.containsKey(key);
    return contains;
  }


  Future<List<String>> getAllKeys() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys;
    keys = prefs.getKeys();
    return keys.toList();
  }

  void removeFavValue(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }


}