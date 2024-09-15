import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class Header extends StatelessWidget {
  final User user;

  const Header({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
                user.photoURL != null ? NetworkImage(user.photoURL!) : null,
            child: user.photoURL == null ? const Icon(Icons.person, size: 30,) : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomText(
              text: user.displayName ?? 'Anonymous',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
