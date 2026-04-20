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
          .select('*, flashcard_set(count)')
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
          .from('flashcard_set')
          .select('*, flashcards(count)')
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

  Future<bool> addSetsToFolder(String folderId, List<String> setIds) async {
    try {
      // Chúng ta cập nhật cột folder_id cho tất cả các set có ID nằm trong danh sách setIds
      await _supabase
          .from('flashcard_set')
          .update({'folder_id': folderId}) // Gán folder_id mới
          .inFilter('id', setIds); // Lọc các bản ghi theo danh sách ID
      return true;
    } catch (e) {
      print(' Error adding sets to folder: $e');
      return false;
    }
  }

  Future<bool> removeFolder(String folderId) async {
    try {
      await _supabase
          .from('flashcard_set')
          .update({'folder_id': null})
          .eq('folder_id', folderId);

      await _supabase
          .from('folder')
          .delete()
          .eq('id', folderId);
      return true;
    } catch (e) {
      print(' Error delete folder: $e');
      return false;
    }
  }
  Future<FolderModel?> updateFolder(String folderId, String folderName) async {
    try {
      final response = await _supabase
          .from('folder')
          .update({'title': folderName})
          .eq('id', folderId)
          .select()
          .single();
          
      return FolderModel.fromJson(response);
    } catch (e) {
      print('Error updating folder: $e');
      return null;
    }
  }
}
