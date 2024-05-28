import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/models/song.dart';

class AudioPlayerManager {
  String songUrl;
  Stream<DurationState>? durationStateStream;
  final player = AudioPlayer();
  AudioPlayerManager({required this.songUrl});

  void init() {
    durationStateStream =
        Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
            player.positionStream,
            player.playbackEventStream,
            (position, playbackEvent) => DurationState(
                progress: position,
                buffer: playbackEvent.bufferedPosition,
                total: playbackEvent.duration));
    player.setUrl(songUrl);
  }

  void setAudioSourcePlay(List<Song> songs, int initialIndex) {
    final source = ConcatenatingAudioSource(
      children: songs
          .map((song) => AudioSource.uri(Uri.parse(song.source),
              tag: MediaItem(
                  id: song.id,
                  title: song.title,
                  artist: song.artist,
                  album: song.album,
                  artUri: Uri.parse(song.image))))
          .toList(),
    );
    player.setAudioSource(source, initialIndex: initialIndex);
  }

  void dispose() {
    player.dispose();
  }
}

class DurationState {
  final Duration progress;
  final Duration buffer;
  final Duration? total;
  DurationState({required this.progress, required this.buffer, this.total});
}
