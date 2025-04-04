/*import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';


class BotPge extends StatefulWidget {
  const BotPage ({super.key});
  @override

  State<BotPage> createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {

  final Gemini gemini = Gemini.instance; // gemini instance

  List<ChatMessage> messages =[];

  ChatUser currentUser = ChatUser (id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1", 
    firstName: "gemini",
    profileImage: "https://www.flaticon.com/free-icon/chat-bot_13330989");



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Chat bot assistant",
          )
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    DashChat ( 
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed : _sendMediaMessage,
          icon: const  Icon(
            Icons.image
            ),
        )
      ]),
      currentUser: currentUser, 
      onSend: _sendMessage, 
      messages: messages);

  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try{
      String question = chatMessage.text;
      List<Uint8List>? images;

      if ( chatMessage.medias?.isNotEmpty?? false ) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];

      }
      gemini.streamGenerateContent(
        question, 
        images: images,
        )
        .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;

        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts
                 ?.fold("",(previous,current) => "$previous ${current.text}")
                 ?? "";

        lastMessage.text += response;
        setState(() {
          messages = [lastMessage!, ...messages];
        });


        } else {
          String response = event.content?.parts
                 ?.fold("",(previous,current) => "$previous ${current.text}")
                 ?? "";

          ChatMessage message = ChatMessage(
            user: geminiUser, 
            createdAt: DateTime.now(), 
            text: response,
            );
            setState(() {
              messages = [message, ...messages];
              
            });
        }
      });
    } catch (e) {
      print(e);
    }

  } 


  // sending images from the gallery 

  void _sendMediaMessage() async {
    ImagePicker picker =  ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery);

      if (file != null) {
        ChatMessage chatMessage = ChatMessage(user: currentUser, 
        createdAt: DateTime.now(),

        // gemini is asked to descrie a pic
        text: "Describe this picture.",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "", 
            type: MediaType.image,
            )
        ]
        );
        _sendMessage(chatMessage);
      }
  }

}
*/

import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class BotPage extends StatefulWidget {
  const BotPage({super.key});

  @override
  State<BotPage> createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {
  final Gemini gemini = Gemini.instance; // Gemini instance
  final List<ChatMessage> messages = []; // List to store chat messages

  final ChatUser currentUser =
      ChatUser(id: "0", firstName: "User"); // Current user
  final ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: "https://www.flaticon.com/free-icon/chat-bot_13330989",
  ); // Gemini bot user

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Chatbot Assistant",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple, // AppBar color
        elevation: 10, // Shadow for AppBar
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple, Colors.purpleAccent],
          ),
        ),
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      inputOptions: InputOptions(
        inputTextStyle:
            const TextStyle(color: Colors.white), // Input text style
        inputDecoration: InputDecoration(
          hintText: "Type a message...",
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.deepPurple.withOpacity(0.7),
        ),
        trailing: [
          IconButton(
            onPressed: () {
              // Send message when button is pressed
              _sendMessage(ChatMessage(
                user: currentUser,
                createdAt: DateTime.now(),
                text: _controller.text.trim(),
              ));
              _controller.clear(); // Clear input after sending
            },
            icon: const Icon(Icons.send, color: Colors.white),
          ),
          IconButton(
            onPressed: _sendMediaMessage, // Trigger send media message
            icon: const Icon(Icons.image, color: Colors.white),
          ),
        ],
        textController: _controller,
      ),
      messageListOptions: MessageListOptions(
        showDateSeparator: true, // Show date separator
      ),
      messageOptions: MessageOptions(
        currentUserContainerColor:
            Colors.deepPurpleAccent, // Color of current user message
        containerColor: Colors.white, // Color of other messages
        textColor: Colors.black, // Text color for other messages
        currentUserTextColor:
            Colors.white, // Text color for current user messages
        avatarBuilder: (user, onMessageTap, onMessageLongPress) {
          return CircleAvatar(
            backgroundImage: NetworkImage(user.profileImage ?? ""),
            backgroundColor: Colors.deepPurple,
          );
        },
        messageTextBuilder: (message, onMessageTap, onMessageLongPress) {
          return Text(
            message.text,
            style: TextStyle(
              color: message.user == currentUser ? Colors.white : Colors.black,
            ),
          );
        },
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages.insert(
          0, chatMessage); // Add user message to the top of the list
    });

    String question = chatMessage.text;
    List<Uint8List>? images;

    // Check if the message contains media (e.g., images)
    if (chatMessage.medias?.isNotEmpty ?? false) {
      images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
    }

    // Stream response from Gemini
    gemini.streamGenerateContent(question, images: images).listen(
      (event) {
        String response = event.content?.parts
                ?.fold("", (previous, current) => "$previous $current")
                ?.trim() ??
            "";

        // Check if the last message is from Gemini and update it
        ChatMessage? lastMessage =
            messages.isNotEmpty && messages.first.user == geminiUser
                ? messages.first
                : null;

        if (lastMessage != null) {
          lastMessage.text += response;
          setState(() {
            messages[0] = lastMessage; // Update the existing Gemini message
          });
        } else {
          // Create a new Gemini message
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages.insert(
                0, message); // Add Gemini response to the top of the list
          });
        }
      },
      onError: (error) {
        print("Error: $error");
        _showError("Failed to get a response from Gemini.");
      },
    );
  }

  // Send media message (image) from the gallery
  void _sendMediaMessage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture.", // Prompt for Gemini
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          ),
        ],
      );
      _sendMessage(chatMessage); // Send the media message
    }
  }

  // Show an error message to the user
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
