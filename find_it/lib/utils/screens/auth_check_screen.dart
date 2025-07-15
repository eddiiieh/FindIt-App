import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signup_login_screen.dart';
import 'find_it_home_screen.dart';

class AuthCheckScreen extends StatefulWidget {
 const AuthCheckScreen({super.key});

 @override
 State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
 final _supabase = Supabase.instance.client;
 bool _initialAuthCheckComplete = false;
 bool _isSyncingAuth = false; // Flag to prevent multiple concurrent sync attempts

 @override
 void initState() {
  super.initState();
  // Perform initial authentication state check and sync when the widget first loads
  _initializeAuth();
 }

 Future<void> _initializeAuth() async {
  debugPrint('Starting initial auth check...');
  // First check if there's an existing active Supabase session
  final currentSession = _supabase.auth.currentSession;

  if (currentSession != null) {
   debugPrint('Initial check: Supabase session found.');
   // If a Supabase session exists, we assume the user is logged in.
   // No need to sync from Firebase in this case as Supabase is primary source here.
  } else {
   debugPrint('Initial check: No Supabase session.');
   // If no Supabase session, check if a Firebase user is signed in
   final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
   if (firebaseUser != null) {
    debugPrint('Initial check: Firebase user found, attempting to sync with Supabase...');
    // Attempt to sign into Supabase using the Firebase user's ID token
    // AWAIT this operation to ensure it completes before marking check as complete
    await _syncAuth(firebaseUser);
    debugPrint('Initial check: Supabase sync attempt finished.');
   } else {
    debugPrint('Initial check: No Firebase user.');
   }
  }

  // Mark the initial check as complete after checking both Supabase session
  // or attempting to sync from Firebase.
  // We use setState to trigger a rebuild and show the StreamBuilder.
  if (mounted) {
   setState(() => _initialAuthCheckComplete = true);
   debugPrint('Initial auth check complete. Building StreamBuilder.');
  }
 }

 // Attempts to sign in to Supabase using a Firebase ID token
 Future<void> _syncAuth(firebase_auth.User firebaseUser) async {
  // Prevent multiple sync attempts running concurrently
  if (_isSyncingAuth) return;
  if (mounted) {
   setState(() => _isSyncingAuth = true);
  }

  try {
   final token = await firebaseUser.getIdToken();
   if (token == null) throw Exception('No ID token available from Firebase user.');

   // Use the ID token to sign in to Supabase
   // accessToken parameter is usually not needed for signInWithIdToken
   final res = await _supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google, // Specify the OAuth provider
    idToken: token,
   );

   if (res.session != null) {
    debugPrint('✅ Supabase sync successful via ID token.');
    if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
   } else {
    debugPrint('⚠️ Supabase sync via ID token resulted in no session.');
    // If sync doesn't result in a session, maybe sign out of Firebase too?
    // Depending on your logic, you might decide the user isn't fully authenticated.
    // await firebase_auth.FirebaseAuth.instance.signOut();
   }

  } catch (e) {
   debugPrint('🚨 Auth sync error: $e');
   // If sync fails, sign out of both to ensure a clean state
   await firebase_auth.FirebaseAuth.instance.signOut();
   await _supabase.auth.signOut();
  } finally {
   if (mounted) {
    setState(() => _isSyncingAuth = false);
   }
  }
 }

 @override
 Widget build(BuildContext context) {
  // Show a loading indicator until the initial auth check in initState is complete
  if (!_initialAuthCheckComplete) {
   debugPrint('Building: Initial check not complete, showing loading...');
   return const Scaffold(
    body: Center(child: CircularProgressIndicator()),
   );
  }

  // Once the initial check is complete, use StreamBuilder to listen for
  // ongoing Firebase authentication state changes and rebuild accordingly.
  debugPrint('Building: Initial check complete, building StreamBuilder...');
  return StreamBuilder<firebase_auth.User?>(
   stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
   builder: (context, snapshot) {
    // Show a loading indicator while the stream is determining the auth state
    if (snapshot.connectionState == ConnectionState.waiting) {
     debugPrint('StreamBuilder: Connection state waiting...');
     return const Center(child: CircularProgressIndicator());
    }

    // If the stream has data, it means a Firebase user is signed in
    if (snapshot.hasData && snapshot.data != null) {
     debugPrint('StreamBuilder: User is signed in (Firebase user detected). Showing Home.');
     // User is signed in, navigate to the home screen
     // We use the builder to return the target widget directly,
     // which is the standard way with StreamBuilder at the root.
     return const FindItHomeScreen();
    }

    // If the stream does not have data, it means no Firebase user is signed in
    debugPrint('StreamBuilder: User is signed out (No Firebase user). Showing Login.');
    // User is signed out, navigate to the sign-up/login screen
    return const SignUpLogInScreen();
   },
  );
 }
}