class FlashCardModel {
  final String? id;
  final String setId;
  final String? userId;
  final String terminology;
  final String terminologyLanguage;
  final String definition;
  final String definitionLanguage;
  final DateTime? createdAt;

  FlashCardModel({
    this.id,
    required this.setId,
    this.userId,
    required this.terminology,
    this.terminologyLanguage = 'en',
    required this.definition,
    this.definitionLanguage = 'vi',
    this.createdAt,
  });

  /// Chuyển đổi từ JSON (Supabase) sang Model
  factory FlashCardModel.formJson(Map<String, dynamic> json) {
    return FlashCardModel(
      id: json['id']?.toString(),
      setId: json['set_id']?.toString() ?? '',
      userId: json['user_id']?.toString(), // Tùy chọn vì public_cards không có user_id
      terminology: json['terminology']?.toString() ?? '',
      terminologyLanguage: json['terminology_language']?.toString() ?? 'en',
      definition: json['definition']?.toString() ?? '',
      definitionLanguage: json['definition_language']?.toString() ?? 'vi',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  /// Chuyển đổi từ Model sang JSON để lưu/cập nhật lên Supabase
  Map<String, dynamic> toJson() {
    return {
      'set_id': setId,
      'user_id': userId,
      'terminology': terminology,
      'terminology_language': terminologyLanguage,
      'definition': definition,
      'definition_language': definitionLanguage,
      // 'id' và 'created_at' thường do Database tự sinh
    };
  }

  /// Phương thức sao chép với các thay đổi
  FlashCardModel copyWith({
    String? terminology,
    String? terminologyLanguage,
    String? definition,
    String? definitionLanguage,
  }) {
    return FlashCardModel(
      id: id,
      setId: setId,
      userId: userId,
      terminology: terminology ?? this.terminology,
      terminologyLanguage: terminologyLanguage ?? this.terminologyLanguage,
      definition: definition ?? this.definition,
      definitionLanguage: definitionLanguage ?? this.definitionLanguage,
      createdAt: createdAt,
    );
  }
}
