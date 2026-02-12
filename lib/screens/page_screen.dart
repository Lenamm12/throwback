import 'dart:math';
import 'package:flutter/material.dart';
import '../element_builder.dart';
import '../models/album_model.dart';
import '../models/element_model.dart';
import '../models/photo_model.dart';
import 'element_selection_screen.dart';
import '../services/auth_service.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({super.key});

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  final List<ElementItem> _items = [];
  final List<Album> _albums = [];
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadData();
    _getUserName();
  }

  void _loadData() {
    // Mock data for demonstration
    final photos = [
      Photo(id: 'p1', url: 'https://picsum.photos/200/300?random=1'),
      Photo(id: 'p2', url: 'https://picsum.photos/200/300?random=2'),
      Photo(id: 'p3', url: 'https://picsum.photos/200/300?random=3'),
    ];

    final album1 = Album(
      id: 'a1',
      name: 'Summer Vacation',
      description: 'Photos from our 2023 summer trip.',
      coverImageUrl: 'https://picsum.photos/200?random=4',
      photos: photos,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final album2 = Album(
      id: 'a2',
      name: 'Winter Wonderland',
      description: 'A collection of snowy landscapes.',
      coverImageUrl: 'https://picsum.photos/200?random=5',
      photos: photos,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _albums.addAll([album1, album2]);

    _items.addAll([
      ElementItem(
        id: 'e1',
        type: ElementItemType.album,
        position: const Offset(0.1, 0.2),
        size: const Size(0.3, 0.4),
        content: album1.id,
      ),
      ElementItem(
        id: 'e2',
        type: ElementItemType.album,
        position: const Offset(0.5, 0.5),
        size: const Size(0.3, 0.4),
        content: album2.id,
      ),
      ElementItem(
        type: ElementItemType.text,
        position: const Offset(0.4, 0.1),
        size: const Size(0.2, 0.1),
        content: "2023",
      ),
      ElementItem(
        type: ElementItemType.sticker,
        position: const Offset(0.8, 0.2),
        size: const Size(0.1, 0.1),
      ),
    ]);
    setState(() {});
  }

  void _getUserName() {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      setState(() {
        _userName = user.displayName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userName ?? 'My Page'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight * 2, // Make the page scrollable
            child: Stack(
              children: [
                for (var item in _items)
                  Positioned(
                    left: item.position.dx * constraints.maxWidth,
                    top: item.position.dy * constraints.maxHeight * 2,
                    width: item.size.width * constraints.maxWidth,
                    height: item.size.height * constraints.maxHeight * 2,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          final newDx = item.position.dx +
                              details.delta.dx / constraints.maxWidth;
                          final newDy = item.position.dy +
                              details.delta.dy / (constraints.maxHeight * 2);
                          item.position = Offset(newDx, newDy);
                        });
                      },
                      child: buildElementItem(item),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        tooltip: 'Add new item',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewItem() async {
    final selectedType = await showModalBottomSheet<ElementItemType>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return ElementSelectionScreen(scrollController: scrollController);
          },
        );
      },
    );

    if (selectedType != null) {
      final random = Random();
      setState(() {
        _items.add(ElementItem(
          type: selectedType,
          position:
              Offset(random.nextDouble() * 0.7, random.nextDouble() * 0.7),
          size: const Size(0.2, 0.2),
        ));
      });
    }
  }

  Widget buildElementItem(ElementItem item) {
    final album = _albums.firstWhere((a) => a.id == item.content,
        orElse: () => Album(
            id: '',
            name: '',
            description: '',
            coverImageUrl: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()));
    return ElementBuilder.build(context, item, album, _albums.indexOf(album));
  }
}
