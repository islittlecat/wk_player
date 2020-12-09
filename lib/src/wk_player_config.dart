import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:wk_player/src/wk_player_controller_provider.dart';


typedef WkPlayerRoutePageBuilder = Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    WkPlayerControllerProvider controllerProvider,
    );

class WkPlayerConfig {

  ///是否自动播放
  final bool autoPlay;

  ///初始播放时间
  final Duration startAt;

  ///初始化之前widget
  final Widget placeholder;

  ///是否重播
  final bool looping;

  ///是否开启静音
  final bool mute;

  ///播放速率
  final double playBackSpeed;

  ///音量
  final double volume;

  ///默认全屏
  final bool fullScreenByDefault;

  ///允许息屏
  final bool allowedScreenSleep;

  ///视频比例
  final double aspectRatio;

  ///最外层
  final Widget overlay;

  /// Defines the set of allowed device orientations on entering fullscreen
  final List<DeviceOrientation> deviceOrientationsOnFullScreen;

  /// Defines the system overlays visible after exiting fullscreen
  final List<SystemUiOverlay> systemOverlaysAfterFullScreen;

  /// Defines the set of allowed device orientations after exiting fullscreen
  final List<DeviceOrientation> deviceOrientationsAfterFullScreen;


  ///加载错误builder
  final Widget Function(BuildContext context, String errorMessage) errorBuilder;

  final WkPlayerRoutePageBuilder routePageBuilder;

  final List<double> playBackSpeeds;

  WkPlayerConfig({
    this.autoPlay = false,
    this.startAt,
    this.placeholder,
    this.looping = false,
    this.mute = false,
    this.playBackSpeed,
    this.volume,
    this.fullScreenByDefault = false,
    this.allowedScreenSleep = false,
    this.aspectRatio,
    this.overlay,
    this.errorBuilder,
    this.routePageBuilder,
    this.playBackSpeeds = const [0.5,0.75,1.0,1.25,1.5,1.75,2],
    this.deviceOrientationsOnFullScreen = const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
    this.systemOverlaysAfterFullScreen = SystemUiOverlay.values,
    this.deviceOrientationsAfterFullScreen = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
  });


  WkPlayerConfig copyWith({
    bool autoPlay,
    Duration startAt,
    Widget placeholder,
    bool looping,
    bool mute,
    double playBackSpeed,
    double volume,
    bool fullScreenByDefault,
    bool allowedScreenSleep,
    double aspectRatio,
    Widget overlay,
    Widget Function(BuildContext context, String errorMessage) errorBuilder,
    WkPlayerRoutePageBuilder routePageBuilder,
    List<double> playBackSpeeds,
  }){
    return WkPlayerConfig(
      autoPlay: autoPlay ?? this.autoPlay,
      startAt: startAt ?? this.startAt,
      placeholder: placeholder ?? this.placeholder,
      looping: looping ?? this.looping,
      mute: mute ?? this.mute,
      playBackSpeed: playBackSpeed ?? this.playBackSpeed,
      volume: volume ?? this.volume,
      fullScreenByDefault: fullScreenByDefault ?? this.fullScreenByDefault,
      allowedScreenSleep: allowedScreenSleep ?? this.allowedScreenSleep,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      overlay: overlay ?? this.overlay,
      errorBuilder: errorBuilder ?? this.errorBuilder,
        routePageBuilder: routePageBuilder ?? this.routePageBuilder,
        playBackSpeeds: playBackSpeeds ?? this.playBackSpeeds
    );
  }


}