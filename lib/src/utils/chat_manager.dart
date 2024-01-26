import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatManager {
  List<types.Message> messages = [];
  final user = const types.User(id: 'user');
  final bot = const types.User(id: 'model', firstName: 'Gemini');
  bool isLoading = false;
  WebSocketChannel? channel;
  bool isConversationActive = true;

  void initializeWebsocket() {
    try {
      channel = IOWebSocketChannel.connect('ws://10.0.2.2:8000/ws');
    } catch (e) {
      debugPrint('WebSocket connection failed: $e');
    }
  }

  void disposeWebsocket() {
    channel?.sink.close();
  }

  void addMessage(types.Message message) {
    messages.insert(0, message);
    isLoading = true;
    if (message is types.TextMessage) {
      var messageJson = json.encode({'text': message.text});
      debugPrint(messageJson.toString());
      channel?.sink.add(messageJson);
    }
  }

  // Adicione uma nova variável de membro na classe ChatManager
  String _bufferedMessage = '';

  void onMessageReceived(String response) {
    if (response.endsWith('.')) {
      // Se a resposta termina com um ponto, assuma que é o final da mensagem
      _bufferedMessage += response; // Concatena a parte recebida
      messages.insert(
        0,
        types.TextMessage(
          author: bot,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: _bufferedMessage, // Use a mensagem completa
        ),
      );
      _bufferedMessage = ''; // Limpa o buffer para a próxima mensagem
    } else {
      // Se não for o fim da mensagem, apenas adicione ao buffer
      _bufferedMessage += response;
    }
    isLoading = false;
  }
}
