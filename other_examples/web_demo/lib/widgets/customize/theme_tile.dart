import 'package:flutter/material.dart';
import 'package:web_demo/main.dart';

class ThemeTile extends StatelessWidget {
  const ThemeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Modo'),
      trailing: IconButton.filledTonal(
        onPressed: () => MyApp.of(context)!.toggleTheme(),
        //? duda jose: el icono realmente no cambia, wtf
        //todo k: fix this
        icon: Icon(
          MyApp.of(context)!.themeMode == ThemeMode.dark
              ? Icons.brightness_7_rounded
              : Icons.brightness_7_rounded,
        ),
      ),
    );
  }
}
