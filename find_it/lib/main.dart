// main.dart
import 'dart:convert';

import 'package:find_it/utils/screens/account_settings_screen.dart';
import 'package:find_it/utils/screens/appearances_screen.dart';
import 'package:find_it/utils/screens/auth_check_screen.dart';
import 'package:find_it/utils/screens/categories_screen.dart';
import 'package:find_it/utils/screens/contact_support_screen.dart';
import 'package:find_it/utils/screens/conversation_screen.dart';
import 'package:find_it/utils/screens/help_screen.dart';
import 'package:find_it/utils/screens/message_screen.dart';
import 'package:find_it/utils/screens/notification_screen.dart';
import 'package:find_it/utils/screens/post_item_screen.dart';
import 'package:find_it/utils/screens/settings_screen.dart';
import 'package:find_it/utils/screens/signup_login_screen.dart';
import 'package:find_it/utils/screens/find_it_home_screen.dart';
import 'package:find_it/utils/theme_provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

// Add this global list to store notifications
final List<Map<String, dynamic>> notificationList = [];
// ignore: unused_element
final MethodChannel _nativeChannel = MethodChannel('com.example.find_it/notifications');

// Notification handler for background messages (must be top-level)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final newNotification = {
    'title': message.notification?.title ?? 'New Item',
    'body': message.notification?.body ?? '',
    'item_id': message.data['item_id'] ?? '',
    'timestamp': DateTime.now().toString(),
  };

  final savedNotifications = prefs.getStringList('notifications') ?? [];
  savedNotifications.add(jsonEncode(newNotification));
  await prefs.setStringList('notifications', savedNotifications);

  // Optionally trigger native notification if you still need it
  // await _nativeChannel.invokeMethod('showNotification', {
  //   'title': newNotification['title'],
  //   'body': newNotification['body'],
  //   'item_id': newNotification['item_id']
  // });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved notifications
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getStringList('notifications') ?? [];
  notificationList.addAll(
      (saved.map((e) => jsonDecode(e) as Map<String, dynamic>).toList().reversed
  ));

  // Initialize Firebase
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('your-public-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
  );

  // Set up FCM background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize FCM and get token
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken"); // Save this to your database if needed

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://zsyphyvkqmkxfjtdiezz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpzeXBoeXZrcW1reGZqdGRpZXp6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMwODM0MjEsImV4cCI6MjA1ODY1OTQyMX0.Fg3tpz_2O2l31fpYKCMFtJSKQserkQvrdDGuCdOdgGA',
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const FindItApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FindItApp extends StatelessWidget {
  const FindItApp({super.key});

  @override
  Widget build(BuildContext context) {

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigatorKey.currentState?.pushNamed(
        '/item_detail',
        arguments: {'item_id': message.data['item_id']},
      );
    });

    final themeProvider = Provider.of<ThemeProvider>(context);

    // Set up FCM foreground listeners when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupFCMListeners();
    });

    return MaterialApp(
      title: 'FindIt',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const AuthCheckScreen(),
      routes: {
        '/signup_screen': (context) => const SignUpLogInScreen(),
        '/home': (context) => const FindItHomeScreen(),
        '/post_item_screen': (context) => const PostItemScreen(),
        '/message_screen': (context) => const MessagesScreen(),
        '/categories_screen': (context) => const CategoriesScreen(),
        '/settings_screen': (context) => const SettingsScreen(),
        '/account_settings': (context) => const AccountSettingsScreen(),
        '/notifications_screen': (context) => const NotificationsScreen(),
        '/appearance_screen': (context) => const AppearanceScreen(),
        '/contacts_screen': (context) => const ContactSupportScreen(),
        '/help_screen': (context) => const HelpScreen(),
        '/conversation_screen': (context) => const ConversationScreen(userId: '', userName: '', sourceProfileImageUrl: '',),
      },
    );
  }

  void _setupFCMListeners() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        _showNotification(message.notification!);

        final prefs = await SharedPreferences.getInstance();
        final newNotification = {
          'title': message.notification?.title ?? 'New Item',
          'body': message.notification?.body ?? '',
          'item_id': message.data['item_id'] ?? '',
          'timestamp': DateTime.now().toString(),
        };

        final savedNotifications = prefs.getStringList('notifications') ?? [];
        savedNotifications.add(jsonEncode(newNotification));
        await prefs.setStringList('notifications', savedNotifications);
      }
    });

    // When user taps notification to open app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigatorKey.currentState?.pushNamed('/notifications_screen');
    });
  }

  void _showNotification(RemoteNotification notification) {
    // Use the navigatorKey's context
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notification.title ?? 'New notification'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              navigatorKey.currentState?.pushNamed('/notifications_screen');
            },
          ),
        ),
      );
    }
  }
}