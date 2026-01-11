import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  // Initialize Supabase client instance
  final supabase = Supabase.instance.client;

  // --- Email and Password Authentication ---

  /// Registers a new user with email, password, and additional metadata (userName)
  Future<void> signUp({
    required String email,
    required String password,
    required String userName,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        "userName": userName,
      }, // Stores the username in public.users or metadata
    );

    // Check if the user creation was successful
    if (response.user == null) {
      throw Exception("Sign up failed: User object is null.");
    }
  }

  /// Authenticates an existing user using their email and password
  Future<void> login({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(password: password, email: email);
  }

  // --- Google OAuth Authentication ---

  /// Handles the complete Google Sign-In flow and links it to Supabase
  Future<void> signInWithGoogle() async {
    try {
      // 1. Configure Google Sign-In with the Web Client ID from Google Cloud Console.
      // This ID is required by Supabase to verify the authenticity of the idToken.
      const webClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );

      // 2. Open the native Google account picker dialog.
      final googleUser = await googleSignIn.signIn();

      // If the user closes the popup without selecting an account, exit the function.
      if (googleUser == null) return;

      // 3. Retrieve authentication tokens (AccessToken and ID Token) from the Google account.
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      // Ensure both tokens exist before attempting to sign in to Supabase.
      if (idToken == null || accessToken == null) {
        throw Exception("Google Access or ID Token not found.");
      }

      // 4. Send the tokens to Supabase.
      // Supabase will verify the tokens and create/log in the user automatically.
      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      // Re-throw the error to be handled by the Cubit/UI layer.
      throw Exception("Google Sign-In failed: $e");
    }
  }

  // --- Sign Out ---

  /// Clears the session from both Supabase and the local Google Sign-In client
  Future<void> logOut() async {
    // Ends the Supabase session
    await supabase.auth.signOut();

    // Disconnects the Google account to allow switching accounts next time
    await GoogleSignIn().signOut();
  }
}
