import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gemstore/core/cache/cache_user_repo.dart';
import 'package:gemstore/feature/auth/data/services/auth_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // Instance of the authentication service to interact with Supabase
  final AuthServices authServices = AuthServices();

  /// Handles user registration with email, password, and username
  Future<void> signUp({
    required String email,
    required String password,
    required String userName,
  }) async {
    emit(AuthLoading()); // Show loading indicator in UI
    try {
      await authServices.signUp(
        email: email,
        password: password,
        userName: userName,
      );
      // Mark user as logged in in local cache
      CacheUserRepo.login(true);
      emit(AuthSuccess()); // Notify UI of successful registration
    } catch (e) {
      // Notify UI of the error message
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handles traditional login using email and password
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading()); // Start loading state
    try {
      await authServices.login(email: email, password: password);
      // Persist login state locally
      CacheUserRepo.login(true);
      emit(AuthSuccess()); // Notify UI of successful login
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handles Social Login via Google
  Future<void> signInWithGoogle() async {
    emit(AuthLoading()); // Trigger loading state for Google popup
    try {
      await authServices.signInWithGoogle();
      // On success, save session locally and update UI
      CacheUserRepo.login(true);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Triggers the password reset process and emits states accordingly
  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await authServices.resetPassword(email: email);
      // Note: We emit Success, but in UI we will show a dialog or message instead of navigating
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Verifies the OTP code sent to the user's email
  Future<void> verifyCode({
    required String email,
    required String token,
  }) async {
    emit(AuthLoading());
    try {
      await authServices.verifyOTP(email: email, token: token);
      emit(
        AuthSuccess(),
      ); // This will trigger navigation to Reset Password screen
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Updates the user's password and emits states for the UI
  Future<void> createNewPassword({required String password}) async {
    emit(AuthLoading());
    try {
      await authServices.updatePassword(newPassword: password);
      emit(AuthSuccess()); // Password changed successfully
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handles logging out the user from both Supabase and local cache
  Future<void> logOut() async {
    emit(AuthLoading());
    try {
      await authServices.logOut();
      // Clear local authentication flag
      CacheUserRepo.logOut();
      emit(AuthInitial()); // Reset the state to initial (Login Screen)
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
