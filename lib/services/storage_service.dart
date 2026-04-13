import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/matiere.dart';
import '../models/conversation.dart';

class StorageService {
  static const String _matieresKey = 'matieres';
  static const String _conversationsKey = 'conversations';
  static const String _activeConversationKey = 'active_conversation_id';
  static const String _themeKey = 'theme_mode';
  static const String _themeColorKey = 'theme_color';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveMatieres(List<Matiere> matieres) async {
    final jsonList = matieres.map((m) => m.toJson()).toList();
    await _prefs?.setString(_matieresKey, jsonEncode(jsonList));
  }

  static Future<List<Matiere>> getMatieres() async {
    final jsonString = _prefs?.getString(_matieresKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => Matiere.fromJson(json)).toList();
  }

  static Future<void> saveConversations(
    List<Conversation> conversations,
  ) async {
    final jsonList = conversations.map((c) => c.toJson()).toList();
    await _prefs?.setString(_conversationsKey, jsonEncode(jsonList));
  }

  static Future<List<Conversation>> getConversations() async {
    final jsonString = _prefs?.getString(_conversationsKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => Conversation.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Future<void> setActiveConversationId(String? id) async {
    if (id == null) {
      await _prefs?.remove(_activeConversationKey);
    } else {
      await _prefs?.setString(_activeConversationKey, id);
    }
  }

  static Future<String?> getActiveConversationId() async {
    return _prefs?.getString(_activeConversationKey);
  }

  static Future<void> clearChatHistory() async {
    await _prefs?.remove(_conversationsKey);
    await _prefs?.remove(_activeConversationKey);
  }

  static Future<void> saveThemeMode(String mode) async {
    await _prefs?.setString(_themeKey, mode);
  }

  static Future<String> getThemeMode() async {
    return _prefs?.getString(_themeKey) ?? 'light';
  }

  static Future<void> saveThemeColor(int color) async {
    await _prefs?.setInt(_themeColorKey, color);
  }

  static Future<int?> getThemeColor() async {
    return _prefs?.getInt(_themeColorKey);
  }
}
