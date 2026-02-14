import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/group_model.dart';
import '../models/person_model.dart';
import '../notifiers/group_provider.dart';

class AddMemberScreen extends StatefulWidget {
  final Group group;
  const AddMemberScreen({super.key, required this.group});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Member to ${widget.group.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final phone = _phoneController.text;
                if (phone.isNotEmpty) {
                  // Mock user lookup
                  final newMember = Person(
                    id: DateTime.now().toString(),
                    name: 'New Member', // Replace with actual name
                    phoneNumber: phone,
                  );
                  final updatedGroup = widget.group;
                  updatedGroup.members.add(newMember);
                  groupProvider.updateGroup(updatedGroup);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }
}
