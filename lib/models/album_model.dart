import 'dart:ui';
import 'package:myapp/models/element_model.dart';
import 'package:myapp/models/photo_model.dart';
import 'package:myapp/models/tag_model.dart';

class Album extends ElementItem {
  final String name;
  final String description;
  final String coverImageUrl;
  final List<Photo> photos;
  final List<Tag> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  Album({
    super.id,
    required this.name,
    this.description = '',
    this.coverImageUrl = '',
    this.photos = const [],
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    required super.position,
    required super.size,
    required super.sectionId,
  }) : super(
          type: ElementItemType.album,
          content: name, // Store name in content field
        );

  @override
  Album copyWith({
    String? id,
    ElementItemType? type,
    Offset? position,
    Size? size,
    String? content,
    String? sectionId,
    // Album specific fields
    String? name,
    String? description,
    String? coverImageUrl,
    List<Photo>? photos,
    List<Tag>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Album(
      id: id ?? this.id,
      name: name ?? (content ?? this.name),
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      photos: photos ?? this.photos,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      position: position ?? this.position,
      size: size ?? this.size,
      sectionId: sectionId ?? this.sectionId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'name': name,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'photos': photos.map((p) => p.toMap()).toList(),
      'tags': tags.map((t) => t.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    });
    return map;
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      coverImageUrl: map['coverImageUrl'] ?? '',
      photos: (map['photos'] as List?)?.map((p) => Photo.fromMap(p)).toList() ??
          const [],
      tags: (map['tags'] as List?)?.map((t) => Tag.fromMap(t)).toList() ??
          const [],
      createdAt: DateTime.parse(map['createdAt'] ?? ''),
      updatedAt: DateTime.parse(map['updatedAt'] ?? ''),
      position:
          Offset(map['position']?['dx'] ?? 0.0, map['position']?['dy'] ?? 0.0),
      size: Size(map['size']?['width'] ?? 0.0, map['size']?['height'] ?? 0.0),
      sectionId: map['sectionId'] ?? '',
    );
  }
}
