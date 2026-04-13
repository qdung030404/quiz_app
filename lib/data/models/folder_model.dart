import 'package:quiz_app/data/models/flashcard_set_model.dart';

class FolderModel {
  final String? id;
  final String? userId;
  final String title;
  final int setCount;
  final DateTime? createdAt;
  final List<FlashCardSetModel> flashcardSets; // Đổi tên 'set' thành 'flashcardSets' để tránh nhầm lẫn

  FolderModel({
    this.id,
    this.userId,
    required this.title,
    this.setCount = 0,
    this.createdAt,
    this.flashcardSets = const [], // Mặc định là mảng rỗng thay vì null
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    int count = 0;
    // Xử lý đếm số bộ thẻ trong folder nếu có join từ Supabase
    if (json['flashcardset'] != null && json['flashcardset'] is List) {
      final list = json['flashcardset'] as List;
      // Nếu Supabase trả về dạng count của join
      if (list.isNotEmpty && list[0].containsKey('count')) {
        count = list[0]['count'] ?? 0;
      } else {
        count = list.length;
      }
    } else if (json['set_count'] != null) {
      count = json['set_count'];
    }

    return FolderModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      title: json['title']?.toString() ?? 'Không tiêu đề',
      setCount: count,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      flashcardSets: (json['flashcardset'] != null && json['flashcardset'] is List)
          ? (json['flashcardset'] as List)
          .where((i) => i is Map && i.containsKey('id')) // Chỉ map nếu là object hợp lệ
          .map((i) => FlashCardSetModel.fromJson(i))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'user_id': userId,
    };
  }

  FolderModel copyWith({
    String? title,
    int? setCount,
    List<FlashCardSetModel>? flashcardSets,
  }) {
    return FolderModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      setCount: setCount ?? this.setCount,
      createdAt: createdAt,
      flashcardSets: flashcardSets ?? this.flashcardSets,
    );
  }
}
