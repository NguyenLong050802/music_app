import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/models/song.dart';

class FireBaseService {
  Future<void> addFavoriteSongToFb(Song song) async {
    await FirebaseFirestore.instance
        .collection('song')
        .doc(song.id)
        .set(song.toMap());
  }

  Future<void> removeFavoriteSongFromFb(Song song) async {
    await FirebaseFirestore.instance.collection('song').doc(song.id).delete();
  }

  Future<void> updateSongToFb(Song song, String favorite) async {
    await FirebaseFirestore.instance
        .collection('song')
        .doc(song.id)
        .update({'favorite': favorite});
  }

  Future loadFavoriteSongFromFb() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('song').get();
    final data = querySnapshot.docs.map((e) => Song.fromMap(e.data())).toList();
    if (data.isNotEmpty) {
      return data;
    } else {
      return null;
    }
  }

}
