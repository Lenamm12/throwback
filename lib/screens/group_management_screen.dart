import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/group_model.dart';
import '../notifiers/group_provider.dart';
import 'add_member_screen.dart';

class GroupManagementScreen extends StatefulWidget {
  const GroupManagementScreen({super.key});

  @override
  State<GroupManagementScreen> createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Management'),
      ),
      body: ListView.builder(
        itemCount: groupProvider.groups.length,
        itemBuilder: (context, index) {
          final group = groupProvider.groups[index];
          return ListTile(
            title: Text(group.name),
            subtitle: Text('${group.members.length} members'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMemberScreen(group: group),
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                groupProvider.removeGroup(group);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGroupDialog(context, groupProvider),
        tooltip: 'Add Group',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGroupDialog(BuildContext context, GroupProvider groupProvider) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Group'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Group Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  final newGroup = Group(
                    id: DateTime.now().toString(),
                    name: name,
                    members: [],
                  );
                  groupProvider.addGroup(newGroup);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
