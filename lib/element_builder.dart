import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/album_model.dart';
import 'models/element_model.dart';
import 'models/photo_model.dart';
import 'notifiers/theme_notifier.dart';

class ElementBuilder {
  static Widget build(BuildContext context, dynamic item) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;

    switch (item.type) {
      case ElementItemType.album:
        return _buildAlbumWidget(item, isDarkMode);
      case ElementItemType.image:
        return _buildPhotoWidget(item, isDarkMode);
      case ElementItemType.text:
        return _buildTextWidget(item, isDarkMode);
      case ElementItemType.sticker:
        return _buildStickerWidget();
      case ElementItemType.divider:
        return _buildDividerWidget(isDarkMode);
      case ElementItemType.grid:
        return _buildGridWidget(isDarkMode);
      default:
        return _buildPlaceholder(isDarkMode);
    }
  }

  static Widget _buildAlbumWidget(Album item, bool isDarkMode) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              item.coverImageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildPhotoWidget(Photo item, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.white,
        border: Border.all(
          color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
          width: 20,
        ),
      ),
      width: 100,
      height: 120,
      child: Image.network(
        item.url,
        fit: BoxFit.cover,
      ),
    );
  }

  static Widget _buildTextWidget(ElementItem item, bool isDarkMode) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        item.content ?? '',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  static Widget _buildStickerWidget() {
    return const Icon(Icons.star, size: 30, color: Colors.yellow);
  }

  static Widget _buildDividerWidget(bool isDarkMode) {
    return Container(
      height: 1,
      width: 200,
      color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
    );
  }

  static Widget _buildGridWidget(bool isDarkMode) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      children: List.generate(4, (index) {
        return Container(
          color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
          child: Icon(Icons.image,
              size: 50, color: isDarkMode ? Colors.white : Colors.grey),
        );
      }),
    );
  }

  static Widget _buildPlaceholder(bool isDarkMode) {
    return Container(
      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.help_outline,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
