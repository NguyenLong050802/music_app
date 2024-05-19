import 'package:flutter/material.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';

import '../data/models/song.dart';
import '../ui/custom/custom_list_title.dart';

class MusicService {
  final _viewModles = MusicAppViewModles();

  void showBottomSheet(BuildContext context, Song song) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Container(
              height: 400,
              color: Colors.white,
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyListTitle(
                      title: song.title,
                      onTap: () {},
                      leading: Leading(image: song.image),
                    ),
                    const Divider(
                      thickness: 1,
                      indent: 24,
                      endIndent: 24,
                    ),
                    ValueListenableBuilder(
                      valueListenable: song.favorite,
                      builder: (_, value, __) {
                        return MyListTitle(
                          title: song.favorite.value == false
                              ? 'Add to Favorite Songs List'
                              : 'Added to Favorite Songs List',
                          onTap: () {
                            _viewModles.updateFavoriteState(song);
                            _viewModles.songToFavorite(song);
                          },
                          leading: song.favorite.value == false
                              ? const Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: _viewModles.isAdded,
                      builder: (_, value, __) {
                        return MyListTitle(
                          title: _viewModles.isAdded.value == false
                              ? 'Add to NowPlaying Songs List'
                              : 'Added to NowPlaying Songs List',
                          onTap: () {
                            _viewModles.updateNowPlayingListState();
                            _viewModles.songToNowPlaying(song);
                            debugPrint(
                                _viewModles.nowPlayingList.length.toString());
                          },
                          leading: _viewModles.isAdded.value == false
                              ? const Icon(
                                  Icons.playlist_add_rounded,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.playlist_add_check_rounded,
                                  color: Colors.red,
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
