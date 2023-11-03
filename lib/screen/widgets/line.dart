import 'package:flutter/material.dart';
import 'package:piano_tiles/model/node_model.dart';
import 'package:piano_tiles/screen/widgets/tile_widget.dart';

class Line extends AnimatedWidget {
  final int lineNumber;
  final List<Note> currentNotes;
  final Function(Note) onTileTap;
  const Line({ Key? key, required this.lineNumber, required this.currentNotes,required Animation<double> animation,required this.onTileTap}) : super(key: key,listenable : animation);

  @override
  Widget build(BuildContext context) {
    Listenable animation = super.listenable;

    //get heights
    double height = MediaQuery.of(context).size.height;
    double tileHeight = height / 4;

    //get only notes for that line
    List<Note> thisLineNotes =
    currentNotes.where((note) => note.line == lineNumber).toList();

    //map notes to widgets
    List<Widget> tiles = thisLineNotes.map((note) {
      //specify note distance from top
      int index = currentNotes.indexOf(note);
      double offset = (3 - index + animation.hashCode) * tileHeight;

      return Transform.translate(
        offset: Offset(0, offset),
        child: Tile(
          height: tileHeight,
          state: note.state,
          onTapDown: () => onTileTap(note),
          index: note.orderNumber,
        ),
      );
    }).toList();

    return SizedBox.expand(
      child: Stack(
        children: tiles,
      ),
    );
  }
}