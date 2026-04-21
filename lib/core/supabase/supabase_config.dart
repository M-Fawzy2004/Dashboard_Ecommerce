import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Senior Design Pattern: A dedicated configuration service for Supabase.
/// This centralizes the initialization logic and handles environment variable safety.
class SupabaseConfig {
  static Future<void> init() async {
    // 1. Ensure .env is loaded before accessing its variables
    await dotenv.load(fileName: ".env");

    // 2. Extract keys with validation to prevent runtime crashes
    final url = dotenv.get('SUPABASE_URL', fallback: '');
    final anonKey = dotenv.get('SUPABASE_ANON_KEY', fallback: '');

    if (url.isEmpty || anonKey.isEmpty) {
      throw Exception(
        'Supabase URL or Anon Key is missing in the .env file. '
        'Please check your project root .env file.',
      );
    }

    // 3. Initialize Supabase
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      // You can add additional configurations here like debug: true for development
      debug: false,
    );
  }

  /// Get the Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;
}
