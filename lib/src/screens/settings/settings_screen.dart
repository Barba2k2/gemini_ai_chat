import 'package:flutter/material.dart';
import 'package:gamini_ai_chat/src/widgets/account_settings.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1B20),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      body: const AccountSettings(),
    );
  }
}
