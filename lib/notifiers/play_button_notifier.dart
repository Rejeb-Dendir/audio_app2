import 'package:flutter/foundation.dart';

enum ButtonState {
  paused,
  playing,
  loading,
}

class PlayButtonNotifier extends ChangeNotifier {
  ButtonState _value = ButtonState.paused;

  ButtonState get value => _value;

  set value(ButtonState value) {
    _value = value;
    notifyListeners();
  }
}
