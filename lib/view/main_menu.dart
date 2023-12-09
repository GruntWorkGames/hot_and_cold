import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hot_and_cold/constants.dart';

class MainMenu extends ConsumerWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = Theme.of(context).textTheme.headlineLarge;
    final title = Text('Hot n\' Cold', style: titleStyle);
    final playStyle = Theme.of(context).textTheme.headlineMedium;
    final playTxt = Text('Play', style: playStyle);
    final playBtn = ElevatedButton(onPressed: () => false, child: playTxt);
    final col = Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
      children: [title, playBtn]);
    final content = Center(child: col);
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: content,
    );
  }
}