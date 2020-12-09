import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wk_player/src/wk_player_controller.dart';

class WkPlayerPlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _wkPlayerController = WkPlayerController.of(context);
    return GestureDetector(
      onTap: () {
        _wkPlayerController.toggleFullScreen();
      },
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          child: Icon(
            _wkPlayerController.isFullScreen
                ? Icons.fullscreen_exit
                : Icons.fullscreen,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
