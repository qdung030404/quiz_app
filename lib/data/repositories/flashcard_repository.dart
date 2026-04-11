import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quiz_app/data/models/flashcard_model.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';

class FlashcardRepository {
  final _supabase = Supabase.instance.client;

  SupabaseClient get client => _supabase;

  /// 1. Lấy danh sách các Bộ thẻ của người dùng hiện tại
  Future<List<FlashCardSetModel>> getFlashCardSets() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('flashcardset')
          .select('*, flashcards(count)') // Lấy thêm số lượng thẻ trong mỗi bộ
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => FlashCardSetModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching flashcard sets: $e');
      return [];
    }
  }

  /// 2. Lấy danh sách Thẻ bài của một Bộ thẻ cụ thể
  Future<List<FlashCardModel>> getCardsInSet(String setId) async {
    try {
      final response = await _supabase
          .from('flashcards')
          .select('*')
          .eq('set_id', setId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => FlashCardModel.formJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching cards in set: $e');
      return [];
    }
  }

  /// 3. Lấy chi tiết Bộ thẻ kèm theo toàn bộ Thẻ bài bên trong (Joins)
  Future<FlashCardSetModel?> getSetDetail(String setId) async {
    try {
      final response = await _supabase
          .from('flashcardset')
          .select('*, flashcards(*)')
          .eq('id', setId)
          .single();

      return FlashCardSetModel.fromJson(response);
    } catch (e) {
      print('❌ Error fetching set detail: $e');
      return null;
    }
  }

  /// 4. Tạo mới một Bộ thẻ
  Future<FlashCardSetModel?> createSet(String title) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('flashcardset')
          .insert({
            'title': title,
            'user_id': userId,
          })
          .select()
          .single();

      return FlashCardSetModel.fromJson(response);
    } catch (e) {
      print('❌ Error creating set: $e');
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
      print('❌ Error adding flashcard: $e');
      return null;
    }
  }

  /// 5b. Thêm nhiều Thẻ bài cùng lúc (Bulk Insert)
  Future<List<FlashCardModel>> addCards(List<FlashCardModel> cards) async {
    try {
      final List<Map<String, dynamic>> data = cards.map((c) => c.toJson()).toList();
      
      final response = await _supabase
          .from('flashcards')
          .insert(data)
          .select();

      return (response as List)
          .map((json) => FlashCardModel.formJson(json))
          .toList();
    } catch (e) {
      print('❌ Error bulk adding flashcards: $e');
      return [];
    }
  }

  /// 6. Xóa một Bộ thẻ (Sẽ tự động xóa các thẻ bên trong do CASCADE)
  Future<bool> deleteSet(String setId) async {
    try {
      await _supabase.from('flashcardset').delete().eq('id', setId);
      return true;
    } catch (e) {
      print('❌ Error deleting set: $e');
      return false;
    }
  }
}