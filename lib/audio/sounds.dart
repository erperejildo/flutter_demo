import 'package:audioplayers/audioplayers.dart';

class Sounds {
  final List<AudioPlayer> list = []; // just in case we have more sounds

  Future<void> initSounds() async {
    list.add(AudioPlayer());
    await list[0].setSource(AssetSource(
        'audio/soundtrack.mp3')); // we'd have a loop for all the sounds
  }

  Future<void> playBackground() async {
    await list[0]
        .resume(); // to make it simpler, we know the soundtrack is the first one
  }

  Future<void> stopBackground() async {
    await list[0].pause();
  }
}

final Sounds sounds = Sounds();
