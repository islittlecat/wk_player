import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wk_player/src/wk_player_controller.dart';

class WkPlayerPlayBtn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WkPlayerPlayBtnState();
  }
}

class _WkPlayerPlayBtnState extends State<WkPlayerPlayBtn>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  WkPlayerController get _wkPlayerController => WkPlayerController.of(context);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _init();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _init() {
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this)
          ..addStatusListener((status) {
            if (AnimationStatus.completed == status) {
            } else if (status == AnimationStatus.dismissed) {}
          });

    _animation = Tween(begin: 0.0, end: 1.0 * pi).animate(_animationController);
  }

  void _dispose() {
    _animation = null;
    _animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        return Transform.rotate(
          angle: _animation.value,
          child: child,
        );
      },
      child: InkWell(
        onTap: () {
          if (_wkPlayerController.isPlaying) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
          _wkPlayerController.togglePlay();
          setState(() {});
        },
        child: SizedBox(
          width: 40.0,
          height: 40.0,
          child: Center(
            child: Icon(
              _wkPlayerController.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
