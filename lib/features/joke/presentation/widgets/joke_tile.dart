import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/jokes_entity.dart';

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

    return Card(
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
                // fontSize: 15,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: color.tertiary,
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
                    // context.read<JokeProvider>().deleteJoke(joke);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.share,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    // context.read<JokeProvider>().shareJoke(joke);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
