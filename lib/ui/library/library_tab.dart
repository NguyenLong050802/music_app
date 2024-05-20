import 'package:flutter/material.dart';
import 'package:music_app_flutter/src/music_service.dart';
import 'package:music_app_flutter/ui/custom/custom_icon_buttom.dart';
import 'package:music_app_flutter/ui/custom/custom_list.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  late MusicAppViewModles _viewModles;
  late MusicService _musicService;

  @override
  void initState() {
    _viewModles = MusicAppViewModles();
    _musicService = MusicService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Page'),
        centerTitle: true,
        actions: [
          MediaIconButton(
            icon: Icons.add,
            size: 40,
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
      body: showBody(screenWidth),
    );
  }

  Widget showBody(double screenWidth) {
    const favoriteSongImage =
        'https://img.freepik.com/vector-premium/mi-cancion-favorita-cita-escritura-mano-ilustracion-vector-frase-caligrafia_112545-2143.jpg?w=740';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenWidth * 0.5,
            child: Column(
              children: [
                MyListTitle(
                  title: 'Favorite Songs',
                  subTitle: 'PlayList.   Nguyễn Đức Long',
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MyPageView(
                        musicService: _musicService,
                        viewModles: _viewModles,
                        list: _viewModles.favoriteList,
                        image: favoriteSongImage,
                        title: 'Favorite Songs List',
                      );
                    }));
                  },
                  leading: const Leading(
                    image: favoriteSongImage,
                    height: 50,
                    width: 50,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  indent: 24,
                  endIndent: 24,
                ),
                MyListTitle(
                  title: 'NowPlaying Songs',
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  subTitle: 'PlayList.   Nguyễn Đức Long',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MyPageView(
                        musicService: _musicService,
                        viewModles: _viewModles,
                        title: 'NowPlaying Songs List',
                        list: _viewModles.nowPlayingList,
                        image: _viewModles.nowPlayingList.isNotEmpty
                            ? _viewModles.nowPlayingList[0].image
                            : 'https://th.bing.com/th/id/OIP.zkgqwgX81GSlEeKqbkBEugHaHb?w=153&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
                      );
                    }));
                  },
                  leading: Leading(
                    image: _viewModles.nowPlayingList.isNotEmpty
                        ? _viewModles.nowPlayingList[0].image
                        : 'https://th.bing.com/th/id/OIP.zkgqwgX81GSlEeKqbkBEugHaHb?w=153&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
                    height: 50,
                    width: 50,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  indent: 24,
                  endIndent: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}