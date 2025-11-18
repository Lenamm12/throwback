import 'package:flutter/foundation.dart';

class Page {
  final String id;
  final String userId;
  final List<String> sectionIds;

  Page({
    required this.id,
    required this.userId,
    this.sectionIds = const [],
  });

  Page copyWith({
    String? id,
    String? userId,
    List<String>? sectionIds,
  }) {
    return Page(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sectionIds: sectionIds ?? this.sectionIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'sectionIds': sectionIds,
    };
  }

  factory Page.fromMap(Map<String, dynamic> map) {
    return Page(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      sectionIds: List<String>.from(map['sectionIds'] ?? const []),
    );
  }

  @override
  String toString() {
    return 'Page(id: $id, userId: $userId, sectionIds: $sectionIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Page &&
        other.id == id &&
        other.userId == userId &&
        listEquals(other.sectionIds, sectionIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ sectionIds.hashCode;
  }
}
