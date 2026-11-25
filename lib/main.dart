import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'view/LoginView.dart';

const String _supabaseUrl = String.fromEnvironment(
  'https://gsfrmnvfcwwkplwjwqat.supabase.co/rest/v1/',
);
const String _supabaseAnonKey = String.fromEnvironment(
  'sb_publishable_iyGMdVfO0ElUaAdE3o-09A_kogbus08',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseAnonKey);

  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fliperama_TI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF2A85),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}
