import 'package:flutter/material.dart';
import '../models/album_model.dart';

class AlbumDetailScreen extends StatefulWidget {
  final Album album;

  const AlbumDetailScreen({super.key, required this.album});

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit album functionality
            },
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
        onPressed: () {
          // TODO: Implement add media to album functionality
        },
        tooltip: 'Add media to album',
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }

  Widget _buildAlbumHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.album.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8.0),
          Text(
            '${widget.album.mediaIds.length} items',
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
      itemCount: widget.album.mediaIds.length,
      itemBuilder: (context, index) {
        return _buildMediaThumbnail(widget.album.mediaIds[index]);
      },
    );
  }

  Widget _buildMediaThumbnail(String mediaId) {
    // TODO: Replace with actual media thumbnail
    return GestureDetector(
      onTap: () {
        // TODO: Implement media detail view
      },
      child: Container(
        color: Colors.grey[300],
        child: const Icon(Icons.photo, size: 50),
      ),
    );
  }
}
