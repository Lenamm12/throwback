import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/photo_model.dart';
import 'package:myapp/screens/photo_view_screen.dart';
import '../models/album_model.dart';

class AlbumDetailScreen extends StatefulWidget {
  final Album album;

  const AlbumDetailScreen({super.key, required this.album});

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  late String _albumName;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _albumName = widget.album.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_albumName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editAlbumName,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildAlbumHeader(),
          _buildTagList(),
          Expanded(
            child: _buildMediaGrid(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMediaToAlbum,
        tooltip: 'Add media to album',
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }

  void _editAlbumName() {
    String newName = _albumName;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Album Name'),
          content: TextField(
            controller: TextEditingController(text: _albumName),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (newName.isNotEmpty) {
                  setState(() {
                    _albumName = newName;
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

  void _addMediaToAlbum() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        widget.album.photos
            .add(Photo(id: DateTime.now().toString(), url: image.path));
      });
    }
  }

  Widget _buildAlbumHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _albumName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8.0),
          Text(
            '${widget.album.photos.length} items',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTagList() {
    return SizedBox(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.album.tags.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Chip(
              label: Text(widget.album.tags[index].name),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: widget.album.photos.length,
      itemBuilder: (context, index) {
        return _buildMediaThumbnail(widget.album.photos[index].url);
      },
    );
  }

  Widget _buildMediaThumbnail(String mediaId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoViewScreen(imageUrl: mediaId),
          ),
        );
      },
      child: Hero(
        tag: mediaId,
        child: Image.file(
          File(mediaId),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.photo, size: 50),
          ),
        ),
      ),
    );
  }
}