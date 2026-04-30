import 'package:quiz_app/data/models/flashcard_model.dart';

class PublicSetModel {
  final String? id;
  final String title;
  final int totalCards;
  final DateTime? createdAt;
  final int? categoryId;
  final String? publicFolderId;
  final List<FlashCardModel>? cards;

  PublicSetModel({
    this.id,
    required this.title,
    this.totalCards = 0,
    this.createdAt,
    this.categoryId,
    this.publicFolderId,
    this.cards,
  });

  factory PublicSetModel.fromJson(Map<String, dynamic> json) {
    return PublicSetModel(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? 'Không tiêu đề',
      totalCards: json['total_cards'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      categoryId: json['category_id'] as int?,
      publicFolderId: json['public_folder_id']?.toString(),
      // Mapping for join cases if needed
      cards: json['public_cards'] != null && json['public_cards'] is List
          ? (json['public_cards'] as List)
              .map((i) => FlashCardModel.formJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'total_cards': totalCards,
      'category_id': categoryId,
      'public_folder_id': publicFolderId,
    };
  }

  PublicSetModel copyWith({
    String? title,
    int? totalCards,
    int? categoryId,
    String? publicFolderId,
    List<FlashCardModel>? cards,
  }) {
    return PublicSetModel(
      id: id,
      title: title ?? this.title,
      totalCards: totalCards ?? this.totalCards,
      createdAt: createdAt,
      categoryId: categoryId ?? this.categoryId,
      publicFolderId: publicFolderId ?? this.publicFolderId,
      cards: cards ?? this.cards,
    );
  }
}
