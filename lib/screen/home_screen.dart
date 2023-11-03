// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:piano_tiles/provider/game_state.dart';
import 'package:piano_tiles/provider/mission_provider.dart';

import '../model/node_model.dart';
import 'widgets/line.dart';
import 'widgets/line_divider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Note> notes = mission();
  AudioCache player = AudioCache();
  late AnimationController animationController;
  int currentNoteIndex = 0;
  int points = 0;
  bool hasStarted = false;
  bool isPlaying = true;
  late NoteState state;
  int time = 5000;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 0));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isPlaying) {
        if (notes[currentNoteIndex].state != NoteState.tapped) {
          //game over
          setState(() {
            isPlaying = false;
            notes[currentNoteIndex].state = NoteState.missed;
          });
          animationController.reverse().then((_) => _showFinishDialog());
        } else if (currentNoteIndex == notes.length - 5) {
          //song finished
          _showFinishDialog();
        } else {
          setState(() => ++currentNoteIndex);
          animationController.forward(from: 0);
        }
      }
    });
    animationController.forward(from: -1);
  }

  void _onTap(Note note) {
    bool areAllPreviousTapped = notes
        .sublist(0, note.orderNumber)
        .every((n) => n.state == NoteState.tapped);

    if (areAllPreviousTapped) {
      if (!hasStarted) {
        setState(() => hasStarted = true);
        animationController.forward();
      }
      _playNote(note);
      setState(() {
        note.state = NoteState.tapped;
        ++points;
        if (points == 10) {
          animationController.duration = const Duration(milliseconds: 700);
        } else if (points == 15) {
          animationController.duration = const Duration(milliseconds: 500);
        } else if (points == 30) {
          animationController.duration = const Duration(milliseconds: 400);
        }
      });
    }
  }

  _drawPoints() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Text(
          "$points",
          style: const TextStyle(color: Colors.red, fontSize: 60),
        ),
      ),
    );
  }

  _drawLine(int lineNumber) {
    return Expanded(
      child: Line(
        lineNumber: lineNumber,
        currentNotes: notes.sublist(currentNoteIndex, currentNoteIndex + 5),
        animation: animationController,
        onTileTap: _onTap,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  void _restart() {
    setState(() {
      hasStarted = false;
      isPlaying = true;
      notes = mission();
      points = 0;
      currentNoteIndex = 0;
      animationController.duration = const Duration(milliseconds: 1000);
    });
    animationController.reset();
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(150)),
                  ),
                  child: const Icon(Icons.play_arrow, size: 50),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(150)),
                  ),
                  child: Text(
                    "Score: $points",
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _startWidget(),
              ],
            ),
          ),
        );
      },
    ).then((_) => _restart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "assets/background.gif",
                fit: BoxFit.cover,
              )),
          Row(
            children: <Widget>[
              _drawLine(0),
              const LineDivider(),
              _drawLine(1),
              const LineDivider(),
              _drawLine(2),
              const LineDivider(),
              _drawLine(3)
            ],
          ),
          _drawPoints(),
          _drawCompleteTile()
        ],
      ),
    );
  }

// Define the note mappings as a constant map
  Map<int, String> noteSounds = {
    0: 'a.wav',
    1: 'c.wav',
    2: 'e.wav',
    3: 'f.wav',
  };

  void _playNote(Note note) {
    String? soundFile = noteSounds[note.line];
    if (soundFile != null) {
    } else {
      debugPrint('No sound associated with line number ${note.line}');
    }
  }

  Widget _drawCompleteTile() {
    // Function to decide color based on points
    Color _getColorForPoints(int threshold) {
      return points >= threshold ? Colors.deepOrange : Colors.green;
    }

    // Widget builder for the tile widget with icon and color
    Widget buildTileWidget(int threshold) {
      return tileWidget(
        Icons.star,
        Color: _getColorForPoints(threshold),
      );
    }

    // Widget builder for the horizontal line with color
    Widget _buildTileHorizontalLine(int threshold) {
      return _tileHorizontalLine(
        _getColorForPoints(threshold),
      );
    }

    return Positioned(
      top: 25,
      right: 50,
      left: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTileWidget(10),
          _buildTileHorizontalLine(10),
          buildTileWidget(30),
          _buildTileHorizontalLine(40),
          buildTileWidget(41),
        ],
      ),
    );
  }

  tileWidget(IconData icon, {Color}) {
    return Icon(
      icon,
      color: Color.fromARGB(66, 128, 35, 35),
    );
  }

  _tileHorizontalLine(Color color) {
    return Container(
      width: 80,
      height: 4,
      color: color,
    );
  }

  Widget _startWidget() {
    if (points >= 10 && points < 20) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
          Icon(
            Icons.star,
            color: Colors.green[200],
          ),
          Icon(
            Icons.star,
            color: Colors.green[200],
          ),
        ],
      );
    } else if (points >= 20 && points < 40)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
          const Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
          Icon(
            Icons.star,
            color: Colors.green[200],
          ),
        ],
      );
    else if (points >= 41)
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
          Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
          Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
        ],
      );
    else
      return Container();
  }
}
