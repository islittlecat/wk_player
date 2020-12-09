import 'package:flutter/material.dart';
import 'package:wk_player/src/wk_player_controller.dart';

class WkPlayerControllerProvider extends InheritedWidget{

  final WkPlayerController controller;


  WkPlayerControllerProvider({Key key, @required this.controller,  @required Widget child}): assert(controller != null),
        assert(child != null),
        super(key: key, child: child);



  @override
  bool updateShouldNotify(WkPlayerControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
  
}