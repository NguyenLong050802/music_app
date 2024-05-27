import 'package:flutter/material.dart';
import 'package:music_app_flutter/ui/custom/custom_icon_buttom.dart';
import 'package:music_app_flutter/ui/custom/custom_list.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';
// import '../../data/models/song.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  late MusicAppViewModles _viewModles;

  @override
  void initState() {
    _viewModles = MusicAppViewModles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Library Page',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: [
          MediaIconButton(
            icon: Icons.add,
            size: 40,
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
                Divider(
                  thickness: 1,
                  indent: 24,
                  endIndent: 24,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
