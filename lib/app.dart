import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'features/joke/presentation/provider/joke_provider.dart';
import 'features/joke/presentation/views/homepage.dart';
import 'theme/color_schemes.dart';

class JokeAside extends StatelessWidget {
  const JokeAside({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<JokeProvider>(create: (_) => JokeProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: 'SF-Pro-Display',
            useMaterial3: true,
            colorScheme: lightColorScheme),
        darkTheme: ThemeData(
            fontFamily: 'SF-Pro-Display',
            useMaterial3: true,
            colorScheme: darkColorScheme),
        debugShowCheckedModeBanner: false,
        home: const Homepage(),
      ),
    );
  }
}
