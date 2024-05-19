import '../models/song.dart';
import '../source/source.dart';

abstract interface class Repository {
  Future<List<Song>?> loadData();
}

class DefaultRepositort implements Repository {
  final _localDataSuorce = LocalDataSource();
  final _onlineDataSource = OnlineDataSource();
  @override
  Future<List<Song>?> loadData() async {
    final dataInternet = await _onlineDataSource.loadData();
    final dataLocal = await _localDataSuorce.loadData();
    List<Song> songs = [];
    if (dataInternet != null) {
      songs.addAll(dataInternet);
    } else {
      songs.addAll(dataLocal!);
    }
    return songs;
  }
}
