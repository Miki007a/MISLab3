import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/jokes_by_type_screen.dart';
import 'screens/random_joke_screen.dart';
import 'screens/favorite_jokes_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/jokes_by_type': (context) => JokesByTypeScreen(),
        '/random': (context) => RandomJokeScreen(),
        '/favorites': (context) => FavoriteJokesScreen(),
      },
    );
  }
}
