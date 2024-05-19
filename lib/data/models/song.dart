// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

            // "id": "1073969708",
            // "title": "Right Here Waiting For You",
            // "album": "Wild Angel's Collection",
            // "artist": "Richard Marx",
            // "source": "https://thantrieu.com/resources/music/1073969708.mp3",
            // "image": "https://thantrieu.com/resources/arts/1073969708.webp",
            // "duration": 262,
            // "favorite": "false",
            // "counter": 0,
            // "replay": 0
class Song {
  String id;
  String title;
  String artist;
  String album;
  String source;
  String image;
  int duration;
  String? favorite;
  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.source,
    required this.image,
    required this.duration,
    this.favorite,
  });

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? source,
    String? image,
    int? duration,
    String? favorite,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      source: source ?? this.source,
      image: image ?? this.image,
      duration: duration ?? this.duration,
      favorite: favorite ?? this.favorite,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'source': source,
      'image': image,
      'duration': duration,
      'favorite': favorite,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      album: map['album'] as String,
      source: map['source'] as String,
      image: map['image'] as String,
      duration: map['duration'] as int,
      favorite: map['favorite'] != null ? map['favorite'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist: $artist, album: $album, source: $source, image: $image, duration: $duration, favorite: $favorite)';
  }

  @override
  bool operator ==(covariant Song other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.artist == artist &&
      other.album == album &&
      other.source == source &&
      other.image == image &&
      other.duration == duration &&
      other.favorite == favorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      artist.hashCode ^
      album.hashCode ^
      source.hashCode ^
      image.hashCode ^
      duration.hashCode ^
      favorite.hashCode;
  }
}
