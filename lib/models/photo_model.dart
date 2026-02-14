import 'dart:ui';
import 'package:myapp/models/element_model.dart';

class Photo extends ElementItem {
  final String url;
  final String caption;

  Photo({
    super.id,
    required this.url,
    this.caption = '',
    required super.position,
    required super.size,
    required super.sectionId,
  }) : super(
          type: ElementItemType.image,
          content: url, // Store url in content field
        );

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'url': url,
      'caption': caption,
    });
    return map;
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'],
      url: map['url'] ?? '',
      caption: map['caption'] ?? '',
      position: Offset(map['position']?['dx'] ?? 0.0, map['position']?['dy'] ?? 0.0),
      size: Size(map['size']?['width'] ?? 0.0, map['size']?['height'] ?? 0.0),
      sectionId: map['sectionId'] ?? '',
    );
  }
}
