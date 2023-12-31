import 'package:flutter/material.dart';
import 'package:hot_and_cold/constants.dart';
import 'package:hot_and_cold/view/game_view.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headlineLarge;
    final title = Text('Hot n\' Cold', style: titleStyle);
    final playStyle = Theme.of(context).textTheme.headlineMedium!.copyWith(color: Constants.color2);
    final playTxt = Padding(padding:const EdgeInsets.fromLTRB(15, 5, 15, 5), 
      child:Text('Play', style: playStyle));
    final playBtn = ElevatedButton(onPressed: () => _loadGame(context), child: playTxt);
    final col = Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
      children: [title, playBtn]);
    final content = Center(child: col);
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: content,
    );
  }

  void _loadGame(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const GameView()));
  }
}