class MatchItemModel {
  final String text;
  final String flashcardId;
  final bool isTerminology;
  bool isSelected;
  bool isMatched;

  MatchItemModel({
    required this.text,
    required this.flashcardId,
    required this.isTerminology,
    this.isSelected = false,
    this.isMatched = false,
  });
}
