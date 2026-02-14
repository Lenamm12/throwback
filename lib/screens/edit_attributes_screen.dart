import 'package:flutter/material.dart';
import '../models/element_model.dart';

class EditAttributesScreen extends StatefulWidget {
  final ElementItem item;

  const EditAttributesScreen({super.key, required this.item});

  @override
  State<EditAttributesScreen> createState() => _EditAttributesScreenState();
}

class _EditAttributesScreenState extends State<EditAttributesScreen> {
  late ElementItem _updatedItem;
  TextEditingController? _textController;

  @override
  void initState() {
    super.initState();
    // Create a copy of the item to avoid modifying the original item directly.
    _updatedItem = widget.item.copyWith();

    if (_updatedItem.type == ElementItemType.text) {
      _textController = TextEditingController(text: _updatedItem.content);
    }
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Attributes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_updatedItem.type == ElementItemType.text) {
                _updatedItem.content = _textController?.text;
              }
              Navigator.pop(context, _updatedItem);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildAttributeEditors(),
      ),
    );
  }

  Widget _buildAttributeEditors() {
    switch (_updatedItem.type) {
      case ElementItemType.text:
        return TextField(
          controller: _textController,
          decoration: const InputDecoration(labelText: 'Text'),
        );
      case ElementItemType.album:
        // TODO: Implement album selection UI
        return const Text('Album selection not implemented yet.');
      case ElementItemType.sticker:
        // TODO: Implement sticker selection UI
        return const Text('Sticker selection not implemented yet.');
      default:
        return const Text('This element has no editable attributes.');
    }
  }
}
