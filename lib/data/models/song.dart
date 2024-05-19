// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Song {
  String id;
  String title;
  String artist;
  String album;
  String source;
  String image;
  int duration;
  ValueNotifier<bool> favorite;
  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.source,
    required this.image,
    required this.duration,
    required bool favorite,
  }) : favorite = ValueNotifier(favorite);



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'source': source,
      'image': image,
      'duration': duration,
      'favorite': favorite.value,
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
      favorite: map['favorite'] as bool,
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
