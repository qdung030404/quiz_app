import 'package:quiz_app/data/models/public_folder_model.dart';
import 'package:quiz_app/data/models/public_set_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PublicRepository {
  final _supabase = Supabase.instance.client;

  Future<List<PublicFolderModel>> getPublicFolders() async {
    try {
      final response = await _supabase.from('public_folders').select('*, public_sets(count)');
      return (response as List)
          .map((json) => PublicFolderModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching public folders: $e');
      return [];
    }
  }

  Future<List<PublicSetModel>> getPublicSets() async {
    try {
      final response = await _supabase.from('public_sets').select('*');
      final data = response as List;
      return data.map((json) {
        try {
          return PublicSetModel.fromJson(json);
        } catch (e) {
          return PublicSetModel(title: 'Lỗi nạp dữ liệu');
        }
      }).toList();
    } catch (e) {
      print('Error fetching public sets: $e');
      return [];
    }
  }
}