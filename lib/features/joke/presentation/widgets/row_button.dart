import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../domain/jokes_entity.dart';
import '../provider/joke_provider.dart';

class RowButton extends StatefulWidget {
  final bool isBookmark;
  final String title;
  final Function()? onPressed;
  const RowButton({
    super.key,
    required this.title,
    this.onPressed,
    required this.isBookmark,
  });

  @override
  State<RowButton> createState() => _RowButtonState();
}

class _RowButtonState extends State<RowButton> {
  bool _isBookmark = false;
  JokeEntity? joke;

  void Function(JokeEntity joke)? saved;
  void Function(String id)? unsaved;

  _onPressed(bool isBookmark) async {
    if (isBookmark) {
      saveToBookmark();
    } else {
      share();
    }
  }

  void saveToBookmark() {
    debugPrint('saveToBookmark');

    if (_isBookmark) {
      unsaved!(joke!.id);
    } else {
      saved!(joke!);
    }
  }

  @override
  void initState() {
    super.initState();
    final reader = context.read<JokeProvider>();
    saved = (joke) {
      reader.eitherFailureOrSavedJoke(joke);
    };
    unsaved = (id) {
      reader.eitherFailureOrDeletedJoke(id);
    };

    joke = reader.jokeEntity;
    _isBookmark = reader.isBookmark;
  }

  @override
  Widget build(BuildContext context) {
    final reader = context.read<JokeProvider>();
    final watcher = context.watch<JokeProvider>();

    return Expanded(
      child: FilledButton(
        onPressed: () async {
          if (reader.jokeEntity == null) {
            debugPrint('joke is null');
            return;
          }

          joke = reader.jokeEntity!;
          _isBookmark = reader.isBookmark;
          await _onPressed(widget.isBookmark);
          _isBookmark = reader.isBookmark;
        },
        style: FilledButton.styleFrom(
          elevation: 0,
          enableFeedback: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Column(
          children: [
            Icon(
              widget.isBookmark
                  ? watcher.isBookmark
                      ? CupertinoIcons.bookmark_fill
                      : CupertinoIcons.bookmark
                  : Icons.share,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 5),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void share() {
    widget.onPressed!();
  }
  
 
}
