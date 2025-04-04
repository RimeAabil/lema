import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBotPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ChatMessage> messages = []; // List to store chat messages
  bool _isLoading = true; // Flag to track loading state

  late ChatUser currentUser; // Current user
  late ChatUser geminiUser; // Chatbot user

  @override
  void initState() {
    super.initState();
    _initializeUsers();
    _loadMessages();
  }

  // Initialize users
  void _initializeUsers() {
    currentUser = ChatUser(
      id: _auth.currentUser!.uid,
      firstName: _auth.currentUser!.email!.split('@')[0],
    );

    geminiUser = ChatUser(
      id: "chatbot", // Fixed ID for the chatbot
      firstName: "ChatBot",
      profileImage:
          "assets/chatbot.jpg", // Use an asset from the `assets` folder
    );
  }

  // Load messages from Firestore
  Future<void> _loadMessages() async {
    try {
      final querySnapshot = await _firestore
          .collection('chatbot_messages')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .orderBy('timestamp', descending: false)
          .get();

      setState(() {
        messages = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return ChatMessage(
            user: data['senderId'] == currentUser.id ? currentUser : geminiUser,
            text: data['text'],
            createdAt: data['timestamp'].toDate(),
          );
        }).toList();
        _isLoading = false; // Stop loading
      });

      // Add a welcome message if no messages exist
      if (messages.isEmpty) {
        _addWelcomeMessage();
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading even if there's an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load messages: $e')),
      );
    }
  }

  // Add a welcome message from the chatbot
  void _addWelcomeMessage() {
    final ChatMessage welcomeMessage = ChatMessage(
      user: geminiUser,
      text: "Hi! I'm your ChatBot Assistant. How can I help you today?",
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.add(welcomeMessage);
    });
  }

  // Handle sending a message
  Future<void> _sendMessage(ChatMessage chatMessage) async {
    try {
      // Add the user's message to Firestore
      await _firestore.collection('chatbot_messages').add({
        'userId': _auth.currentUser!.uid,
        'senderId': chatMessage.user.id,
        'receiverId': geminiUser.id,
        'text': chatMessage.text,
        'timestamp': DateTime.now(),
        'isChatbot': false,
      });

      setState(() {
        messages.add(chatMessage);
      });

      // Simulate a response from the chatbot
      final ChatMessage botMessage = ChatMessage(
        user: geminiUser,
        text: _generateBotResponse(chatMessage.text),
        createdAt: DateTime.now(),
      );

      await _firestore.collection('chatbot_messages').add({
        'userId': _auth.currentUser!.uid,
        'senderId': geminiUser.id,
        'receiverId': currentUser.id,
        'text': botMessage.text,
        'timestamp': DateTime.now(),
        'isChatbot': true,
      });

      setState(() {
        messages.add(botMessage);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  // Generate a response from the chatbot
  String _generateBotResponse(String userMessage) {
    // For now, return a generic response
    return "Thank you for your message! I'm here to help. How can I assist you further?";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot Assistant'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : DashChat(
              currentUser: currentUser,
              onSend: _sendMessage,
              messages: messages,
              messageOptions: MessageOptions(
                currentUserContainerColor: Colors.blue[400]!,
                containerColor: Colors.grey[300]!,
                textColor: Colors.black,
                currentUserTextColor: Colors.white,
                showOtherUsersAvatar: true,
                showCurrentUserAvatar: false,
                timeFormat: DateFormat('hh:mm a'),
              ),
              inputOptions: InputOptions(
                inputTextStyle: const TextStyle(color: Colors.black),
                inputDecoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                ),
                sendButtonBuilder: (onSend) {
                  return IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.blue[400],
                    onPressed: onSend,
                  );
                },
              ),
            ),
    );
  }
}
