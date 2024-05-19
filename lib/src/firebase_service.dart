import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/models/song.dart';

class FireBaseService {
  Future<void> addSongToFb(Song song ,String collection) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(song.id)
        .set(song.toMap());
  }

  Future<void> removeSongFromFb(Song song ,String collection) async {
    await FirebaseFirestore.instance.collection(collection).doc(song.id).delete();
  }

  Future<void> updateSongToFb(Song song ,String collection ) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(song.id).update({'favorite': song.favorite.value});
  }


  Future loadSongFromFb(String collection) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    final data = querySnapshot.docs.map((e) => Song.fromMap(e.data())).toList();
    if (data.isNotEmpty) {
      return data;
    } else {
      return null;
    }
  }

}
