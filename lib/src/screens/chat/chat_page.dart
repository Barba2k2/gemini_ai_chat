import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:gamini_ai_chat/src/screens/settings/settings_screen.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../utils/chat_manager.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatManager chatManager = ChatManager();
  bool isPremium = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    chatManager.initializeWebsocket();
    chatManager.onMessageUpdated = () {
      setState(() {});
    };
    chatManager.channel?.stream.listen((event) {
      try {
        final Map<String, dynamic> data = json.decode(event);
        final String text = data['text'];
        chatManager.onMessageReceived(text);
        setState(() {});
      } on FormatException {
        chatManager.onMessageReceived(event);
      }
      // Atualize o estado da UI
      setState(() {});
    });
  }

  @override
  void dispose() {
    chatManager.disposeWebsocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'Flutter Gemini'.toUpperCase(),
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.white,
          elevation: 0,
          width: 250,
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              Text(
                'MENU',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(20),
              ListTile(
                leading: const Icon((Icons.message)),
                title: const Text(
                  'Mensagens',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text(
                  'Perfil',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings_sharp),
                title: const Text(
                  'Configurações',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Get.to(() => const SettingsScreen());
                },
              ),
            ],
          ),
        ),
        body: Chat(
          messages: chatManager.messages,
          onAttachmentPressed: isPremium ? _handleImageSelection : null,
          onSendPressed: _handleSendPressed,
          showUserAvatars: false,
          showUserNames: true,
          user: chatManager.user,
          theme: const DefaultChatTheme(
            sendButtonIcon: Icon(
              Icons.arrow_upward_outlined,
              color: Colors.white,
              size: 26,
            ),
            backgroundColor: Colors.black87,
            inputBorderRadius: BorderRadius.zero,
            receivedMessageBodyTextStyle: TextStyle(color: Colors.white),
            secondaryColor: Color(0xFF1c1c1c),
            attachmentButtonIcon: Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
            inputBackgroundColor: Color(0xFF1c1c1c),
            seenIcon: Text(
              'read',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          customMessageBuilder: (message, {required int messageWidth}) {
            if (message.metadata?['widget'] != null) {
              final widget = message.metadata!['widget'];
              if (widget is Widget) {
                return widget;
              }
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    if (!chatManager.isLoading) {
      final textMessage = types.TextMessage(
        author: chatManager.user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: message.text,
      );
      chatManager.addMessage(textMessage);
      setState(() {});
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: chatManager.user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      chatManager.addMessage(message);
    }
  }
}
