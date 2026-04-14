import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/models/folder_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FolderRepository {
  final _supabase = Supabase.instance.client;

  SupabaseClient get client => _supabase;

  Future<FolderModel?> createFolder(String title) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final result = await _supabase
          .from('folder')
          .insert({'title': title, 'user_id': userId})
          .select()
          .single();
      return FolderModel.fromJson(result);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<FolderModel>> getFolder() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final result = await _supabase
          .from('folder')
          .select('*, flashcardset(count)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      print('getFolder result: $result'); // Debug xem data trả về
      return (result as List).map((json) {
        try {
          return FolderModel.fromJson(json);
        } catch (e) {
          print('Error parsing folder: $e');
          return FolderModel(title: 'Lỗi dữ liệu');
        }
      }).toList();
    } catch (e) {
      print('Error fetching folder: $e'); // Xem lỗi thực sự là gì
      return [];
    }
  }

  Future<List<FlashCardSetModel>> getSetInFolder(String folderId) async {
    try {
      final respone = await _supabase
          .from('flashcardset')
          .select()
          .eq('folder_id', folderId)
          .order('created_at', ascending: true);
      return (respone as List)
          .map((json) => FlashCardSetModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching : $e');
      return [];
    }
  }
}
