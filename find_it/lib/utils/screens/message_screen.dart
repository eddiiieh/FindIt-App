// messages_screen.dart
import 'package:find_it/utils/screens/find_it_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'conversation_screen.dart'; 

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final supabaseClient = Supabase.instance.client;
  late final String currentUserId;
  List<Map<String, dynamic>> conversationUsers = [];

  @override
  void initState() {
    super.initState();
    currentUserId = supabaseClient.auth.currentUser!.id;
    _fetchConversationUsers();
  }

  Future<void> _fetchConversationUsers() async {
    try {
      // Fetch all messages where the current user is either sender or receiver
      final response = await supabaseClient
          .from('messages')
          .select('sender_id, receiver_id')
          .or('sender_id.eq.$currentUserId,receiver_id.eq.$currentUserId');

      final List<dynamic> messages = response as List<dynamic>;
      Set<String> otherUserIds = {};
      for (var message in messages) {
        final senderId = message['sender_id'] as String?;
        final receiverId = message['receiver_id'] as String?;

        if (senderId != null && senderId != currentUserId) {
          otherUserIds.add(senderId);
        }
        if (receiverId != null && receiverId != currentUserId) {
          otherUserIds.add(receiverId);
        }
      }

      if (otherUserIds.isNotEmpty) {
        final usersResponse = await supabaseClient
            .from('users')
            .select('id, name, profile_image_url')
            .filter('id', 'in', otherUserIds.toList());

        setState(() {
          conversationUsers = (usersResponse as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .toList();
          // Remove duplicates if any
          conversationUsers = conversationUsers.toSet().toList();
        });
      } else {
        setState(() {
          conversationUsers.clear();
        });
      }
    } catch (e) {
      print('Error fetching conversation users: $e');
    }
  }

  Future<void> _navigateToConversation(BuildContext context, String userId, String userName, String profileImageUrl) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(userId: userId, userName: userName, sourceProfileImageUrl: profileImageUrl),
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  
  return WillPopScope(
    onWillPop: () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FindItHomeScreen()),
      );
      return false;
    },
    child: Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header (Back Arrow + Title)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const FindItHomeScreen()),
                      );
                    },
                    child: Icon(Icons.arrow_back, size: 28, color: theme.iconTheme.color),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    'Messages',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),

            // Conversations List
            Expanded(
              child: ListView.builder(
                itemCount: conversationUsers.length,
                itemBuilder: (context, index) {
                  final user = conversationUsers[index];
                  final profileImageUrl = user['profile_image_url'] as String? ?? '';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: profileImageUrl.isNotEmpty ? NetworkImage(profileImageUrl) : null,
                      child: profileImageUrl.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    title: Text(
                      user['name'] ?? 'Unknown User',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    onTap: () => _navigateToConversation(
                      context,
                      user['id'],
                      user['name'],
                      profileImageUrl,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}