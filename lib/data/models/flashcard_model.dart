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
      id: json['id'] as String,
      setId: json['set_id'] as String,
      userId: json['user_id'] as String,
      terminology: json['terminology'] as String,
      terminologyLanguage: json['terminology_language'] as String? ?? 'en',
      definition: json['definition'] as String,
      definitionLanguage: json['definition_language'] as String? ?? 'vi',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
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
