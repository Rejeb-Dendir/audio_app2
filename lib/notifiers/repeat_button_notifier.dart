import 'package:flutter/foundation.dart';

enum RepeatState {
  off,
  repeatSong,
  repeatPlaylist,
}

class RepeatButtonNotifier extends ChangeNotifier {
  RepeatState _value = RepeatState.off;

  RepeatState get value => _value;

  set value(RepeatState value) {
    _value = value;
    notifyListeners();
  }

  void nextState() {
    final next = (_value.index + 1) % RepeatState.values.length;
    _value = RepeatState.values[next];
    notifyListeners();
  }
}
