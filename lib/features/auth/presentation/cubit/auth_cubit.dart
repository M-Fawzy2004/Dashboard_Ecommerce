import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    // Artificial delay for premium feel
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock admin login
    if (email == 'admin@dealport.com' && password == 'admin123') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      emit(AuthAuthenticated());
    } else {
      emit(const AuthError('Invalid email or password. Please use admin credentials.'));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    emit(AuthUnauthenticated());
  }
}
