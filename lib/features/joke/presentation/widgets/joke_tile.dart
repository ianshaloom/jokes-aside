import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../domain/jokes_entity.dart';
import '../provider/joke_provider.dart';
import 'joke_dialog.dart';

class JokeTile extends StatelessWidget {
  final JokeEntity joke;
  const JokeTile({
    super.key,
    required this.joke,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    // final watcher = context.watch<JokeProvider>();
    final reader = context.read<JokeProvider>();

    return InkWell(
      onTap: () => _showJokeDialog(context, joke),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        // elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                joke.setup,
                // textAlign: TextAlign.center,
                style: textTheme.titleMedium!.copyWith(
                  // fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                joke.punchline,
                style: textTheme.bodyMedium!.copyWith(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: color.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 10),
              // buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.trash,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      reader.eitherFailureOrDeletedJoke(joke.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showJokeDialog(BuildContext context, JokeEntity joke) {
    showDialog(
      context: context,
      builder: (context) {
        return JokeDialog(joke: joke);
      },
    );
  }
}
