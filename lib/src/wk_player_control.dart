import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wk_player/src/wk_player_controller.dart';
import 'package:wk_player/src/wk_player_play_btn.dart';
import 'package:wk_player/src/wk_player_play_screen.dart';
import 'package:wk_player/src/wk_player_progress.dart';

class WkPlayerControl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _WkPlayerControlState();
  }
}

class _WkPlayerControlState extends State<WkPlayerControl> {
  WkPlayerController get _wkPlayerController => WkPlayerController.of(context);

  calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
  }

  Widget buildControl(BuildContext context, WkPlayerController controller) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildTop(),
          buildBottom(),
        ],
      ),
    );
  }

  Widget buildTop() {
    return Container(
      height: 40,
      decoration: BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              if (_wkPlayerController.isFullScreen) ...[
                GestureDetector(
                  onTap: () {
                    _wkPlayerController.toggleFullScreen();
                  },
                  child: Icon(
                    Icons.arrow_left_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ]
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Icon(
                    Icons.headset,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setPlayBackState();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Icon(
                    Icons.more_horiz_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildMiddle() {
    return Container();
  }

  void setPlayBackState() async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(8), right: Radius.circular(8)),
            ),
            child: Stack(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  child: Text('倍速设置'),
                ),
                Container(
                  padding: EdgeInsets.only(top: 40, left: 10, right: 10),
                  child: ListView.builder(
                      itemCount: _wkPlayerController.playBackSpeeds.length,
                      itemExtent: 40.0, //强制高度为50.0
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (){
                            _wkPlayerController.setPlayBackSpeed(_wkPlayerController.playBackSpeeds[index]);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              _wkPlayerController.playBackSpeeds[index]
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                    BorderSide(color: index != _wkPlayerController.playBackSpeeds.length - 1 ? Colors.grey[300] : Colors.transparent))),
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        });
  }

  Widget buildBottom() {
    return Container(
      height: _wkPlayerController.isFullScreen ? 70.0 : 40.0,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ///进度条
          if (_wkPlayerController.isFullScreen) ...[
            WkPlayerProgress(
              controller: _wkPlayerController,
            ),
          ],
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // WkPlayerProgress(controller: controller),
              Row(
                children: [
                  WkPlayerPlayBtn(),
                ],
              ),
              if (!_wkPlayerController.isFullScreen) ...[
                Expanded(
                  child: WkPlayerProgress(
                    controller: _wkPlayerController,
                  ),
                  flex: 1,
                )
              ],
              Row(
                children: [WkPlayerPlayScreen()],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: AspectRatio(
          aspectRatio: calculateAspectRatio(context),
          child: Stack(
            children: <Widget>[
              _wkPlayerController.placeholder ?? Container(),
              Center(
                child: AspectRatio(
                  aspectRatio: _wkPlayerController.aspectRatio ??
                      _wkPlayerController
                          .videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_wkPlayerController.videoPlayerController),
                ),
              ),
              _wkPlayerController.overlay ?? Container(),
              if (_wkPlayerController.isFullScreen) ...[
                buildControl(context, _wkPlayerController)
              ] else ...[
                SafeArea(
                  child: buildControl(context, _wkPlayerController),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
