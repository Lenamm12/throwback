import '../models/tag_model.dart';

class TagVisibilityService {
  final Map<String, bool> _tagVisibility = {};

  // Toggle visibility for a specific tag
  void toggleTagVisibility(String tagId) {
    _tagVisibility[tagId] = !(_tagVisibility[tagId] ?? true);
  }

  // Get visibility status for a tag
  bool isTagVisible(String tagId) {
    return _tagVisibility[tagId] ?? true;
  }

  // Filter content based on visible tags
  List<String> filterContentByVisibleTags(
      List<Tag> allTags, List<String> allMediaIds) {
    final visibleTags = allTags.where((tag) => isTagVisible(tag.id)).toList();
    final visibleMediaIds =
        visibleTags.expand((tag) => tag.associatedMediaIds).toSet().toList();
    return allMediaIds
        .where((mediaId) => visibleMediaIds.contains(mediaId))
        .toList();
  }

  // Set visibility for multiple tags
  void setTagsVisibility(List<String> tagIds, bool isVisible) {
    for (final tagId in tagIds) {
      _tagVisibility[tagId] = isVisible;
    }
  }

  // Get all visible tags
  List<String> getVisibleTagIds() {
    return _tagVisibility.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  // Get all hidden tags
  List<String> getHiddenTagIds() {
    return _tagVisibility.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}
