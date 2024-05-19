import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

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

  void updateUrl(String url) {
    songUrl = url;
    init();
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