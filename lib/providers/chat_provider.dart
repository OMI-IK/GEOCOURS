import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/conversation.dart';
import '../services/gemini_service.dart';
import '../services/storage_service.dart';

class ChatProvider extends ChangeNotifier {
  List<Conversation> _conversations = [];
  String? _activeConversationId;
  bool _isLoading = false;
  String? _error;

  List<Conversation> get conversations => _conversations;
  String? get activeConversationId => _activeConversationId;

  Conversation? get activeConversation {
    if (_activeConversationId == null) return null;
    try {
      return _conversations.firstWhere((c) => c.id == _activeConversationId);
    } catch (e) {
      return null;
    }
  }

  List<Message> get messages => activeConversation?.messages ?? [];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    _conversations = await StorageService.getConversations();
    _activeConversationId = await StorageService.getActiveConversationId();

    // If there's a saved active conversation but it doesn't exist, reset
    if (_activeConversationId != null && activeConversation == null) {
      _activeConversationId = null;
    }

    // If no conversations, create a new one
    if (_conversations.isEmpty) {
      await newConversation();
    }

    notifyListeners();
  }

  Future<void> newConversation() async {
    final newConv = Conversation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Nouvelle conversation',
      messages: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _conversations.insert(0, newConv);
    _activeConversationId = newConv.id;
    _error = null;

    await _saveConversations();
    notifyListeners();
  }

  Future<void> setActiveConversation(String conversationId) async {
    _activeConversationId = conversationId;
    _error = null;
    await StorageService.setActiveConversationId(conversationId);
    notifyListeners();
  }

  Future<void> deleteConversation(String conversationId) async {
    _conversations.removeWhere((c) => c.id == conversationId);

    if (_activeConversationId == conversationId) {
      _activeConversationId = _conversations.isEmpty
          ? null
          : _conversations.first.id;
      await StorageService.setActiveConversationId(_activeConversationId);
    }

    await _saveConversations();
    notifyListeners();
  }

  Future<void> sendMessage(String content, bool isOnline) async {
    if (content.trim().isEmpty || activeConversation == null) return;

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...activeConversation!.messages, userMessage];
    final updatedConversation = activeConversation!.copyWith(
      messages: updatedMessages,
      updatedAt: DateTime.now(),
      // Set title from first user message if it's the first message
      title: activeConversation!.messages.isEmpty
          ? Conversation.generateTitle(updatedMessages)
          : activeConversation!.title,
    );

    _updateConversation(updatedConversation);
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (!isOnline) {
      _error =
          'Veuillez activer votre connexion internet pour utiliser l\'assistant IA.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await GeminiService.sendMessage(
        content,
        activeConversation!.messages,
      );

      final assistantMessage = Message(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      final finalMessages = [...updatedMessages, assistantMessage];
      final finalConversation = updatedConversation.copyWith(
        messages: finalMessages,
        updatedAt: DateTime.now(),
      );

      _updateConversation(finalConversation);
      await _saveConversations();
    } catch (e) {
      _error = 'Erreur: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void _updateConversation(Conversation conversation) {
    final index = _conversations.indexWhere((c) => c.id == conversation.id);
    if (index != -1) {
      _conversations[index] = conversation;
    }
  }

  Future<void> _saveConversations() async {
    await StorageService.saveConversations(_conversations);
    if (_activeConversationId != null) {
      await StorageService.setActiveConversationId(_activeConversationId!);
    }
  }

  Future<void> clearHistory() async {
    await StorageService.clearChatHistory();
    _conversations = [];
    _activeConversationId = null;
    await newConversation();
  }
}
