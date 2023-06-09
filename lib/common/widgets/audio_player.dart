import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Source audioUrl;
  final double width;
  final double height;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    this.width = 100,
    this.height = 50,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer audioPlayer;
  PlayerState audioPlayerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() {
    audioPlayer.play(widget.audioUrl).then((value) {
      setState(() {
        audioPlayerState = PlayerState.playing;
      });
    });
  }

  void _pauseAudio() {
    audioPlayer.pause().then((value) {
      setState(() {
        audioPlayerState = PlayerState.paused;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (audioPlayerState == PlayerState.playing) {
          _pauseAudio();
        } else {
          _playAudio();
        }
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: audioPlayerState == PlayerState.playing
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
