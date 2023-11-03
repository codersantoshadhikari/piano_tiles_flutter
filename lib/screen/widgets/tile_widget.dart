import 'package:flutter/material.dart';
import 'package:piano_tiles/provider/game_state.dart';

class Tile extends StatelessWidget {
  final NoteState state;
  final double height;
  final VoidCallback onTapDown;
  final int index;

  const Tile({  Key? key, required this.state, required this.height, required this.onTapDown, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(index);
    return SizedBox(
      width: double.infinity,
      height: height,
      child: GestureDetector(
          onTapDown: (_) {
            onTapDown();
            debugPrint("button pressed");
          },
          child: Container(
            color: color,
            child: index == 0
                ? SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      'assets/tip.gif',
                      color: Colors.blue,
                      width: 50,
                      height: 50,
                    ))
                : const Text(""),
          )),
    );
  }

  Color get color {
    switch (state) {
      case NoteState.ready:
        return Colors.black;
      case NoteState.missed:
        return Colors.red;
      case NoteState.tapped:
        return Colors.blue.withOpacity(.2);
      default:
        return Colors.black;
    }
  }
}
