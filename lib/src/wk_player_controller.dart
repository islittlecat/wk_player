import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wk_player/src/wk_player_config.dart';
import 'package:wk_player/src/wk_player_controller_provider.dart';

class WkPlayerController extends ChangeNotifier {
  final WkPlayerConfig wkPlayerConfig;
  final VideoPlayerController videoPlayerController;

  bool get autoPlay => wkPlayerConfig.autoPlay;

  Duration get startAt => wkPlayerConfig.startAt;

  bool get looping => wkPlayerConfig.looping;

  List<DeviceOrientation> get deviceOrientationsOnFullScreen => wkPlayerConfig.deviceOrientationsOnFullScreen;

  List<SystemUiOverlay> get systemOverlaysAfterFullScreen => wkPlayerConfig.systemOverlaysAfterFullScreen;

  List<DeviceOrientation> get deviceOrientationsAfterFullScreen => wkPlayerConfig.deviceOrientationsAfterFullScreen;


  Widget Function(BuildContext context, String errorMessage) get errorBuilder =>
      wkPlayerConfig.errorBuilder;

  WkPlayerRoutePageBuilder get routePageBuilder => wkPlayerConfig.routePageBuilder;

  double get aspectRatio => wkPlayerConfig.aspectRatio;

  Widget get placeholder => wkPlayerConfig.placeholder;

  Widget get overlay => wkPlayerConfig.overlay;

  bool get fullScreenByDefault => wkPlayerConfig.fullScreenByDefault;

  bool get allowedScreenSleep => wkPlayerConfig.allowedScreenSleep;

  List<double> get playBackSpeeds => wkPlayerConfig.playBackSpeeds;

  bool _locked = false;
  bool _isFullScreen = false;

  StreamController _positionStreamController = StreamController();

  bool get locked => _locked;

  bool get isFullScreen => _isFullScreen;

  bool get isPlaying => videoPlayerController.value.isPlaying;

  Stream<Duration> get positionStream => _positionStreamController.stream;

  WkPlayerController({
    this.wkPlayerConfig,
    this.videoPlayerController,
  }) : assert(wkPlayerConfig != null, "wkPlayerConfig can't be null") {
    print('1111');
  }
  // if (betterPlayerDataSource != null) {
  //   setupDataSource(betterPlayerDataSource);
  // }

  ///定义一个便捷方法，方便子树中的widget获取共享数据
  static WkPlayerController of(BuildContext context) {
    final wkPlayerControllerProvider = context.dependOnInheritedWidgetOfExactType<WkPlayerControllerProvider>();
    return wkPlayerControllerProvider.controller;
  }

  Future<void> _fullScreenListener() async {
    if (videoPlayerController.value.isPlaying && !_isFullScreen) {
      enterFullScreen();
      videoPlayerController.removeListener(_fullScreenListener);
    }
  }

  void enterFullScreen() {
    _isFullScreen = true;
    notifyListeners();
  }

  void exitFullScreen() {
    _isFullScreen = false;
    notifyListeners();
  }

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  Future<void> togglePlay() async{
    if(isPlaying){
      await pause();
    }else {
      await play();
    }
  }

  Future<void> play() async {
    await videoPlayerController.play();
  }

  Future<void> pause() async {
    await videoPlayerController.pause();
  }

  ///设置播放倍速
  Future<void> setPlayBackSpeed(double speed) async {
    await videoPlayerController.setPlaybackSpeed(speed);
  }

  ///设置音量
  Future<void> setVolume(double volume) async {
    await videoPlayerController.setVolume(volume);
  }

  ///播放进度
  Future<void> seekTo(Duration duration) async {
    await videoPlayerController.seekTo(duration);
  }

  ///是否自动重播
  Future<void> setLoop(bool isLoop) async {
    await videoPlayerController.setLooping(isLoop);
  }

  ///是否锁屏禁止 所有事件
  void lockScreen(bool locked) {
    this._locked = locked;
    notifyListeners();
  }

  void updatePositionStream(Duration duration){
    _positionStreamController.add(duration);
  }

  @override
  void dispose() {
    _positionStreamController.close();
    super.dispose();
  }
}
