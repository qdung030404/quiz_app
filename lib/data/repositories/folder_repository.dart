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
}
