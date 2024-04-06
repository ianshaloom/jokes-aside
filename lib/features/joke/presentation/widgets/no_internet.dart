import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(15),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: color.tertiaryContainer,
        contentPadding: const EdgeInsets.all(10),
        leading: Icon(
          CupertinoIcons.wifi_slash,
          color: color.error,
        ),
        title: Text(
          'Check your Wi-Fi or Data connection settings, Make sure you are connected',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w300,
                color: color.onTertiaryContainer,
              ),
        ),
      ),
    );
  }
}
