/*import 'package:firebase_core/firebase_core.dart';
import 'package:first/consts.dart'; // Ensure GEMINI_API_KEY is defined here
import 'package:first/firebase_options.dart';
import 'package:first/services/auth/auth_gate.dart'; // Import AuthGate
import 'package:first/services/auth/auth_service.dart'; // Import AuthService
//import 'package:first/pages/home_page.dart'; // Import HomePage
import 'package:first/pages/login_page.dart'; // Import LoginPage
import 'package:first/pages/settings_page.dart'; // Import SettingsPage
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // Import Gemini
import 'package:provider/provider.dart'; // Import Provider

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase
    );

    Gemini.init(apiKey: GEMINI_API_KEY); // Initialize Gemini
    runApp(
      ChangeNotifierProvider(
        create: (context) => AuthService(), // Provide AuthService
        child: const MyApp(),
      ),
    );
  } catch (e) {
    runApp(ErrorScreen(
        error: e.toString())); // Show error screen if initialization fails
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      home: const AuthGate(), // Set AuthGate as the initial screen
      routes: {
        '/login': (context) => const LoginPage(), // Login route
        '/settings': (context) => const SettingsPage(), // Settings route
      },
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Firebase Init Error: $error',
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
*/

import 'package:firebase_core/firebase_core.dart';
import 'package:first/consts.dart'; // Ensure GEMINI_API_KEY is defined here
import 'package:first/firebase_options.dart';
import 'package:first/services/auth/auth_gate.dart'; // Import AuthGate
import 'package:first/services/auth/auth_service.dart'; // Import AuthService
import 'package:first/pages/login_page.dart'; // Import LoginPage
import 'package:first/pages/settings_page.dart'; // Import SettingsPage
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // Import Gemini
import 'package:provider/provider.dart'; // Import Provider

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase
    );

    Gemini.init(apiKey: GEMINI_API_KEY); // Initialize Gemini
    runApp(
      ChangeNotifierProvider(
        create: (context) => AuthService(), // Provide AuthService
        child: const MyApp(),
      ),
    );
  } catch (e) {
    runApp(ErrorScreen(
        error: e.toString())); // Show error screen if initialization fails
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      theme: ThemeData(
        // Define your custom theme
        extensions: <ThemeExtension<dynamic>>[
          MyCustomColors(
            selectedRowColor: const Color.fromARGB(
                255, 167, 130, 241), // Custom color for selected rows
          ),
        ],
      ),
      home: const AuthGate(), // Set AuthGate as the initial screen
      routes: {
        '/login': (context) => const LoginPage(), // Login route
        '/settings': (context) => const SettingsPage(), // Settings route
      },
    );
  }
}

// Define your custom ThemeExtension class
class MyCustomColors extends ThemeExtension<MyCustomColors> {
  final Color? selectedRowColor;

  MyCustomColors({required this.selectedRowColor});

  @override
  ThemeExtension<MyCustomColors> copyWith({Color? selectedRowColor}) {
    return MyCustomColors(
      selectedRowColor: selectedRowColor ?? this.selectedRowColor,
    );
  }

  @override
  ThemeExtension<MyCustomColors> lerp(
      ThemeExtension<MyCustomColors>? other, double t) {
    if (other is! MyCustomColors) {
      return this;
    }
    return MyCustomColors(
      selectedRowColor: Color.lerp(selectedRowColor, other.selectedRowColor, t),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Firebase Init Error: $error',
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
