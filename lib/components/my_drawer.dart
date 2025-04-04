import 'package:first/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:first/pages/settings_page.dart'; // Import the SettingsPage
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Future<void> signOut(BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signOut();

      // Navigate to login screen after signing out
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print("Sign-out failed: $e");
      // Log to Firebase Crashlytics (if applicable)
      // FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error signing out. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message,
                        color: Theme.of(context).colorScheme.primary,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "My App",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushReplacementNamed(
                        context, '/home'); // Navigate to home
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text("S E T T I N G S"),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: const Text("L O G  O U T"),
              leading: const Icon(Icons.logout),
              onTap: () => signOut(context),
            ),
          ),
        ],
      ),
    );
  }
}
