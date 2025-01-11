import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/album_model.dart';
import '../models/element_model.dart';
import '../models/tag_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreService();

  // ElementItem-related methods
  Future<QuerySnapshot> getElements() async {
    return await _firestore.collection('elements').get();
  }

  Future<void> createElement(ElementItem element) async {
    await _firestore.collection('elements').add(element.toMap());
  }

  Future<void> updateElement(ElementItem element) async {
    await _firestore
        .collection('elements')
        .doc(element.id)
        .update(element.toMap());
  }

  Future<void> deleteElement(String elementId) async {
    await _firestore.collection('elements').doc(elementId).delete();
  }

  // Tag-related methods
  Future<QuerySnapshot> getTags() async {
    return await _firestore.collection('tags').get();
  }

  Future<void> createTag(Tag tag) async {
    await _firestore.collection('tags').add(tag.toMap());
  }

  Future<void> updateTag(Tag tag) async {
    await _firestore.collection('tags').doc(tag.id).update(tag.toMap());
  }

  Future<void> deleteTag(String tagId) async {
    await _firestore.collection('tags').doc(tagId).delete();
  }

  // Album-related methods
  Future<QuerySnapshot> getAlbums() async {
    return await _firestore.collection('albums').get();
  }

  Future<void> createAlbum(Album album) async {
    await _firestore.collection('albums').add(album.toMap());
  }

  Future<void> updateAlbum(Album album) async {
    await _firestore.collection('albums').doc(album.id).update(album.toMap());
  }

  Future<void> deleteAlbum(String albumId) async {
    await _firestore.collection('albums').doc(albumId).delete();
  }

  // Media-related methods
  Future<void> uploadMedia(String filePath, List<String> tags) async {
    // Implement file upload logic here
    // You may need to use a different package for file uploads, such as firebase_storage
  }

  Future<void> deleteMedia(String mediaId) async {
    await _firestore.collection('media').doc(mediaId).delete();
  }

  Future<void> addTagToMedia(String mediaId, String tagId) async {
    await _firestore.collection('media').doc(mediaId).update({
      'tags': FieldValue.arrayUnion([tagId])
    });
  }

  Future<void> removeTagFromMedia(String mediaId, String tagId) async {
    await _firestore.collection('media').doc(mediaId).update({
      'tags': FieldValue.arrayRemove([tagId])
    });
  }

  // Visibility-related methods
  Future<void> toggleTagVisibility(String tagId, bool isVisible) async {
    await _firestore
        .collection('tags')
        .doc(tagId)
        .update({'isVisible': isVisible});
  }

  // Portfolio-related methods
  Future<DocumentSnapshot> getPortfolio() async {
    return await _firestore.collection('portfolio').doc('portfolio').get();
  }

  Future<void> updatePortfolio(Map<String, dynamic> portfolioData) async {
    await _firestore
        .collection('portfolio')
        .doc('portfolio')
        .update(portfolioData);
  }
}
