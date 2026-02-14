
class Section {
  final String id;
  final String name;
  final List<String> visibleToGroupIds;

  Section({required this.id, required this.name, this.visibleToGroupIds = const []});
}