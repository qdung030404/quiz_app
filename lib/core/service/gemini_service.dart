import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API not found in .env file');
    }
    _model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
    );
  }

  Future<String?> generateContent(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text;
    } catch (e) {
      print('Error generating content: $e');
      return null;
    }
  }

  Future<String?> generateFlashcards(String topic) async {
    final prompt = '''
      Generate 5 flashcards for the topic: $topic.
      Format the output as a JSON list of objects, each with "front" and "back" keys.
      Return ONLY the JSON.
    ''';
    return generateContent(prompt);
  }

  Future<String?> generateDefinitions({
    required String word,
    required String terminologyLanguage,
    required String definitionLanguage,
  }) async {
    final prompt = '''
Đóng vai một từ điển song ngữ chuyên nghiệp ($terminologyLanguage - $definitionLanguage).
Hãy cung cấp các định nghĩa phổ biến nhất của từ "$word" dưới dạng danh sách ngắn gọn.

Yêu cầu:
1. Định dạng chính xác: "$word: (loại từ) định nghĩa, (loại từ) định nghĩa"
2. Ví dụ: "hard: (adj) khó, (adv) chăm chỉ"
3. Không thêm bất kỳ văn bản giải thích nào khác.
4. Chỉ lấy các nghĩa phổ biến nhất.
5. Ngôn ngữ của định nghĩa là $definitionLanguage.
''';
    return generateContent(prompt);
  }
}
