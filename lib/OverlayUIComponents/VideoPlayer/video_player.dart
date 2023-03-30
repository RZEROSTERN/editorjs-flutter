import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Colors/Colors.dart';
import '../Fonts/Styles.dart';
import 'package:video_player/video_player.dart';

import 'custom_player_controls.dart';

class OverlayVideoPlayer extends StatefulWidget {
  final String videoFirebaseStoragePath;
  final String videoTitle;

  const OverlayVideoPlayer(
      {Key? key,
      required this.videoFirebaseStoragePath,
      required this.videoTitle})
      : super(key: key);

  @override
  State<OverlayVideoPlayer> createState() => _OverlayVideoPlayerState();
}

class _OverlayVideoPlayerState extends State<OverlayVideoPlayer> {
  late final VideoPlayerController _videoController;
  late final ChewieController _chewieVideoController;

  bool isInitialised = false;

  @override
  void initState() {
    _initVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieVideoController.dispose();
    super.dispose();
  }

  void _initVideoPlayer() async {
    String videoURL = await FirebaseStorage.instance
        .ref()
        .child(widget.videoFirebaseStoragePath)
        .getDownloadURL();

    _videoController = VideoPlayerController.network(videoURL);

    await _videoController.initialize();

    _chewieVideoController = ChewieController(
      videoPlayerController: _videoController,
      customControls: const OverlayVideoControls(),
      autoPlay: false,
      looping: false,
    );
    setState(() {
      isInitialised = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10.0),
            Text(
              widget.videoTitle,
              style: AppStyles.rubikBodyText,
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        (isInitialised)
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Chewie(controller: _chewieVideoController))
            : const Center(
                child: CircularProgressIndicator(
                    color: AppColors.overlayDarkOrange),
              )
      ],
    );
  }
}
