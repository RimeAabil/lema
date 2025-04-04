import 'package:first/pages/home_page.dart';
import 'package:first/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({Key? key}) : super(key: key);

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSaving = false;

  final List<Map<String, dynamic>> interests = [
    {"name": "Technology", "icon": Icons.computer, "isSelected": false},
    {"name": "Sports", "icon": Icons.sports_basketball, "isSelected": false},
    {"name": "Music", "icon": Icons.music_note, "isSelected": false},
    {"name": "Travel", "icon": Icons.flight, "isSelected": false},
    {"name": "Food", "icon": Icons.restaurant, "isSelected": false},
    {"name": "Art", "icon": Icons.palette, "isSelected": false},
    {"name": "Gaming", "icon": Icons.games, "isSelected": false},
    {"name": "Movies", "icon": Icons.movie, "isSelected": false},
    {"name": "Books", "icon": Icons.book, "isSelected": false},
    {"name": "Fitness", "icon": Icons.fitness_center, "isSelected": false},
    {"name": "Photography", "icon": Icons.camera_alt, "isSelected": false},
    {"name": "Nature", "icon": Icons.nature, "isSelected": false},
  ];

  int selectedCount = 0;

  Future<void> saveInterestsToFirebase() async {
    if (_auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final selectedInterests = interests
          .where((interest) => interest['isSelected'])
          .map((interest) => interest['name'])
          .toList();

      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'interests': selectedInterests,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Interests saved successfully!')),
        );
        // Navigate to next screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving interests: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Interests'),
        elevation: 0,
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'What are you interested in?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select at least 3 interests to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: interests.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      interests[index]['isSelected'] =
                          !interests[index]['isSelected'];
                      selectedCount += interests[index]['isSelected'] ? 1 : -1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: interests[index]['isSelected']
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          interests[index]['icon'],
                          size: 32,
                          color: interests[index]['isSelected']
                              ? Colors.white
                              : Colors.black,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          interests[index]['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: interests[index]['isSelected']
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: selectedCount >= 3 && !_isSaving
                ? saveInterestsToFirebase
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}
