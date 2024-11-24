class HtmlFileMetadata {
  final String title;
  final String description;
  final String filePath; // Path to the saved HTML file
  final String coverImagePath; // Path to the cover image (optional)
  final List<String> categories;

  HtmlFileMetadata({
    required this.title,
    required this.description,
    required this.filePath,
    required this.coverImagePath,
    required this.categories,
  });

  // Convert to a Map for JSON storage
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'filePath': filePath,
      'coverImagePath': coverImagePath,
      'categories': categories,
    };
  }

  // Create from a Map
  factory HtmlFileMetadata.fromJson(Map<String, dynamic> json) {
    return HtmlFileMetadata(
      title: json['title'],
      description: json['description'],
      filePath: json['filePath'],
      coverImagePath: json['coverImagePath'],
      categories: List<String>.from(json['categories']),
    );
  }

  // Add copyWith method to clone and modify properties
  HtmlFileMetadata copyWith({
    String? title,
    String? description,
    String? filePath,
    String? coverImagePath,
    List<String>? categories,
  }) {
    return HtmlFileMetadata(
      title: title ?? this.title,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      categories: categories ?? this.categories,
    );
  }
}
