import 'package:flutter/foundation.dart';

class Tag {
  final String id;
  final String name;
  final List<String> associatedMediaIds;

  Tag({
    required this.id,
    required this.name,
    this.associatedMediaIds = const [],
  });

  Tag copyWith({
    String? id,
    String? name,
    List<String>? associatedMediaIds,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      associatedMediaIds: associatedMediaIds ?? this.associatedMediaIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'associatedMediaIds': associatedMediaIds,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      associatedMediaIds: List<String>.from(map['associatedMediaIds'] ?? const []),
    );
  }

  @override
  String toString() => 'Tag(id: $id, name: $name, associatedMediaIds: $associatedMediaIds)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tag &&
      other.id == id &&
      other.name == name &&
      listEquals(other.associatedMediaIds, associatedMediaIds);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ associatedMediaIds.hashCode;
}
