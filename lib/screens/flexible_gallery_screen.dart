import 'package:flutter/material.dart';

class FlexibleGalleryScreen extends StatefulWidget {
  const FlexibleGalleryScreen({super.key});

  @override
  _FlexibleGalleryScreenState createState() => _FlexibleGalleryScreenState();
}

class _FlexibleGalleryScreenState extends State<FlexibleGalleryScreen> {
  final List<GalleryItem> _items = [];

  @override
  void initState() {
    super.initState();
    // Add some initial items for demonstration
    _items.add(GalleryItem(
        type: GalleryItemType.image,
        position: const Offset(20, 100),
        size: const Size(150, 150)));
    _items.add(GalleryItem(
        type: GalleryItemType.text,
        position: const Offset(200, 100),
        size: const Size(100, 50),
        text: "2023"));
    _items.add(GalleryItem(
        type: GalleryItemType.sticker,
        position: const Offset(50, 300),
        size: const Size(50, 50)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lena D'),
      ),
      body: Stack(
        children: [
          for (var item in _items)
            Positioned(
              left: item.position.dx,
              top: item.position.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    item.position += details.delta;
                  });
                },
                child: _buildGalleryItem(item),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        tooltip: 'Add new item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGalleryItem(GalleryItem item) {
    switch (item.type) {
      case GalleryItemType.image:
        return Container(
          width: item.size.width,
          height: item.size.height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.black),
          ),
          child: const Icon(Icons.image, size: 50),
        );
      case GalleryItemType.text:
        return Container(
          width: item.size.width,
          height: item.size.height,
          alignment: Alignment.center,
          child: Text(
            item.text ?? '',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      case GalleryItemType.sticker:
        return SizedBox(
          width: item.size.width,
          height: item.size.height,
          child: const Icon(Icons.star, size: 30, color: Colors.yellow),
        );
      case GalleryItemType.divider:
        return Container(
          width: item.size.width,
          height: 2,
          color: Colors.black,
        );
      case GalleryItemType.banner:
        return Container(
          width: MediaQuery.of(context).size.width,
          height: item.size.height,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            border: Border.all(color: Colors.black),
          ),
          child: const Center(
            child: Text(
              'Banner Image',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
    }
  }

  void _addNewItem() {
    setState(() {
      _items.add(GalleryItem(
        type: GalleryItemType.image,
        position: const Offset(100, 100),
        size: const Size(100, 100),
      ));
    });
  }
}

class GalleryItem {
  GalleryItemType type;
  Offset position;
  Size size;
  String? text;

  GalleryItem({
    required this.type,
    required this.position,
    required this.size,
    this.text,
  });
}

enum GalleryItemType { image, text, sticker, divider , banner}
