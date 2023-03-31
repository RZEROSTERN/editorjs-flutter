import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../Colors/Colors.dart';
import '../Fonts/Styles.dart';

class OverlayAudioPlayer extends StatefulWidget {
  final String audioFirebaseStoragePath;
  final String audioTitle;
  final Function pauseOtherAudioPlayers;

  const OverlayAudioPlayer({
    Key? key,
    required this.audioFirebaseStoragePath,
    required this.audioTitle,
    required this.pauseOtherAudioPlayers,
  }) : super(key: key);

  @override
  State<OverlayAudioPlayer> createState() => _OverlayAudioPlayerState();
}

class _OverlayAudioPlayerState extends State<OverlayAudioPlayer> {
  AudioPlayer audioPlayer = AudioPlayer();
  late StreamSubscription<Duration?> durationSubscription;
  late StreamSubscription<Duration?> positionSubscription;
  late StreamSubscription<PlayerState> playerStateSubscription;

  // late StreamSubscription<Duration?> bufferedSubscription;

  Duration? _duration;
  Duration? _position;

  // Duration? _bufferedPosition;

  bool isInitialised = false;

  @override
  void initState() {
    _initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    durationSubscription.cancel();
    positionSubscription.cancel();
    playerStateSubscription.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  void _initAudioPlayer() async {
    String audioURL = await FirebaseStorage.instance
        .ref()
        .child(widget.audioFirebaseStoragePath)
        .getDownloadURL();

    await audioPlayer.setUrl(audioURL);
    durationSubscription = audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    positionSubscription = audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    playerStateSubscription =
        audioPlayer.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.completed) {
        await audioPlayer.seek(Duration.zero);
        await audioPlayer.pause();
      }
    });

    // bufferedSubscription =
    //     audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
    //   setState(() {
    //     _bufferedPosition = bufferedPosition;
    //   });
    // });

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
              widget.audioTitle,
              style: AppStyles.rubikBodyText,
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Container(
            height: 55.0,
            padding: const EdgeInsets.only(left: 10.0, right: 25.0),
            decoration: BoxDecoration(
                color: AppColors.audioPlayerGrey,
                borderRadius: BorderRadius.circular(50.0)),
            child: (isInitialised)
                ? Row(
                    children: [
                      IconButton(
                          splashRadius: 1,
                          icon: (audioPlayer.processingState ==
                                  ProcessingState.buffering)
                              ? Icon(Icons.play_arrow, color: Colors.grey)
                              : (audioPlayer.playing
                                  ? Icon(Icons.pause)
                                  : Icon(Icons.play_arrow)),
                          onPressed: () async {
                            // Button does nothing if buffering
                            if (audioPlayer.processingState ==
                                ProcessingState.buffering) {
                            } else {
                              if (audioPlayer.playing) {
                                await audioPlayer.pause();
                              } else {
                                widget.pauseOtherAudioPlayers(audioPlayer);
                                await audioPlayer.play();
                              }
                            }
                          }),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: AppColors.overlayLightOrange,
                            inactiveTrackColor:
                                AppColors.overlayDarkOrange.withOpacity(0.2),
                            trackShape: OverlayAudioTrackShape(),
                            trackHeight: 3.5,
                            thumbColor: AppColors.overlayDarkOrange,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6.0),
                            overlayColor:
                                AppColors.overlayDarkOrange.withOpacity(0.1),
                          ),
                          child: Slider(
                            value: _position?.inSeconds.toDouble() ?? 0.0,
                            min: 0.0,
                            max: _duration?.inSeconds.toDouble() ?? 0.0,
                            onChanged: (double seekPosition) async {
                              await audioPlayer.seek(
                                  Duration(seconds: seekPosition.toInt()));
                            },
                            onChangeEnd: (_) async {
                              widget.pauseOtherAudioPlayers(audioPlayer);
                              await audioPlayer.play();
                            },
                          ),
                        ),
                      ),
                      formatDuration(_position, _duration),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.overlayDarkOrange),
                  )),
      ],
    );
  }

  Widget formatDuration(Duration? position, Duration? duration) {
    if (position == null || duration == null) {
      return const Text('--:-- / --:--');
    }

    String positionString = position.toString().split('.').first;
    String durationString = duration.toString().split('.').first;

    List<String> positionComponents = positionString.split(':');
    List<String> durationComponents = durationString.split(':');

    int positionHours = int.parse(positionComponents[0]);
    int durationHours = int.parse(durationComponents[0]);

    String formattedPosition = '';
    String formattedDuration = '';

    if (positionHours > 0) {
      formattedPosition += '${positionHours.toString().padLeft(2, '0')}:';
    }

    formattedPosition +=
        '${positionComponents[positionComponents.length - 2].padLeft(2, '0')}:';
    formattedPosition +=
        positionComponents[positionComponents.length - 1].padLeft(2, '0');

    if (durationHours > 0) {
      formattedDuration += '${durationHours.toString().padLeft(2, '0')}:';
    }

    formattedDuration +=
        '${durationComponents[durationComponents.length - 2].padLeft(2, '0')}:';
    formattedDuration +=
        durationComponents[durationComponents.length - 1].padLeft(2, '0');

    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: formattedPosition,
        style: AppStyles.rubikAudioPlayerBold,
      ),
      TextSpan(
        text: ' / $formattedDuration',
        style: AppStyles.rubikAudioPlayerNormal,
      )
    ]));
  }
}

///Overriding the RoundedRectSliderTrackShape class to make the active/inactive track height the same
class OverlayAudioTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required TextDirection textDirection,
      required Offset thumbCenter,
      Offset? secondaryOffset,
      bool isDiscrete = false,
      bool isEnabled = false,
      double additionalActiveTrackHeight = 0}) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
      textDirection: textDirection,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
      thumbCenter: thumbCenter,
    );
  }
}
