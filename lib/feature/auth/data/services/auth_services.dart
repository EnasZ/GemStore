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
      // 1. IMPORTANT: Use the WEB CLIENT ID from Google Cloud Console.
      // Even on Android, Supabase requires the Web Client ID to verify the OIDC token.
      const String webClientId =
          '804208280114-rb2bl63v0u3go1qroj19hos40i5mfrkg.apps.googleusercontent.com';

      // 2. Initialize GoogleSignIn with the correct Client ID.
      // We use 'clientId' and 'serverClientId' to ensure compatibility across all platforms.
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: webClientId,
        serverClientId: webClientId,
      );

      // 3. Trigger the native Google Account Picker.
      // This opens the UI where the user selects their Google account.
      final googleUser = await googleSignIn.signIn();

      // If the user cancels or closes the picker, we exit silently.
      if (googleUser == null) return;

      // 4. Retrieve the Authentication tokens (ID Token and Access Token).
      final googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      // Safety check: idToken is mandatory for Supabase to authenticate the user.
      if (idToken == null) {
        throw Exception("No ID Token found. Google Authentication failed.");
      }

      // 5. Sign in to Supabase using the retrieved tokens.
      // Supabase will automatically create a new user or log in an existing one.
      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken, // Providing the accessToken is recommended
      );
    } catch (e) {
      // 6. Catch any errors (like ApiException 10) and re-throw them for the UI/Cubit.
      throw Exception("Google Sign-In Error: $e");
    }
  }

  /// Sends a password reset email to the user using Supabase
  Future<void> resetPassword({required String email}) async {
    // Supabase sends a reset link to the provided email address
    await supabase.auth.resetPasswordForEmail(email);
  }

  /// Verifies the OTP (One-Time Password) sent to the user's email.
  /// [email]: The user's email address.
  /// [token]: The 4 or 6 digit code entered by the user.
  Future<void> verifyOTP({required String email, required String token}) async {
    try {
      // We use 'recovery' as the type because this is for a forgotten password flow.
      // If it were for email confirmation during signup, the type would be 'signup'.
      await supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );
    } catch (e) {
      // Throwing an exception to be caught by the Cubit layer
      throw Exception("Invalid or expired verification code.");
    }
  }

  /// Updates the user's password in Supabase
  Future<void> updatePassword({required String newPassword}) async {
    try {
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw Exception("Failed to update password: $e");
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
