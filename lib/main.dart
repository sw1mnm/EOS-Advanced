import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart'
    as kakao_sdk; // Kakao SDK에 접두어 추가

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as firebase_auth; // Firebase SDK에 접두어 추가
import 'package:te/firebase_options.dart';
import 'package:te/screens/home_screen.dart';
import 'package:te/screens/login_screen.dart';
import 'package:te/service/auth_service.dart';
import 'package:te/theme/foundation/app_theme.dart';
import 'package:te/theme/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 카카오 SDK 초기화
  try {
    kakao_sdk.KakaoSdk.init(nativeAppKey: 'd88b38cdde20d0817110cd5f767e6d97');
    print('카카오 SDK 초기화 성공');
  } catch (e) {
    print('카카오 SDK 초기화 오류: $e');
  }

  // Firebase 초기화
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase 초기화 성공');
  } catch (e) {
    print('Firebase 초기화 오류: $e');
  }

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthService())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = LightTheme();

    return MaterialApp(
      title: 'EOS Advance Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: theme.color.primary),
        useMaterial3: true,
        fontFamily: 'Pretendard',
      ),
      home: StreamBuilder<firebase_auth.User?>(
        stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
