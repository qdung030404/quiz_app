import 'package:quiz_app/data/models/flashcard_model.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FlashcardRepository {
  final _supabase = Supabase.instance.client;

  SupabaseClient get client => _supabase;

  /// 1. Lấy danh sách các Bộ thẻ của người dùng hiện tại
  Future<List<FlashCardSetModel>> getFlashCardSets() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('flashcard_set')
          .select('*, flashcards(count)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      final data = response as List;
      return data.map((json) {
        try {
          return FlashCardSetModel.fromJson(json);
        } catch (e) {
          return FlashCardSetModel(title: 'Lỗi dữ liệu');
        }
      }).toList();
    } catch (e) {
      print('Error fetching flashcard sets: $e');
      return [];
    }
  }

  /// 2. Lấy danh sách Thẻ bài của một Bộ thẻ cụ thể
  Future<List<FlashCardModel>> getCardsInSet(String setId, {bool isPublic = false}) async {
    try {
      final tableName = isPublic ? 'public_cards' : 'flashcards';
      final response = await _supabase
          .from(tableName)
          .select('*')
          .eq('set_id', setId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => FlashCardModel.formJson(json))
          .toList();
    } catch (e) {
      print(' Error fetching cards in set: $e');
      return [];
    }
  }

  /// 3. Lấy chi tiết Bộ thẻ kèm theo toàn bộ Thẻ bài bên trong (Joins)
  Future<FlashCardSetModel?> getSetDetail(String setId) async {
    try {
      final response = await _supabase
          .from('flashcard_set')
          .select('*, flashcards(*)')
          .eq('id', setId)
          .single();

      return FlashCardSetModel.fromJson(response);
    } catch (e) {
      print(' Error fetching set detail: $e');
      return null;
    }
  }

  /// 4. Tạo mới một Bộ thẻ
  Future<FlashCardSetModel?> createSet(
    String title, {
    bool isPublic = false,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('flashcard_set')
          .insert({'title': title, 'user_id': userId, 'is_public': isPublic})
          .select()
          .single();

      return FlashCardSetModel.fromJson(response);
    } catch (e) {
      print(' Error creating set: $e');
      return null;
    }
  }

  /// 5. Thêm một Thẻ bài mới vào bộ
  Future<FlashCardModel?> addCard(FlashCardModel card) async {
    try {
      final response = await _supabase
          .from('flashcards')
          .insert(card.toJson())
          .select()
          .single();

      return FlashCardModel.formJson(response);
    } catch (e) {
      print(' Error adding flashcard: $e');
      return null;
    }
  }

  /// 5b. Thêm nhiều Thẻ bài cùng lúc (Bulk Insert)
  Future<List<FlashCardModel>> addCards(List<FlashCardModel> cards) async {
    try {
      final List<Map<String, dynamic>> data = cards
          .map((c) => c.toJson())
          .toList();

      final response = await _supabase.from('flashcards').insert(data).select();

      return (response as List)
          .map((json) => FlashCardModel.formJson(json))
          .toList();
    } catch (e) {
      print(' Error bulk adding flashcards: $e');
      return [];
    }
  }

  /// 6. Xóa một Bộ thẻ (Sẽ tự động xóa các thẻ bên trong do CASCADE)
  Future<bool> deleteSet(String setId) async {
    try {
      await _supabase.from('flashcard_set').delete().eq('id', setId);
      return true;
    } catch (e) {
      print(' Error deleting set: $e');
      return false;
    }
  }
  Future<bool> deleteCard(String cardId) async {
    try {
      await _supabase
          .from('flashcards')
          .delete()
          .eq('id', cardId);
      return true;
    } catch (e) {
      print(' Error deleting card: $e');
      return false;
    }
  }
  Future<bool> updateSet(FlashCardSetModel set) async {
    try {
      if (set.id == null) return false;
      final updates = {
        'title': set.title,
        'is_public': set.isPublic,
      };

      await _supabase
          .from('flashcard_set')
          .update(updates)
          .eq('id', set.id!);

      return true;
    } catch (e) {
      print(' Error updating set: $e');
      return false;
    }
  }
  Future<bool> updateCard(FlashCardModel card) async {
    try {
      if (card.id == null) return false;
      final updates = {
        'terminology': card.terminology,
        'definition': card.definition,
        'terminology_language': card.terminologyLanguage,
        'definition_language': card.definitionLanguage,};
      await _supabase
          .from('flashcards')
          .update(updates)
          .eq('id', card.id!);
      return true;
    } catch (e) {
      print(' Error updating card: $e');
      return false;
    }
  }
}
