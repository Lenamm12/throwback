import 'package:flutter/material.dart';
import '../models/element_model.dart';

class ElementSelectionScreen extends StatelessWidget {
  const ElementSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Element Type'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Album'),
            onTap: () => Navigator.pop(context, ElementItemType.album),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Image'),
            onTap: () => Navigator.pop(context, ElementItemType.image),
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Text'),
            onTap: () => Navigator.pop(context, ElementItemType.text),
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Sticker'),
            onTap: () => Navigator.pop(context, ElementItemType.sticker),
          ),
          ListTile(
            leading: const Icon(Icons.remove),
            title: const Text('Trenner'),
            onTap: () => Navigator.pop(context, ElementItemType.divider),
          ),
          ListTile(
            leading: const Icon(Icons.grid_3x3),
            title: const Text('Grid'),
            onTap: () => Navigator.pop(context, ElementItemType.grid),
          ),
        ],
      ),
    );
  }
}
