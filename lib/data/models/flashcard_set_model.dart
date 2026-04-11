import 'package:quiz_app/data/models/flashcard_model.dart';

class FlashCardSetModel {
  final String? id;
  final String? userId;
  final String title;
  final int cardCount;
  final DateTime? createdAt;
  final List<FlashCardModel>? cards;

  FlashCardSetModel({
    this.id,
    this.userId,
    required this.title,
    this.cardCount = 0,
    this.createdAt,
    this.cards,
  });

  /// Chuyển đổi từ JSON (Supabase) sang Model
  factory FlashCardSetModel.fromJson(Map<String, dynamic> json) {
    return FlashCardSetModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      // cardCount thường được lấy thông qua câu query count() từ Supabase
      cardCount: json['flashcards_count'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      // Ánh xạ danh sách thẻ bài nếu có đính kèm trong JSON
      cards: json['flashcards'] != null
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
      // 'id' và 'created_at' thường do Database tự sinh
    };
  }

  /// Phương thức sao chép với các thay đổi (dùng cho việc cập nhật state)
  FlashCardSetModel copyWith({
    String? title,
    String? description,
    int? cardCount,
    List<FlashCardModel>? cards,
  }) {
    return FlashCardSetModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      cardCount: cardCount ?? this.cardCount,
      createdAt: createdAt,
      cards: cards ?? this.cards,
    );
  }
}
