import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String sourceProfileImageUrl;

  const ConversationScreen({Key? key, required this.userId, required this.userName, required this.sourceProfileImageUrl}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final supabaseClient = Supabase.instance.client;
  late final String currentUserId;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    print("ConversationScreen initState called");
    print("Supabase instance client: ${Supabase.instance.client}");
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        print("Error: No user logged in when opening ConversationScreen!");
        // Handle the case where there's no logged-in user, perhaps navigate back
        return;
      }
      currentUserId = user.id;
      print("Current User ID: $currentUserId");
      _setupMessageSubscription();
    } catch (e) {
      print("Error in initState: $e");
    }
  }

  void _setupMessageSubscription() {
  final client = Supabase.instance.client;

  client
      .from('messages')
      .stream(primaryKey: ['id'])
      .order('created_at')
      .listen((List<Map<String, dynamic>> newMessages) {
    final filteredMessages = newMessages.where((msg) =>
        (msg['sender_id'] == currentUserId && msg['receiver_id'] == widget.userId) ||
        (msg['sender_id'] == widget.userId && msg['receiver_id'] == currentUserId)
    ).toList();

    if (filteredMessages.isNotEmpty) {
      setState(() {
        // If it's the initial data, replace the existing list
        if (messages.isEmpty && newMessages.isNotEmpty) {
          messages = filteredMessages;
        } else {
          // Otherwise, add the new messages
          messages.addAll(filteredMessages);
        }
      });
      _scrollToBottom();
    }
  });
}

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
  
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      _messageController.clear();
      try {
        await supabaseClient.from('messages').insert({
          'sender_id': currentUserId,
          'receiver_id': widget.userId,
          'message': messageText,
        });
        // Messages will be fetched in real-time in the next step
        // _fetchMessages(); // No need to manually fetch here if using Realtime
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display the profile image
          CircleAvatar(
            radius: 18, // Adjust size as needed
            backgroundColor: Colors.grey[300], // Background if no image
            backgroundImage: widget.sourceProfileImageUrl.isNotEmpty
                ? NetworkImage(widget.sourceProfileImageUrl) // Load image from URL
                : null, // Set to null if no URL
            // Optional: Show an icon as a placeholder if the URL is empty
            child: widget.sourceProfileImageUrl.isEmpty
                ? const Icon(Icons.person, size: 18, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 5), // Add spacing between image and text
          // Display the user's name
          Text(widget.userName),
          ],),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['sender_id'] == currentUserId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(message['message'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}