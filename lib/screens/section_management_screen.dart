import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/section_model.dart';
import '../notifiers/group_provider.dart';
import '../notifiers/section_provider.dart';

class SectionManagementScreen extends StatefulWidget {
  const SectionManagementScreen({super.key});

  @override
  State<SectionManagementScreen> createState() =>
      _SectionManagementScreenState();
}

class _SectionManagementScreenState extends State<SectionManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final sectionProvider = Provider.of<SectionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Section Management'),
      ),
      body: ListView.builder(
        itemCount: sectionProvider.sections.length,
        itemBuilder: (context, index) {
          final section = sectionProvider.sections[index];
          return ListTile(
            title: Text(section.name),
            subtitle: Text(section.visibleToGroupIds.join(', ')),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditSectionDialog(section);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    sectionProvider.removeSection(section);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSectionDialog,
        tooltip: 'Add Section',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSectionDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Section'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Section Name'),
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
                  final newSection = Section(
                    id: DateTime.now().toString(),
                    name: name,
                  );
                  Provider.of<SectionProvider>(context, listen: false)
                      .addSection(newSection);
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

  void _showEditSectionDialog(Section section) {
    showDialog(
      context: context,
      builder: (context) {
        return _EditSectionDialog(section: section);
      },
    );
  }
}

class _EditSectionDialog extends StatefulWidget {
  final Section section;

  const _EditSectionDialog({required this.section});

  @override
  State<_EditSectionDialog> createState() => _EditSectionDialogState();
}

class _EditSectionDialogState extends State<_EditSectionDialog> {
  late TextEditingController _nameController;
  late List<String> _selectedGroupIds;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.section.name);
    _selectedGroupIds = List.from(widget.section.visibleToGroupIds);
  }

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    return AlertDialog(
      title: const Text('Edit Section'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Section Name'),
          ),
          const SizedBox(height: 16),
          const Text('Visible to:'),
          SizedBox(
            height: 200,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: groupProvider.groups.length,
              itemBuilder: (context, index) {
                final group = groupProvider.groups[index];
                return CheckboxListTile(
                  title: Text(group.name),
                  value: _selectedGroupIds.contains(group.id),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedGroupIds.add(group.id);
                      } else {
                        _selectedGroupIds.remove(group.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final name = _nameController.text;
            if (name.isNotEmpty) {
              final updatedSection = Section(
                id: widget.section.id,
                name: name,
                visibleToGroupIds: _selectedGroupIds,
              );
              Provider.of<SectionProvider>(context, listen: false)
                  .updateSection(updatedSection);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
