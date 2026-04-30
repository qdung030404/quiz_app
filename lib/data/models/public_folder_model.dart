class PublicFolderModel {
  final String? id;
  final String title;
  final int? setCount;
  final DateTime? createdAt;

  PublicFolderModel({
    this.id,
    required this.title,
    this.createdAt,
    this.setCount,
  });

  factory PublicFolderModel.fromJson(Map<String, dynamic> json) {
    int count = 0;
    if (json['public_sets'] != null && json['public_sets'] is List) {
      final list = json['public_sets'] as List;
      if (list.isNotEmpty && list[0] is Map && list[0].containsKey('count')) {
        count = list[0]['count'] ?? 0;
      } else {
        count = list.length;
      }
    } else if (json['set_count'] != null) {
      count = int.tryParse(json['set_count'].toString()) ?? 0;
    }

    return PublicFolderModel(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? 'Không tiêu đề',
      setCount: count,
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
    int? setCount,
  }) {
    return PublicFolderModel(
      id: id,
      title: title ?? this.title,
      setCount: setCount ?? this.setCount,
      createdAt: createdAt,
    );
  }
}
