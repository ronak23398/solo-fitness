// lib/app/data/services/supabase_config.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String _supabaseUrl = 'https://vzyubzmfxbfghiaqizfo.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ6eXViem1meGJmZ2hpYXFpemZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUzMTcyOTgsImV4cCI6MjA2MDg5MzI5OH0.RZsD8zd77jNfkWx4jJPnr8vp4PfoP3XbYfLsCqUECQc';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
      debug: true,
      authOptions: FlutterAuthClientOptions(
    authFlowType: AuthFlowType.implicit, 
    detectSessionInUri: false
  ) 
    );
  }

  // Singleton instance getter
  static SupabaseClient get client => Supabase.instance.client;

  // Get storage URL helper
  static String getPublicUrl(String bucketName, String filePath) {
    return '${_supabaseUrl}/storage/v1/object/public/$bucketName/$filePath';
  }
}