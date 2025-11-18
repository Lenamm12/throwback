import 'package:flutter/foundation.dart';
import 'photo_model.dart';
import 'tag_model.dart';

class Album {
  final String id;
  final String name;
  final String description;
  final String coverImageUrl;
  final List<Photo> photos;
  final List<Tag> tags;
  final bool isReel;
  final DateTime createdAt;
  final DateTime updatedAt;

  Album({
    required this.id,
    required this.name,
    this.description = '',
    this.coverImageUrl = '',
    this.photos = const [],
    this.tags = const [],
    this.isReel = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Album copyWith({
    String? id,
    String? name,
    String? description,
    String? coverImageUrl,
    List<Photo>? photos,
    List<Tag>? tags,
    bool? isReel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Album(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      photos: photos ?? this.photos,
      tags: tags ?? this.tags,
      isReel: isReel ?? this.isReel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'photos': photos.map((x) => x.toMap()).toList(),
      'tags': tags.map((x) => x.toMap()).toList(),
      'isReel': isReel,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      coverImageUrl: map['coverImageUrl'] ?? '',
      photos: List<Photo>.from(map['photos']?.map((x) => Photo.fromMap(x)) ?? const []),
      tags: List<Tag>.from(map['tags']?.map((x) => Tag.fromMap(x)) ?? const []),
      isReel: map['isReel'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  @override
  String toString() {
    return 'Album(id: $id, name: $name, description: $description, coverImageUrl: $coverImageUrl, photos: $photos, tags: $tags, isReel: $isReel, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Album &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.coverImageUrl == coverImageUrl &&
        listEquals(other.photos, photos) &&
        listEquals(other.tags, tags) &&
        other.isReel == isReel &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        coverImageUrl.hashCode ^
        photos.hashCode ^
        tags.hashCode ^
        isReel.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
