import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  final File? videoFile;

  const VideoPlayer({
    super.key,
    required this.videoUrl,
    this.videoFile,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  final _meeduPlayerController = MeeduPlayerController(
    controlsStyle: ControlsStyle.primary,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  _init() {
    if (widget.videoFile == null) {
      _meeduPlayerController.setDataSource(
        DataSource(
          type: DataSourceType.network,
          source: widget.videoUrl,
        ),
        autoplay: false,
      );
    } else {
      _meeduPlayerController.setDataSource(
        DataSource(
          type: DataSourceType.file,
          file: widget.videoFile!,
        ),
        autoplay: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: MeeduVideoPlayer(
        controller: _meeduPlayerController,
      ),
    );
  }
}
