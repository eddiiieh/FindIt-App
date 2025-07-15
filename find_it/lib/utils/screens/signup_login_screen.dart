import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SignUpLogInScreen extends StatefulWidget {
 const SignUpLogInScreen({Key? key}) : super(key: key);

 @override
 _SignUpLogInScreenState createState() => _SignUpLogInScreenState();
}

class _SignUpLogInScreenState extends State<SignUpLogInScreen> {
 final FirebaseAuth _auth = FirebaseAuth.instance;
 final GoogleSignIn _googleSignIn = GoogleSignIn();
 final supabaseClient = supabase.Supabase.instance.client;

 Future<void> signInWithGoogle() async {
 try {
 final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
 if (googleUser == null) {
 debugPrint("Google sign-in canceled.");
 return;
   }

   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
   final AuthCredential credential = GoogleAuthProvider.credential(
 accessToken: googleAuth.accessToken,
 idToken: googleAuth.idToken,
   );

   // Sign in to Firebase
   final UserCredential userCredential = await _auth.signInWithCredential(credential);
   final User? user = userCredential.user;

   if (user != null) {
 debugPrint("✅ User signed in (Firebase): ${user.email}");

 // Authenticate Supabase with Firebase ID token
 final response = await supabaseClient.auth.signInWithIdToken(
  provider: supabase.OAuthProvider.google,
  idToken: googleAuth.idToken!,
 );

 if (response.session == null) {
  debugPrint("⚠️ Supabase session not active after sign-in with ID token.");
  // Handle the case where Supabase sign-in failed despite Firebase success
  // You might want to show an error message to the user
  // and potentially sign out of Firebase to keep states consistent.
  // await _auth.signOut();
 } else {
  debugPrint("✅ Supabase session is active.");

  // Insert/Update user data into Supabase 'users' table using upsert
  final supabaseUser = response.user;
  if (supabaseUser != null) {
   final userId = supabaseUser.id;
   final userEmail = user.email;
   final userName = user.displayName;
   final userProfileImageUrl = user.photoURL;

   debugPrint("⚠️ Firebase Display Name: $userName");
   debugPrint("⚠️ Firebase Photo URL: $userProfileImageUrl");

   // Note: Supabase upsert returns a list of rows that were inserted/updated on success
   // Check the documentation for the exact return type and error handling.
   // The `.data` or check for `error` should be used appropriately.
   final insertResponse = await supabaseClient.from('users').upsert(
    {
  'id': userId,
  'email': userEmail,
  'name': userName, // Assuming you have a 'name' column in your users table
  'profile_image_url': userProfileImageUrl, // Assuming you have this column
  'created_at': DateTime.now().toIso8601String(), // Optional
    },
    onConflict: 'id',
   );
   
   // Correct way to check for Supabase postgrest error after upsert
   if (insertResponse.error != null) {
    debugPrint('🚨 Error creating/updating user in users table (Supabase): ${insertResponse.error!.message}');
    // You can uncomment the next line to log the full response for debugging
    // debugPrint('🚨 Full Supabase Insert/Update Response (users): ${insertResponse.toJson()}');
    // Decide how to handle this error - does it prevent login?
   } else {
    debugPrint('✅ User created/updated successfully in users table (Supabase).');
    // Check if insertResponse.data is not null or empty if expecting rows back
    // if (insertResponse.data == null || (insertResponse.data as List).isEmpty) {
    //  debugPrint('⚠️ Supabase upsert succeeded but returned no data.');
    // }
   }
  } else {
   debugPrint("⚠️ Supabase user object is null after successful Supabase sign-in?");
   // This case should ideally not happen if response.session is not null, but good to check.
  }


  // Save user details to SharedPreferences
  // Make sure to handle the case where displayName or photoURL might be null from Google
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userName', user.displayName ?? 'Unknown User');
  prefs.setString('userProfileImageUrl', user.photoURL ?? ''); // Use empty string or a default URL

  // NAVIGATION: Navigate to home screen ONLY after successful Supabase session and data handling
  // With the AuthCheckScreen listening, this call might be redundant but acts as a direct result of the button press.
  // It's fine to keep ONE here after full success.
  if (mounted) {
   debugPrint("✅ Navigating to /home after successful Supabase session.");
   Navigator.pushReplacementNamed(context, '/home');
  }
 } // End of 'response.session != null' else block

 // REMOVED: The second navigation call that was previously here
   } else {
 debugPrint("⚠️ Authentication failed: Firebase User is null after signInWithCredential.");
 // Handle Firebase sign-in failure
   }
  } catch (e) {
   debugPrint("🚨 Error signing in with Google: $e");
   // Handle any exceptions during the sign-in process
   // Show an error message to the user
  }
 }

 @override
 Widget build(BuildContext context) {
  final theme = Theme.of(context);

  return Scaffold(
   backgroundColor: theme.colorScheme.background,
   body: SafeArea(
 child: SingleChildScrollView(
  padding: const EdgeInsets.symmetric(horizontal: 24),
  child: Column(
   crossAxisAlignment: CrossAxisAlignment.center,
   children: [
    const SizedBox(height: 90),
    Image.asset('assets/images/logo.png', width: 200, height: 200),
    Text(
  "Welcome to FindIt",
  style: GoogleFonts.poppins(
   fontSize: 26,
   fontWeight: FontWeight.w700,
   color: theme.colorScheme.onBackground,
  ),
    ),
    Text(
  "Sign up or log in to continue",
  style: GoogleFonts.poppins(
   fontSize: 16,
   color: theme.colorScheme.onBackground.withOpacity(0.7),
  ),
    ),
    const SizedBox(height: 30),
    OutlinedButton.icon(
  onPressed: signInWithGoogle,
  icon: const Icon(Icons.g_mobiledata, size: 24, color: Colors.red),
  label: Text(
   "Continue with Google",
   style: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: theme.colorScheme.onBackground,
   ),
  ),
  style: OutlinedButton.styleFrom(
   minimumSize: const Size(double.infinity, 50),
   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
    ),
    const SizedBox(height: 20),
   ],
  ),
 ),
   ),
  );
 }
}