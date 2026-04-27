import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_model.dart';
import 'package:quiz_app/data/models/match_item_model.dart';
import 'package:quiz_app/feature/match/view/match_result_screen.dart';

import '../view/match_screen.dart';

class MatchController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var cards = <MatchItemModel>[].obs;
  var selectedIndices = <int>[].obs;
  var isBestAchievement = true.obs;
  var isGameOver = false.obs;
  var isRunning = false.obs;
  var isMuted = true.obs;
  RxDouble bestAchievement = 0.0.obs;
  RxDouble currentAchievement = 0.0.obs;
  RxDouble second = 0.0.obs;
  Timer? timer;

  void _playBackgroundMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/match_background_audio.mp3'));
  }

  void toggleSound() {
    isMuted.value = !isMuted.value;

    if (isMuted.value) {
      _audioPlayer.setVolume(1); // Tắt tiếng (nhưng nhạc vẫn chạy ngầm)
    } else {
      _audioPlayer.setVolume(0); // Bật tiếng lại
    }
  }

  void startTimer() {
    if (isRunning.value) return;
    isRunning.value = true;
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      second.value += 0.1;
    });
  }

  void pauseTimer() {
    isRunning.value = false;
    timer?.cancel();
  }

  void initializeCards(List<FlashCardModel> flashcards) {
    second.value = 0.0; // Reset timer for new game
    List<FlashCardModel> allCards = [...flashcards];
    allCards.shuffle();
    if (allCards.length > 6) {
      allCards = allCards.sublist(0, 6);
    }
    List<MatchItemModel> newCards = [];
    for (var card in allCards) {
      newCards.add(
        MatchItemModel(
          text: card.terminology,
          flashcardId: card.id!,
          isTerminology: true,
        ),
      );
      newCards.add(
        MatchItemModel(
          text: card.definition,
          flashcardId: card.id!,
          isTerminology: false,
        ),
      );
    }
    newCards.shuffle();
    cards.assignAll(newCards);
    selectedIndices.clear();
    isGameOver.value = false;
  }

  void onCardTap(int index) {
    if (cards[index].isSelected ||
        cards[index].isMatched ||
        selectedIndices.length >= 2)
      return;
    cards[index].isSelected = true;
    cards.refresh();
    selectedIndices.add(index);
    if (selectedIndices.length == 2) {
      Future.delayed(const Duration(milliseconds: 500), () {
        checkMatch();
      });
    }
  }

  void checkMatch() {
    int firstIndex = selectedIndices[0];
    int secondIndex = selectedIndices[1];
    if (cards[firstIndex].flashcardId == cards[secondIndex].flashcardId &&
        cards[firstIndex].isTerminology != cards[secondIndex].isTerminology) {
      cards[firstIndex].isMatched = true;
      cards[secondIndex].isMatched = true;
      if (cards.every((card) => card.isMatched)) {
        isGameOver.value = true;
        currentAchievement.value = second.value;
        _audioPlayer.stop();
        checkBestAchievement();
        result();
      }
    } else {
      cards[firstIndex].isSelected = false;
      cards[secondIndex].isSelected = false;
    }
    selectedIndices.clear();
    cards.refresh();
  }

  bool checkBestAchievement() {
    if (bestAchievement.value == 0.0 ||
        currentAchievement.value < bestAchievement.value) {
      bestAchievement.value = currentAchievement.value;
      isBestAchievement.value = true;
      return true;
    }
    isBestAchievement.value = false;
    return false;
  }

  void startGame(List<FlashCardModel> flashcards) {
    initializeCards(flashcards);
    _playBackgroundMusic();
    startTimer();
    Get.to(() => MatchScreen());
  }

  void resetGame() {
    cards.clear();
    selectedIndices.clear();
    isGameOver.value = false;
    Get.back();
  }

  void result() {
    pauseTimer();
    Get.to(() => const MatchResultScreen());
  }

  @override
  void onClose() {
    timer?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.onClose();
  }
}
