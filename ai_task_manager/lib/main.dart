import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app/theme/app_theme.dart';
import 'app/screens/main_shell.dart';
import 'app/screens/login_screen.dart';
import 'app/providers/task_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const AITaskManagerApp());
}

class AITaskManagerApp extends StatefulWidget {
  const AITaskManagerApp({super.key});

  @override
  State<AITaskManagerApp> createState() => _AITaskManagerAppState();
}

class _AITaskManagerAppState extends State<AITaskManagerApp> {
  bool _isLoggedIn = false;

  void _onLogin() {
    setState(() => _isLoggedIn = true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        title: 'AI Task Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: _isLoggedIn ? const MainShell() : LoginScreen(onLogin: _onLogin),
      ),
    );
  }
}
