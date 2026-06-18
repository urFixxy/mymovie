import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerScreen extends StatefulWidget {
  final String videoKey;

  const TrailerScreen({
    super.key,
    required this.videoKey,
  });

  @override
  State<TrailerScreen> createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
        ),
      ),
      builder: (context, player) {
        final isLandscape =
            MediaQuery.of(context).orientation ==
            Orientation.landscape;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: isLandscape
              ? null
              : AppBar(
                  backgroundColor: Colors.black,
                  title: const Text('Trailer'),
                ),
          body: SafeArea(
            child: Center(
              child: player,
            ),
          ),
        );
      },
    );
  }
}