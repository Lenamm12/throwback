import 'dart:ui';

class ElementItem {
  String? id;
  ElementItemType type;
  // Position and size are stored as percentages (0.0 to 1.0) of the parent container.
  // The y-coordinate of the position is measured from the bottom of the container.
  Offset position;
  Size size;
  // For 'album' type, content holds the albumId.
  String? content;
  String sectionId;

  ElementItem({
    this.id,
    required this.type,
    required this.position,
    required this.size,
    this.content,
    required this.sectionId,
  });

  ElementItem copyWith({
    String? id,
    ElementItemType? type,
    Offset? position,
    Size? size,
    String? content,
    String? sectionId,
  }) {
    return ElementItem(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      size: size ?? this.size,
      content: content ?? this.content,
      sectionId: sectionId ?? this.sectionId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'position': {'dx': position.dx, 'dy': position.dy},
      'size': {'width': size.width, 'height': size.height},
      'content': content,
      'sectionId': sectionId,
    };
  }

  factory ElementItem.fromMap(Map<String, dynamic> map) {
    final positionMap = map['position'] as Map<String, dynamic>;
    final sizeMap = map['size'] as Map<String, dynamic>;

    return ElementItem(
      id: map['id'],
      type: ElementItemType.values[map['type']],
      position: Offset(positionMap['dx'] ?? 0.0, positionMap['dy'] ?? 0.0),
      size: Size(sizeMap['width'] ?? 0.0, sizeMap['height'] ?? 0.0),
      content: map['content'],
      sectionId: map['sectionId'] as String,
    );
  }

  @override
  String toString() {
    return 'ElementItem(id: $id, type: $type, position: $position, size: $size, content: $content, sectionId: $sectionId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ElementItem &&
        other.id == id &&
        other.type == type &&
        other.position == position &&
        other.size == size &&
        other.content == content &&
        other.sectionId == sectionId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        position.hashCode ^
        size.hashCode ^
        content.hashCode ^
        sectionId.hashCode;
  }
}

enum ElementItemType {
  image, // Klick für Zoom
  album, // klick zoomt auf Vorderseite, dann durchblättern
  sticker,
  divider,
  banner, // Bannerbild (volle Breite)
  grid,
  text
}
