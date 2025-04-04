import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/pages/home_page.dart';
import 'package:first/pages/interest_page.dart';
import 'package:first/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';

/*
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const InterestsPage();
            } else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}
*/

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<bool> hasUserSelectedInterests(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return userDoc.exists && userDoc.data()?['hasSelectedInterests'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return FutureBuilder(
              future: hasUserSelectedInterests(user.uid),
              builder: (context, AsyncSnapshot<bool> interestSnapshot) {
                if (interestSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (interestSnapshot.hasData) {
                  if (interestSnapshot.data!) {
                    return const HomePage();
                  } else {
                    return const InterestsPage();
                  }
                } else {
                  return const Center(child: Text('Error checking interests'));
                }
              },
            );
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
