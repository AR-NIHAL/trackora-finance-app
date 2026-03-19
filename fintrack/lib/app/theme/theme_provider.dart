import 'package:flutter/material.dart';
import 'package:riverpod/legacy.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light;
});
