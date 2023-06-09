import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_content_controller.dart';

import 'package:video_player/video_player.dart';

class AdminPreviewVideo extends StatefulWidget {
  static String routeName = "/a/lesson/content/:content_guid";
  static String routePath = "/a/lesson/content";
  final String fileHash;
  final String videoUrl;

  const AdminPreviewVideo({
    super.key,
    required this.fileHash,
    required this.videoUrl,
  });

  @override
  State<AdminPreviewVideo> createState() => _AdminPreviewVideoState();
}

class _AdminPreviewVideoState extends State<AdminPreviewVideo> {
  final lessonContentController = Get.find<AdminLessonContentController>();
  late VideoPlayerController _controller;
  bool isFullScreen = false;
  bool controllerButtons = true;

  hideControllers() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        controllerButtons = false;
      });
    });
  }

  videoController() {
    setState(() {
      controllerButtons = !controllerButtons;
    });
    hideControllers();
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    super.initState();
    _controller = VideoPlayerController.network(
      widget.videoUrl,
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: _controller.value.isInitialized
          ? InkWell(
              onTap: () {
                videoController();
              },
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  if (controllerButtons)
                    Positioned(
                      top: isFullScreen ? 0 : 24,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black26,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isFullScreen = false;
                                  SystemChrome.setEnabledSystemUIMode(
                                    SystemUiMode.manual,
                                    overlays: [
                                      SystemUiOverlay.top,
                                      SystemUiOverlay.bottom,
                                    ],
                                  );
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                    DeviceOrientation.portraitDown,
                                  ]);
                                });
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: white,
                              ),
                            ),
                            Text(
                              widget.fileHash,
                              style: const TextStyle(
                                color: white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (controllerButtons)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black26,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: Theme.of(context).primaryColor,
                                backgroundColor: white,
                                bufferedColor: text2,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _controller.value.volume == 0
                                        ? Icons.volume_off
                                        : Icons.volume_up,
                                    color: white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _controller.setVolume(
                                          _controller.value.volume == 0
                                              ? 1
                                              : 0);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.fast_rewind,
                                    color: white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _controller.seekTo(
                                        _controller.value.position -
                                            const Duration(
                                              seconds: 10,
                                            ),
                                      );
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: white,
                                  ),
                                  onPressed: () {
                                    if (_controller.value.isPlaying) {
                                      hideControllers();
                                    }
                                    setState(() {
                                      _controller.value.isPlaying
                                          ? _controller.pause()
                                          : _controller.play();
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.fast_forward,
                                    color: white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _controller.seekTo(
                                        _controller.value.position +
                                            const Duration(
                                              seconds: 10,
                                            ),
                                      );
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFullScreen
                                        ? Icons.fullscreen_exit
                                        : Icons.fullscreen,
                                    color: white,
                                  ),
                                  onPressed: () {
                                    if (isFullScreen) {
                                      setState(() {
                                        isFullScreen = false;
                                        SystemChrome.setEnabledSystemUIMode(
                                          SystemUiMode.manual,
                                          overlays: [
                                            SystemUiOverlay.top,
                                            SystemUiOverlay.bottom,
                                          ],
                                        );
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.portraitUp,
                                          DeviceOrientation.portraitDown,
                                        ]);
                                      });
                                    } else {
                                      setState(() {
                                        isFullScreen = true;
                                        SystemChrome.setEnabledSystemUIMode(
                                          SystemUiMode.manual,
                                          overlays: [],
                                        );
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.landscapeLeft,
                                          DeviceOrientation.landscapeRight,
                                        ]);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            )
          : const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: white,
                  strokeWidth: 4.0,
                ),
              ),
            ),
    );
  }
}
