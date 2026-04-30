class PublicFolderModel {
  final String? id;
  final String title;
  final DateTime? createdAt;

  PublicFolderModel({
    this.id,
    required this.title,
    this.createdAt,
  });

  factory PublicFolderModel.fromJson(Map<String, dynamic> json) {
    return PublicFolderModel(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? 'Không tiêu đề',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
    };
  }

  PublicFolderModel copyWith({
    String? title,
  }) {
    return PublicFolderModel(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
    );
  }
}
