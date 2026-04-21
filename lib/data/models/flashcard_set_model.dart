import 'package:quiz_app/data/models/flashcard_model.dart';

class FlashCardSetModel {
  final String? id;
  final String? userId;
  final String title;
  final int cardCount;
  final bool isPublic;
  final DateTime? createdAt;
  final List<FlashCardModel>? cards;

  FlashCardSetModel({
    this.id,
    this.userId,
    required this.title,
    this.cardCount = 0,
    this.isPublic = false,
    this.createdAt,
    this.cards,
  });

  /// Chuyển đổi từ JSON (Supabase) sang Model
  factory FlashCardSetModel.fromJson(Map<String, dynamic> json) {
    int count = 0;
    if (json['flashcards'] != null && json['flashcards'] is List) {
      final list = json['flashcards'] as List;
      if (list.isNotEmpty && list[0] is Map) {
        count = list[0]['count'] ?? 0;
      }
    } else if (json['flashcards_count'] != null) {
      count = json['flashcards_count'];
    }

    return FlashCardSetModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      title: json['title']?.toString() ?? 'Không tiêu đề',
      cardCount: count,
      isPublic: json['is_public'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      // Ánh xạ danh sách thẻ bài nếu có đính kèm trong JSON (đã đổi tên từ formJson sang fromJson cho đồng nhất nếu cần)
      cards:
          json['flashcards'] != null &&
              json['flashcards'] is List &&
              (json['flashcards'] as List).isNotEmpty &&
              (json['flashcards'] as List)[0].containsKey('id')
          ? (json['flashcards'] as List)
                .map((i) => FlashCardModel.formJson(i))
                .toList()
          : null,
    );
  }

  /// Chuyển đổi từ Model sang JSON để lưu/cập nhật lên Supabase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'user_id': userId,
      'is_public': isPublic,
      // 'id' và 'created_at' thường do Database tự sinh
    };
  }

  /// Phương thức sao chép với các thay đổi (dùng cho việc cập nhật state)
  FlashCardSetModel copyWith({
    String? title,
    String? description,
    int? cardCount,
    bool? isPublic,
    List<FlashCardModel>? cards,
  }) {
    return FlashCardSetModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      cardCount: cardCount ?? this.cardCount,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt,
      cards: cards ?? this.cards,
    );
  }
}
