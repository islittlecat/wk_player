import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wk_player/src/wk_player_control.dart';
import 'package:wk_player/src/wk_player_controller.dart';
import 'package:wk_player/src/wk_player_controller_provider.dart';

class WkPlayer extends StatefulWidget {

  final WkPlayerController controller;

  const WkPlayer({Key key, @required this.controller}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return new _WkPlayerState();
  }

}

class _WkPlayerState extends State <WkPlayer> {

  bool _isFullScreen = false;

  @override
  void initState() {
    widget.controller.addListener(listener);
    super.initState();
  }


  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WkPlayer oldWidget) {
    if (oldWidget.controller != widget.controller) {
      widget.controller.addListener(listener);
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _buildFullScreenVideo(
      BuildContext context,
      Animation<double> animation,
      WkPlayerControllerProvider controllerProvider,
      ) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: controllerProvider,
      ),
    );
  }

  AnimatedWidget _defaultRoutePageBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      WkPlayerControllerProvider controllerProvider,
      ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return _buildFullScreenVideo(context, animation, controllerProvider);
      },
    );
  }

  Widget _fullScreenRoutePageBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    final controllerProvider = WkPlayerControllerProvider(
      controller: widget.controller,
      child: WkPlayerControl(),
    );

    if (widget.controller.routePageBuilder == null) {
      return _defaultRoutePageBuilder(context, animation, secondaryAnimation, controllerProvider);
    }
    return widget.controller.routePageBuilder(context, animation, secondaryAnimation, controllerProvider);
  }

  Future<dynamic> _pushFullScreenWidget(BuildContext context) async {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final TransitionRoute<Null> route = PageRouteBuilder<Null>(
      settings: RouteSettings(),
      pageBuilder: _fullScreenRoutePageBuilder,
      opaque: true,
    );

    SystemChrome.setEnabledSystemUIOverlays([]);

    var aspectRatio =
        widget?.controller?.videoPlayerController?.value?.aspectRatio ??
            1.0;
    List<DeviceOrientation> deviceOrientations;
    if (aspectRatio < 1.0) {
      deviceOrientations = [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ];
    } else {
      deviceOrientations = [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ];
    }
    SystemChrome.setPreferredOrientations(deviceOrientations);

    if (!widget.controller.allowedScreenSleep) {
      Wakelock.enable();
    }

    await Navigator.of(context, rootNavigator: true).push(route);
    _isFullScreen = false;
    widget.controller.exitFullScreen();

    // The wakelock plugins checks whether it needs to perform an action internally,
    // so we do not need to check Wakelock.isEnabled.
    Wakelock.disable();

    SystemChrome.setEnabledSystemUIOverlays(
        widget.controller.systemOverlaysAfterFullScreen);
    SystemChrome.setPreferredOrientations(
        widget.controller.deviceOrientationsAfterFullScreen);
  }


  Future<void> listener() async {
    if (widget.controller.isFullScreen && !_isFullScreen) {
      _isFullScreen = true;
      await _pushFullScreenWidget(context);
    } else if (_isFullScreen) {
      Navigator.of(context, rootNavigator: true).pop();
      _isFullScreen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WkPlayerControllerProvider(controller: widget.controller, child: WkPlayerControl());
  }

}