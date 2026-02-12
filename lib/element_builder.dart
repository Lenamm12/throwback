import 'package:flutter/material.dart';

import 'models/album_model.dart';
import 'models/element_model.dart';

Widget buildElementItem(ElementItem item) {
  switch (item.type) {
    case ElementItemType.album:
      final album = Album(
          id: 'error',
          name: 'Unknown Album',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      return _buildAlbumWidget(album);
    case ElementItemType.image:
      return _buildPhotoWidget();
    case ElementItemType.text:
      return Container(
        alignment: Alignment.center,
        child: Text(
          item.content ?? '',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    case ElementItemType.sticker:
      return const Icon(Icons.star, size: 30, color: Colors.yellow);
    case ElementItemType.divider:
      return Container(
        height: 1,
        width: 200,
        color: Colors.grey[300],
      );
    case ElementItemType.grid:
      return _buildGridWidget();
    default:
      return Container(color: Colors.red);
  }
}

Widget _buildAlbumWidget(Album album) {
  return Card(
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Image.network(
            album.coverImageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            album.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

Widget _buildPhotoWidget() {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255),
      border: Border.all(
          color: const Color.fromARGB(255, 110, 110, 110), width: 20),
    ),
    width: 100,
    height: 120,
    child: const Icon(Icons.image, size: 50),
  );
}

Widget _buildGridWidget() {
  return GridView.count(
    crossAxisCount: 2,
    mainAxisSpacing: 2,
    children: List.generate(4, (index) {
      return Container(
        color: Colors.grey,
        child: const Icon(Icons.image, size: 50),
      );
    }),
  );
}
