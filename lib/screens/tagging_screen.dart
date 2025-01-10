import 'package:flutter/material.dart';
import '../models/tag_model.dart';

class TaggingScreen extends StatefulWidget {
  final List<String> mediaIds;
  final List<Tag> existingTags;

  const TaggingScreen({
    super.key,
    required this.mediaIds,
    required this.existingTags,
  });

  @override
  _TaggingScreenState createState() => _TaggingScreenState();
}

class _TaggingScreenState extends State<TaggingScreen> {
  final TextEditingController _newTagController = TextEditingController();
  final Map<String, List<String>> _mediaTags = {};

  @override
  void initState() {
    super.initState();
    _initializeMediaTags();
  }

  void _initializeMediaTags() {
    for (var mediaId in widget.mediaIds) {
      _mediaTags[mediaId] = [];
    }
  }

  void _addTagToMedia(String mediaId, String tagName) {
    setState(() {
      if (!_mediaTags[mediaId]!.contains(tagName)) {
        _mediaTags[mediaId]!.add(tagName);
      }
    });
  }

  void _removeTagFromMedia(String mediaId, String tagName) {
    setState(() {
      _mediaTags[mediaId]!.remove(tagName);
    });
  }

  void _createNewTag() {
    final newTagName = _newTagController.text.trim();
    if (newTagName.isNotEmpty) {
      setState(() {
        widget.existingTags.add(Tag(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: newTagName,
        ));
        _newTagController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tag Your Media'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newTagController,
                    decoration: const InputDecoration(
                      hintText: 'Create a new tag',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _createNewTag,
                  child: const Text('Add Tag'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.mediaIds.length,
              itemBuilder: (context, index) {
                final mediaId = widget.mediaIds[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Here you would display the actual media (photo/video)
                      // For now, we'll just show a placeholder
                      Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(child: Text('Media $mediaId')),
                      ),
                      Wrap(
                        spacing: 8,
                        children: _mediaTags[mediaId]!
                            .map((tag) => Chip(
                                  label: Text(tag),
                                  onDeleted: () =>
                                      _removeTagFromMedia(mediaId, tag),
                                ))
                            .toList(),
                      ),
                      DropdownButton<String>(
                        hint: const Text('Add a tag'),
                        items: widget.existingTags
                            .map((tag) => DropdownMenuItem(
                                  value: tag.name,
                                  child: Text(tag.name),
                                ))
                            .toList(),
                        onChanged: (String? tagName) {
                          if (tagName != null) {
                            _addTagToMedia(mediaId, tagName);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newTagController.dispose();
    super.dispose();
  }
}
