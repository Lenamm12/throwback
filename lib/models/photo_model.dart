class Photo {
  final String id;
  final String url;
  final String caption;

  Photo({
    required this.id,
    required this.url,
    this.caption = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'caption': caption,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'] ?? '',
      url: map['url'] ?? '',
      caption: map['caption'] ?? '',
    );
  }
}
