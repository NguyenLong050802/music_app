import 'dart:math';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_flutter/ui/custom/custom_icon_buttom.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';
import 'package:music_app_flutter/ui/nowplaying/audio_player_manager.dart';
import '../../data/models/song.dart';
import '../custom/custom_list.dart';

class NowPlaying extends StatefulWidget {
  final List<Song> songList;
  final Song playingSong;
  const NowPlaying({
    super.key,
    required this.songList,
    required this.playingSong,
  });

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying>
    with SingleTickerProviderStateMixin {
  late AudioPlayerManager _audioPlayerManager;
  late int _selectedSongIndex;
  late Song _song;
  late AnimationController _animationController;
  double _currentAnimationPosition = 0.0;
  late MusicAppViewModles _appViewModles;

  @override
  void initState() {
    super.initState();
    _song = widget.playingSong;
    _audioPlayerManager = AudioPlayerManager(songUrl: _song.source);
    _selectedSongIndex = widget.songList.indexOf(_song);
    _audioPlayerManager.init();
    _audioPlayerManager.setAudioSourcePlay(widget.songList, _selectedSongIndex);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 50000));
    _appViewModles = MusicAppViewModles();
  }

  @override
  void dispose() {
    _audioPlayerManager.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    const denta = 64;
    final radius = (screenWidth - denta) / 2;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        middle: Text(
          'Now Playing',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        trailing: MediaIconButton(
          icon: Icons.more_horiz_rounded,
          color: Colors.deepPurple,
          onPressed: () {
            showBottomSheetSong(context, _song);
          },
        ),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: screenHeight * 0.08),
                Column(
                  children: [
                    Text(_song.album,
                        style: Theme.of(context).textTheme.titleMedium),
                    const Text('__ ___ _'),
                  ],
                ),
                const SizedBox(height: 30),
                RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/itunes.jfif',
                      image: _song.image,
                      width: screenWidth - denta,
                      height: screenWidth - denta,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/itunes.jfif',
                          height: screenWidth - denta,
                          width: screenWidth - denta,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MediaIconButton(
                      icon: Icons.share_rounded,
                      color: Colors.deepPurple,
                      size: 35,
                      onPressed: _shareSong,
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _showDialog('Title', _song.title);
                              },
                            );
                          },
                          style: TextButton.styleFrom(
                            maximumSize: Size.fromWidth(screenWidth - 120),
                          ),
                          child: Text(
                            _song.title,
                            style: Theme.of(context).textTheme.titleMedium!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _showDialog('Artist', _song.artist);
                              },
                            );
                          },
                          style: TextButton.styleFrom(
                            maximumSize: Size.fromWidth(screenWidth - 120),
                          ),
                          child: Text(
                            _song.artist,
                            style: Theme.of(context).textTheme.titleMedium!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    ValueListenableBuilder<bool?>(
                        valueListenable: _song.favorite,
                        builder: (_, value, __) {
                          return MediaIconButton(
                            icon: _song.favorite.value == true
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: _song.favorite.value == true
                                ? Colors.red
                                : Colors.deepPurple,
                            size: 35,
                            onPressed: () async {
                              _appViewModles.updateFavoriteState(_song);
                              addFavoriteSong(_song);
                            },
                          );
                        }),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _progressBar(),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _mediaButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: _audioPlayerManager.durationStateStream,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffer = durationState?.buffer ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          total: total,
          buffered: buffer,
          onSeek: _audioPlayerManager.player.seek,
          barHeight: 8.0,
          baseBarColor: Colors.grey[600],
          bufferedBarColor: Colors.grey,
          progressBarColor: Colors.red,
          thumbColor: Colors.red,
          timeLabelTextStyle: const TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
        );
      },
    );
  }

  Widget _mediaButton() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _suffleMode(),
          MediaIconButton(
            icon: Icons.skip_previous_rounded,
            size: 50,
            color: Colors.deepPurple,
            onPressed: _setPreSong,
          ),
          _playButton(),
          MediaIconButton(
            icon: Icons.skip_next_rounded,
            size: 50,
            color: Colors.deepPurple,
            onPressed: _setNextSong,
          ),
          _loodModeButtom(),
        ],
      ),
    );
  }

  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder<PlayerState>(
      stream: _audioPlayerManager.player.playerStateStream,
      builder: ((context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.buffering ||
            processingState == ProcessingState.loading) {
          _pauseAnimation();
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 58,
            height: 58,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return MediaIconButton(
            icon: Icons.play_arrow_rounded,
            color: Colors.deepPurple,
            size: 58,
            onPressed: () {
              _audioPlayerManager.player.play();
              updateSong();
            },
          );
        } else if (processingState != ProcessingState.completed) {
          _playAnimation();
          return MediaIconButton(
            icon: Icons.pause,
            color: Colors.deepPurple,
            size: 58,
            onPressed: () {
              _audioPlayerManager.player.pause();
              _pauseAnimation();
            },
          );
        } else {
          if (processingState == ProcessingState.completed) {
            _stopAnimation();
            _resetAnimation();
          }
          return MediaIconButton(
            icon: Icons.replay,
            color: Colors.deepPurple,
            size: 58,
            onPressed: () {
              _audioPlayerManager.player.seek(Duration.zero, index: 0);
              _resetAnimation();
              _playAnimation();
            },
          );
        }
      }),
    );
  }

  void _setNextSong() {
    if (_appViewModles.isSuffle.value == true) {
      var random = Random();
      _selectedSongIndex = random.nextInt(widget.songList.length);
    } else {
      ++_selectedSongIndex;
    }
    if (_selectedSongIndex >= widget.songList.length) {
      _selectedSongIndex = _selectedSongIndex % widget.songList.length;
    }
    final nextSong = widget.songList[_selectedSongIndex];
    _audioPlayerManager.setAudioSourcePlay(widget.songList, _selectedSongIndex);
    _resetAnimation();
    setState(() {
      _song = nextSong;
    });
  }

  void _setPreSong() {
    if (_appViewModles.isSuffle.value == true) {
      var random = Random();
      _selectedSongIndex = random.nextInt(widget.songList.length);
    } else {
      --_selectedSongIndex;
    }
    if (_selectedSongIndex < 0) {
      _selectedSongIndex = widget.songList.length - 1;
    }
    final preSong = widget.songList[_selectedSongIndex];
    _audioPlayerManager.setAudioSourcePlay(widget.songList, _selectedSongIndex);
    _resetAnimation();
    setState(() {
      _song = preSong;
    });
  }

  StreamBuilder<bool> _suffleMode() {
    return StreamBuilder<bool>(
      stream: _audioPlayerManager.player.shuffleModeEnabledStream,
      builder: (context, snapshot) {
        _appViewModles.isSuffle.value = snapshot.data ?? false;
        return _setSuffleMode();
      },
    );
  }

  Widget _setSuffleMode() {
    return ValueListenableBuilder<bool?>(
        valueListenable: _appViewModles.isSuffle,
        builder: (_, value, __) {
          return MediaIconButton(
            icon: Icons.shuffle,
            size: 35,
            onPressed: () {
              _appViewModles.updateSuffleState();
              _audioPlayerManager.player
                  .setShuffleModeEnabled(_appViewModles.isSuffle.value);
            },
            color: _getSuffleIconColor(),
          );
        });
  }

  Color? _getSuffleIconColor() {
    return _appViewModles.isSuffle.value == true
        ? Colors.red
        : Colors.deepPurple;
  }

  StreamBuilder<LoopMode> _loodModeButtom() {
    return StreamBuilder<LoopMode>(
      stream: _audioPlayerManager.player.loopModeStream,
      builder: (context, snapshot) {
        final loopMode = snapshot.data ?? LoopMode.off;
        const icons = [
          Icon(Icons.repeat, color: Colors.deepPurple),
          Icon(Icons.repeat_one, color: Colors.red),
          Icon(Icons.repeat, color: Colors.red),
        ];
        const cycleModes = [
          LoopMode.off,
          LoopMode.one,
          LoopMode.all,
        ];
        final index = cycleModes.indexOf(loopMode);
        return MediaIconButton(
          icon: icons[index].icon!,
          size: 35,
          onPressed: () {
            _audioPlayerManager.player
                .setLoopMode(cycleModes[(index + 1) % cycleModes.length]);
          },
          color: icons[index].color,
        );
      },
    );
  }

  void updateSong() {
    _audioPlayerManager.player.currentIndexStream.listen((index) {
      setState(() {
        _selectedSongIndex = index!;
        _song = widget.songList[_selectedSongIndex];
      });
    });
  }

  Widget _showDialog(String title, String content) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: const Text('Exit'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _playAnimation() {
    _animationController.forward(from: _currentAnimationPosition);
    _animationController.repeat(
      period: const Duration(milliseconds: 50000),
    );
  }

  void _stopAnimation() {
    _animationController.stop();
  }

  void _pauseAnimation() {
    _stopAnimation();
    _currentAnimationPosition = _animationController.value;
  }

  void _resetAnimation() {
    _currentAnimationPosition = 0.0;
    _animationController.value = _currentAnimationPosition;
  }

  void showMessage(String content) {
    var snackBar = SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future _shareSong() async {
    await _appViewModles.shareSong(_song);
  }

  void addFavoriteSong(Song song) async {
    if (song.favorite.value == true) {
      await _appViewModles.addFavotiteSong(
          song, _appViewModles.favoriteList, 'favoriteSong');
      showMessage('Added to favorites list successfully');
    } else {
      await _appViewModles.deleteSongNotFavorite(
          song, _appViewModles.favoriteList, 'favoriteSong');
      showMessage('Removed to favorites list successfully');
    }
    await _appViewModles.updateFavoriteSongValue(song, 'song');
  }
}
