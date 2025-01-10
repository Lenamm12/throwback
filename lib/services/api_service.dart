import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tag_model.dart';
import '../models/album_model.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8000';

  Future<http.Response> _get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode == 307) {
      final redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        return await http.get(Uri.parse(redirectUrl));
      }
    }
    throw Exception('Failed to load data: ${response.statusCode}');
  }

  Future<http.Response> _post(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to create data');
    }
  }

  Future<http.Response> _put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<http.Response> _delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 204) {
      return response;
    } else {
      throw Exception('Failed to delete data');
    }
  }

  // Tag-related methods
  Future<List<Tag>> getTags() async {
    return [];
    final response = await _get('tags');
    List<dynamic> tagsJson = jsonDecode(response.body);
    return tagsJson.map((json) => Tag.fromMap(json)).toList();
  }

  Future<Tag> createTag(Tag tag) async {
    final response = await _post('tags', tag.toMap());
    return Tag.fromMap(jsonDecode(response.body));
  }

  Future<Tag> updateTag(Tag tag) async {
    final response = await _put('tags/${tag.id}', tag.toMap());
    return Tag.fromMap(jsonDecode(response.body));
  }

  Future<void> deleteTag(String tagId) async {
    await _delete('tags/$tagId');
  }

  // Album-related methods
  Future<List<Album>> getAlbums() async {
    return [];
    final response = await _get('albums');
    List<dynamic> albumsJson = jsonDecode(response.body);
    return albumsJson.map((json) => Album.fromMap(json)).toList();
  }

  Future<Album> createAlbum(Album album) async {
    final response = await _post('albums', album.toMap());
    return Album.fromMap(jsonDecode(response.body));
  }

  Future<Album> updateAlbum(Album album) async {
    final response = await _put('albums/${album.id}', album.toMap());
    return Album.fromMap(jsonDecode(response.body));
  }

  Future<void> deleteAlbum(String albumId) async {
    await _delete('albums/$albumId');
  }

  // Media-related methods
  Future<void> uploadMedia(String filePath, List<String> tags) async {
    // Implement file upload logic here
    // You may need to use a different package for file uploads, such as dio
  }

  Future<void> deleteMedia(String mediaId) async {
    await _delete('media/$mediaId');
  }

  Future<void> addTagToMedia(String mediaId, String tagId) async {
    await _post('media/$mediaId/tags', {'tag_id': tagId});
  }

  Future<void> removeTagFromMedia(String mediaId, String tagId) async {
    await _delete('media/$mediaId/tags/$tagId');
  }

  // Visibility-related methods
  Future<void> toggleTagVisibility(String tagId, bool isVisible) async {
    await _put('tags/$tagId/visibility', {'is_visible': isVisible});
  }

  // Portfolio-related methods
  Future<Map<String, dynamic>> getPortfolio() async {
    final response = await _get('portfolio');
    return jsonDecode(response.body);
  }

  Future<void> updatePortfolio(Map<String, dynamic> portfolioData) async {
    await _put('portfolio', portfolioData);
  }
}
