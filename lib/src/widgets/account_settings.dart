import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(),
          title: Text(
            'Barba Tech',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {},
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Account',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.email_outlined,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            'Email',
            style: GoogleFonts.roboto(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'email@email.com',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/privacy');
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.monetization_on_outlined,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            'Subscription',
            style: GoogleFonts.roboto(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'Gemini Pro Vision',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/terms');
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'App',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(
            FontAwesomeIcons.sun,
            color: Colors.white,
            size: 26,
          ),
          title: Text(
            'Color Scheme',
            style: GoogleFonts.roboto(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'System (Default)',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          onTap: () {},
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'About',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.insert_drive_file_outlined,
            color: Colors.white,
            size: 28,
          ),
          title: Text(
            'Terms of Use',
            style: GoogleFonts.roboto(
              color: Colors.white,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(
            Icons.shield_outlined,
            color: Colors.white,
            size: 28,
          ),
          title: Text(
            'Privacy Policy',
            style: GoogleFonts.roboto(
              color: Colors.white,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(
            Icons.archive_rounded,
            color: Colors.white,
            size: 28,
          ),
          title: Text(
            'Flutter Gemini',
            style: GoogleFonts.roboto(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            '1.0.0',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.logout_outlined,
            color: Colors.red.shade400,
            size: 30,
          ),
          title: Text(
            'Sing out',
            style: GoogleFonts.roboto(
              color: Colors.red.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
