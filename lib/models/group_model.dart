import 'package:myapp/models/person_model.dart';

class Group {
  final String id;
  final String name;
  final List<Person> members;

  Group({required this.id, required this.name, required this.members});
}