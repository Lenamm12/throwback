import 'dart:ui';

class ElementItem {
  String? id;
  ElementItemType type;
  Offset position;
  Size size;
  String? content;

  ElementItem(
      {required this.type,
      required this.position,
      required this.size,
      this.content});

  ElementItem copyWith({
    String? id,
    ElementItemType? type,
    Offset? position,
    Size? size,
    String? content,
  }) {
    return ElementItem(
      type: type ?? this.type,
      position: position ?? this.position,
      size: size ?? this.size,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'position': position,
      'size': size,
      'content': content
    };
  }

  factory ElementItem.fromMap(Map<String, dynamic> element) {
    return ElementItem(
        type: element['type'],
        position: element['position'],
        size: element['size'],
        content: element['content']);
  }
}

enum ElementItemType { image, text, sticker, divider, banner }
