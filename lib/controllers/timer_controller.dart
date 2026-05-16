import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerController extends ChangeNotifier {
  // timer durations in seconds 
  static const int focusDuration = 25 * 60; // 25 minutes
  static const int breakDuration = 5  * 60; // 5 minutes

  // private state 
  int     _remainingSeconds = focusDuration;
  bool    _isRunning        = false;
  bool    _isFocusMode      = true;
  int     _sessionCount     = 0;
  Timer?  _timer;

  // public getters 
  int  get remainingSeconds => _remainingSeconds;
  bool get isRunning        => _isRunning;
  bool get isFocusMode      => _isFocusMode;
  int  get sessionCount     => _sessionCount;

  // progress 0.0 to 1.0 — dial painter reads this 
  double get progress {
    final total = _isFocusMode ? focusDuration : breakDuration;
    return 1 - (_remainingSeconds / total);
  }

  // formats remaining seconds into MM:SS 
  String get timeDisplay {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds  % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // called once in main.dart 
  Future<void> loadFromPrefs() async {
    final prefs  = await SharedPreferences.getInstance();
    _sessionCount = prefs.getInt('sessionCount') ?? 0;
    notifyListeners();
  }

  // 
  // CONTROLS
  // 

  //starts the countdown 
  void start() {
    if (_isRunning) return;
    _isRunning = true;

    // fires every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  // pauses the countdown
  void pause() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  // resets to the start of the current mode
  void reset() {
    _isRunning = false;
    _timer?.cancel();
    _remainingSeconds = _isFocusMode ? focusDuration : breakDuration;
    notifyListeners();
  }

  // switches between Focus and Break manually 
  void setMode(bool isFocus) {
    _isRunning = false;
    _timer?.cancel();
    _isFocusMode      = isFocus;
    _remainingSeconds = isFocus ? focusDuration : breakDuration;
    notifyListeners();
  }

  // 
  // PRIVATE
  // 

  // called every second by the Timer
  void _tick() {
    if (_remainingSeconds > 0) {
      _remainingSeconds--;
      notifyListeners();
    } else {
      // countdown hit zero
      _timer?.cancel();
      _isRunning = false;
      _onSessionComplete();
    }
  }

  // fires when a session ends
  Future<void> _onSessionComplete() async {
    if (_isFocusMode) {
      // focus session done increment count and switch to break
      _sessionCount++;
      await _saveSessionCount();
      _isFocusMode      = false;
      _remainingSeconds = breakDuration;
    } else {
      // break done switch back to focus
      _isFocusMode      = true;
      _remainingSeconds = focusDuration;
    }
    notifyListeners();
  }

  // persists session count to SharedPreferences 
  Future<void> _saveSessionCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sessionCount', _sessionCount);
  }

  // always cancel the timer when controller is disposed 
  // this prevents memory leaks
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}