enum QuestionType { multipleChoice, writing }

class LearnQuestion {
  final String cardId;
  final String question; // Usually terminology or definition
  final String correctAnswer;
  final QuestionType type;
  final List<String>? options; // Only for multipleChoice

  LearnQuestion({
    required this.cardId,
    required this.question,
    required this.correctAnswer,
    required this.type,
    this.options,
  });
}
