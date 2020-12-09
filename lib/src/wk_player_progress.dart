
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wk_player/src/wk_player_controller.dart';

class WkPlayerProgress extends StatefulWidget {
  final WkProgressColors colors;
  final WkPlayerController controller;

  WkPlayerProgress({Key key, WkProgressColors colors, this.controller})
      : colors = colors ?? WkProgressColors(),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WkPlayerProgressState();
  }
}

class _WkPlayerProgressState extends State<WkPlayerProgress> {
  VideoPlayerController get controller => widget.controller.videoPlayerController;
  bool _controllerWasPlaying = false;
 Duration _dragPosition;



  @override
  void initState() {
    controller.addListener(listener);
    super.initState();
  }

  // @override
  // void deactivate() {
  //   controller.removeListener(listener);
  //   super.deactivate();
  // }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  void listener () {
    setState(() {
    });
  }

  void seekToRelativePosition(Offset globalPosition, {end: false}) {
    final box = context.findRenderObject() as RenderBox;
    final Offset tapPos = box.globalToLocal(globalPosition);
    final double relative = tapPos.dx / box.size.width;
    final Duration position = controller.value.duration * relative;
    setState(() {
      _dragPosition = position;
    });
    if(end){
      controller.seekTo(position);
      setState(() {
        _dragPosition = null;
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragStart: (DragStartDetails details) {
          if (!controller.value.initialized) {
            return;
          }
          _controllerWasPlaying = controller.value.isPlaying;
          if (_controllerWasPlaying) {
            controller.pause();
          }

          // if (widget.onDragStart != null) {
          //   widget.onDragStart();
          // }
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (!controller.value.initialized) {
            return;
          }
          seekToRelativePosition(details.globalPosition);

          // if (widget.onDragUpdate != null) {
          //   widget.onDragUpdate();
          // }

        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if (_controllerWasPlaying) {
            controller.play();
          }

          // if (widget.onDragEnd != null) {
          //   widget.onDragEnd();
          // }
        },
        onTapDown: (TapDownDetails details) {
          if (!controller.value.initialized) {
            return;
          }
          seekToRelativePosition(details.globalPosition, end: true);
        },
      child: Container(
        height: 4.0,
        width: MediaQuery.of(context).size.width,
        child: CustomPaint(
          painter: _ProgressBarPainter(controller.value, widget.colors, position: _dragPosition),
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter(this.value, this.colors, {this.position});

  VideoPlayerValue value;
  WkProgressColors colors;
  Duration position;

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const height = 2.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, size.height / 2),
          Offset(size.width, size.height / 2 + height),
        ),
        const Radius.circular(4.0),
      ),
      colors.backgroundPaint,
    );
    if (!value.initialized) {
      return;
    }
    final double playedPartPercent =
        (position?.inMilliseconds?? value.position.inMilliseconds) / value.duration.inMilliseconds;
    final double playedPart =
        playedPartPercent > 1 ? size.width : playedPartPercent * size.width;
    for (final DurationRange range in value.buffered) {
      final double start = range.startFraction(value.duration) * size.width;
      final double end = range.endFraction(value.duration) * size.width;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(start, size.height / 2),
            Offset(end, size.height / 2 + height),
          ),
          const Radius.circular(4.0),
        ),
        colors.bufferedPaint,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, size.height / 2),
          Offset(playedPart, size.height / 2 + height),
        ),
        const Radius.circular(4.0),
      ),
      colors.playedPaint,
    );
    canvas.drawCircle(
      Offset(playedPart, size.height / 2 + height / 2),
      height * 3,
      colors.handlePaint,
    );
  }
}

class WkProgressColors {
  WkProgressColors({
    Color playedColor = const Color.fromRGBO(255, 0, 0, 0.7),
    Color bufferedColor = const Color.fromRGBO(30, 30, 200, 0.2),
    Color handleColor = const Color.fromRGBO(200, 200, 200, 1.0),
    Color backgroundColor = const Color.fromRGBO(200, 200, 200, 0.5),
  })  : playedPaint = Paint()..color = playedColor,
        bufferedPaint = Paint()..color = bufferedColor,
        handlePaint = Paint()..color = handleColor,
        backgroundPaint = Paint()..color = backgroundColor;

  final Paint playedPaint;
  final Paint bufferedPaint;
  final Paint handlePaint;
  final Paint backgroundPaint;

}
