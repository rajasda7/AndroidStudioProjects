import 'package:bloc/bloc.dart';

enum ScrollEvents{changeAppBarView}

class ScrollBloc extends Bloc<ScrollEvents, bool>{
  bool initial;
  ScrollBloc(this.initial);
  @override
  // TODO: implement initialState
  bool get initialState => initial;

  @override
  Stream<bool> mapEventToState(ScrollEvents event) async*{
    // TODO: implement mapEventToState
    switch(event){
      case ScrollEvents.changeAppBarView:
        yield state == false;
        break;
    }
  }

}