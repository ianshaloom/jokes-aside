import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/joke_provider.dart';
import '../widgets/joke_tile.dart';

class JokesPage extends StatelessWidget {
  const JokesPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<JokeProvider>().getAllLocalJoke();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Jokes List',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Consumer<JokeProvider>(builder: (context, value, child) {
          final jokes = value.jokeEntityList;

          if (jokes != null) {
            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return JokeTile(joke: jokes[index]);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
