import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/data/models/song.dart';
import 'package:music_app_flutter/ui/custom/custom_icon_buttom.dart';
import 'package:music_app_flutter/ui/custom/custom_list.dart';
import 'package:music_app_flutter/ui/view_modles.dart';

class ShowSearch extends SearchDelegate {
  final MusicAppViewModles musicAppViewModles;
  final List<Song> songList;
  ShowSearch({required this.songList, required this.musicAppViewModles});

  @override
  String get searchFieldLabel => 'Search songs,artists,....';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      MediaIconButton(
        icon: Icons.clear,
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return MediaIconButton(
      icon: Icons.arrow_back,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResult = songList.where((element) {
      final title = removeDiacritics(element.title.toLowerCase());
      final artist = removeDiacritics(element.artist.toLowerCase());
      final queryLower = removeDiacritics(query.toLowerCase());
      return title.contains(queryLower) || artist.contains(queryLower);
    }).toList();
    return getBody(searchResult, musicAppViewModles);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResult = songList.where((element) {
      final title = removeDiacritics(element.title.toLowerCase());
      final artist = removeDiacritics(element.artist.toLowerCase());
      final queryLower = removeDiacritics(query.toLowerCase());
      return title.contains(queryLower) || artist.contains(queryLower);
    }).toList();
    return getBody(searchResult, musicAppViewModles);
  }
}
