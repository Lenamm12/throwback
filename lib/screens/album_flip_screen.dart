import 'package:flutter/material.dart';
import '../models/album_model.dart';

class AlbumFlipScreen extends StatefulWidget {
  final Album album;

  const AlbumFlipScreen({super.key, required this.album});

  @override
  State<AlbumFlipScreen> createState() => _AlbumFlipScreenState();
}

class _AlbumFlipScreenState extends State<AlbumFlipScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.name),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swipe right
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else if (details.primaryVelocity! < 0) {
            // Swipe left
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.album.mediaIds.length,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (context, index) {
            return _buildPage(widget.album.mediaIds[index]);
          },
        ),
      ),
      bottomSheet: _buildPageIndicator(),
    );
  }

  Widget _buildPage(String mediaId) {
    // TODO: Replace this with actual media content
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Text(
          'Media $mediaId',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.album.mediaIds.length,
          (index) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
