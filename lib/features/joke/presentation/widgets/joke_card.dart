import 'package:flutter/material.dart';

class JokeCard extends StatelessWidget {
  final String joke;
  final String punchline;
  const JokeCard({super.key, required this.joke, required this.punchline});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              joke,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium!.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  punchline,
                  style: textTheme.bodyMedium!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
