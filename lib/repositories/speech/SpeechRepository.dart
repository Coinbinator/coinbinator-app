import 'package:flutter_tts/flutter_tts.dart';

final tts = FlutterTts();

class SpeechRepository {
  Future<void> speak(String text) async {
    await tts.speak(text);
  }
}
