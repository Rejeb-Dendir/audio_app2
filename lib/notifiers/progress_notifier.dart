import 'package:flutter/foundation.dart';

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
}

class ProgressNotifier extends ChangeNotifier {
  ProgressBarState _value = ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );

  ProgressBarState get value => _value;

  set value(ProgressBarState value) {
    _value = value;
    notifyListeners();
  }
}
