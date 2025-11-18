import 'package:flutter/foundation.dart';
import 'package:myapp/models/element_model.dart';

enum SectionVisibility { private, friends, public }

class Section {
  final String id;
  final String name;
  final List<ElementItem> elementIds;
  final bool isPinned;
  final SectionVisibility visibility;

  Section({
    required this.id,
    required this.name,
    this.elementIds = const [],
    this.isPinned = false,
    this.visibility = SectionVisibility.private,
  });

  Section copyWith({
    String? id,
    String? name,
    List<ElementItem>? elementIds,
    bool? isPinned,
    SectionVisibility? visibility,
  }) {
    return Section(
      id: id ?? this.id,
      name: name ?? this.name,
      elementIds: elementIds ?? this.elementIds,
      isPinned: isPinned ?? this.isPinned,
      visibility: visibility ?? this.visibility,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'elementIds': elementIds,
      'isPinned': isPinned,
      'visibility': visibility.index,
    };
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      elementIds: List<ElementItem>.from(map['elementIds'] ?? const []),
      isPinned: map['isPinned'] ?? false,
      visibility: SectionVisibility.values[map['visibility'] ?? 0],
    );
  }

  @override
  String toString() {
    return 'Section(id: $id, name: $name, elementIds: $elementIds, isPinned: $isPinned, visibility: $visibility)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Section &&
        other.id == id &&
        other.name == name &&
        listEquals(other.elementIds, elementIds) &&
        other.isPinned == isPinned &&
        other.visibility == visibility;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        elementIds.hashCode ^
        isPinned.hashCode ^
        visibility.hashCode;
  }
}
