import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../models/tag_model.dart';

class PhotoViewScreen extends StatefulWidget {
  final String imageUrl;
  final List<Tag> tags;

  const PhotoViewScreen(
      {super.key, required this.imageUrl, this.tags = const []});

  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  bool _isLiked = false;
  List<Tag> _tags = [];

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo View'),
        actions: [
          IconButton(
            icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleLike,
          ),
          IconButton(
            icon: const Icon(Icons.tag),
            onPressed: _showTagDialog,
          ),
          IconButton(
            icon: const Icon(Icons.comment),
            onPressed: _showCommentDialog,
          ),
        ],
      ),
      body: PhotoView(
        imageProvider: NetworkImage(widget.imageUrl),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
      ),
      bottomSheet: _buildTagList(),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _showTagDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTag = '';
        return AlertDialog(
          title: const Text('Add Tag'),
          content: TextField(
            onChanged: (value) {
              newTag = value;
            },
            decoration: const InputDecoration(hintText: "Enter tag name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (newTag.isNotEmpty) {
                  setState(() {
                    _tags.add(Tag(id: DateTime.now().toString(), name: newTag));
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCommentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Comment'),
          content: TextField(
            onChanged: (value) {},
            decoration: const InputDecoration(hintText: "Enter your comment"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                // Here you would typically save the comment to a database
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comment added')),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTagList() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tags.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Chip(
              label: Text(_tags[index].name),
              onDeleted: () {
                setState(() {
                  _tags.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
