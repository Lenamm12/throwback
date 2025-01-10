import 'package:flutter/material.dart';
import '../models/album_model.dart';
import '../models/tag_model.dart';
import 'album_detail_screen.dart';

class PortfolioScreen extends StatefulWidget {
  final List<Album> albums;
  final List<Tag> tags;

  const PortfolioScreen({super.key, required this.albums, required this.tags});

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  late List<Album> _filteredAlbums;
  String _selectedTag = '';

  @override
  void initState() {
    super.initState();
    _filteredAlbums = widget.albums;
  }

  void _filterAlbumsByTag(String tagName) {
    setState(() {
      _selectedTag = tagName;
      if (tagName.isEmpty) {
        _filteredAlbums = widget.albums;
      } else {
        _filteredAlbums = widget.albums
            .where((album) => album.tags.any((tag) => tag.name == tagName))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedTag.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                label: Text('Filtered by: $_selectedTag'),
                onDeleted: () => _filterAlbumsByTag(''),
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _filteredAlbums.length,
              itemBuilder: (context, index) {
                final album = _filteredAlbums[index];
                return _buildAlbumTile(album);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewAlbum();
        },
        tooltip: 'Create new album',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createNewAlbum() {
    // TODO: Implement album creation logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Album'),
          content: const TextField(
            decoration: InputDecoration(hintText: "Enter album name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                // TODO: Add new album to the list
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlbumTile(Album album) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailScreen(album: album),
          ),
        );
      },
      child: Card(
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: album.mediaIds.isNotEmpty
                  ? Image.network(
                      'https://via.placeholder.com/150', // TODO: Replace with actual thumbnail
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.photo_album, size: 50),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${album.mediaIds.length} items',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter by Tag'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                    ListTile(
                      title: const Text('All'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _filterAlbumsByTag('');
                      },
                    ),
                  ] +
                  widget.tags
                      .map((tag) => ListTile(
                            title: Text(tag.name),
                            onTap: () {
                              Navigator.of(context).pop();
                              _filterAlbumsByTag(tag.name);
                            },
                          ))
                      .toList(),
            ),
          ),
        );
      },
    );
  }
}
