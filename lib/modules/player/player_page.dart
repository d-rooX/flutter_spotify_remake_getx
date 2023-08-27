import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/modules/player/controllers/player_controller.dart';

class PlayerPage extends GetView<PlayerController> {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<PlayerController>(
        builder: (controller) {
          if (controller.currentTrack.value == null) {
            return const CircularProgressIndicator();
          }
          return _LoadedPlayerPage(track: controller.currentTrack.value!);
        },
      ),
    );
  }
}

class _LoadedPlayerPage extends StatelessWidget {
  final Track track;
  const _LoadedPlayerPage({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        track.name!,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
