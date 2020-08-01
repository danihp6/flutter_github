import 'package:flutter/material.dart';

ThemeMode toThemeMode(String themeMode){
  switch (themeMode) {
    case 'ThemeMode.light': return ThemeMode.light;
    case 'ThemeMode.dark':return ThemeMode.dark;
    case 'ThemeMode.system':return ThemeMode.system;
    default: return null;
  }
}