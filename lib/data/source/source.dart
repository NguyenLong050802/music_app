import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/song.dart';
import 'package:http/http.dart' as http;

abstract interface class DataSource {
  Future<List<Song>?> loadData();
}

class LocalDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async {
    try {
      String data = await rootBundle.loadString('assets/songs.json');
      Map<String, dynamic> jsonData = json.decode(data);
      List songList = jsonData['songs'];
      List<Song> songs = songList.map((json) => Song.fromMap(json)).toList();
      return songs;
    } catch (e) {
      debugPrint('Error loading location data $e');
      return null;
    }
  }
}

class OnlineDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async {
    const url = 'https://thantrieu.com/resources/braniumapis/songs.json';
    final respon = await http.get(Uri.parse(url));
    if (respon.statusCode == 200) {
      final bodyContext = utf8.decode(respon.bodyBytes);
      var songWapper = jsonDecode(bodyContext) as Map;
      var songList = songWapper['songs'] as List;
      List<Song> songs = songList.map((song) => Song.fromMap(song)).toList();
      return songs;
    } else {
      return null;
    }
  }
}
