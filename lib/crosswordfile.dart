library crossword;

import 'dart:math';
import 'package:crossword/components/letter_offset.dart';
import 'package:crossword/helper/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:werkos/providers/game_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:crossword/components/word_line.dart';
import 'package:werkos/soundConstants.dart';
import 'package:werkos/widget/sahared_prefs.dart';
import 'line_painter.dart';
import 'linedecoration.dart';
import 'package:audioplayers/audioplayers.dart';

class Crossword extends StatefulWidget {
  final List<List<String>> letters;
  final bool? transposeMatrix;
  final LineDecoration? lineDecoration;
  final Offset spacing;
  final bool? drawCrossLine;
  final bool? drawHorizontalLine;
  final bool? drawVerticalLine;
  final Function(List<String> words) onLineDrawn;
  final List<String> allWords;
  final List<String> incorrWords;
  final List<String> correctWords;
  final TextStyle? textStyle;
  final bool? acceptReversedDirection;

  const Crossword({super.key,
    required this.letters,
    required this.spacing,
    this.drawCrossLine,
    required this.onLineDrawn,
    this.drawHorizontalLine,
    this.drawVerticalLine,
    required this.allWords,
    required this.incorrWords,
    required this.correctWords,
    this.lineDecoration = const LineDecoration(),
    this.textStyle,
    this.acceptReversedDirection = true,
    this.transposeMatrix = false})
      : assert(
  (drawCrossLine ?? true) ||
      (drawHorizontalLine ?? true) ||
      (drawVerticalLine ?? true),
  "At least one of drawCrossLine, drawHorizontalLine, or drawVerticalLine should be true",
  );

  @override
  CrosswordState createState() => CrosswordState();
}

class CrosswordState extends State<Crossword> {
  List<WordLine> lineList = [];
  List<Offset> selectedOffsets = [];
  Color? color;
  List<WordLine> wordsAreMarked = [];
  List<String> wordsMarked = [];
  List<WordLine> updatedLineList = [];
  LetterOffset? startPoint;
  LetterOffset? endPoint;
  List<List<String>> letters = [];
  bool isPlaying = false;
  List<String> incorrectMarked = [];
  var lastWord;

  bool isMarked = false;
  var soundPref_ = "on";

  @override
  void initState() {
    // TODO: implement initState
    letters =
    widget.transposeMatrix! ? widget.letters : widget.letters.transpose();

    Future.delayed(const Duration(milliseconds: 0), () async {
      var soundPref = await Prefs.getPrefs("sound");
      try {
        soundPref_ = soundPref!;
      } catch(e) {
        print(e);
      }
      setState(() {});
    });

    super.initState();
  }

  //check whether user interaction on the panel within the letter positions limit or outside the area
  bool isWithinLimit(LetterOffset offset) {
    return !(offset.getSmallerOffset.dx < 0 ||
        offset.getSmallerOffset.dx > letters.length - 1 ||
        offset.getSmallerOffset.dy < 0 ||
        offset.getSmallerOffset.dy > letters.first.length - 1);
  }

//check if the drawn line on a horizontal track
  bool isHorizontalLine(List<LetterOffset> offsets) {
    if (offsets.isEmpty) {
      return false;
    }

    double firstY = offsets.first.getSmallerOffset.dy;

    for (LetterOffset offset in offsets) {
      if (offset.getSmallerOffset.dy != firstY) {
        return false;
      }
    }

    return true;
  }

  //check if the drawn line on a vertical track
  bool isVerticalLine(List<LetterOffset> offsets) {
    if (offsets.isEmpty) {
      return false;
    }

    double firstX = offsets.first.getSmallerOffset.dx;

    for (LetterOffset offset in offsets) {
      if (offset.getSmallerOffset.dx != firstX) {
        return false;
      }
    }

    return true;
  }

//check if the drawn line on a 45 degree angled track
  bool isCrossLine(List<LetterOffset> offsets) {
    if (offsets.isEmpty) {
      return false;
    }

    for (int x = 0; x < offsets.length; x++) {
      if (x > 0) {
        int a = offsets[x].getSmallerOffset.dx.toInt() -
            offsets[x - 1].getSmallerOffset.dx.toInt();
        int b = offsets[x].getSmallerOffset.dy.toInt() -
            offsets[x - 1].getSmallerOffset.dy.toInt();

        if (a.abs() - b.abs() != 0) {
          return false;
        }
      }
    }

    return true;
  }

  //generate random colors based on the give line colors
  Color generateRandomColor() {
    Random random = Random();
    int index = random.nextInt(widget.lineDecoration!.lineColors!.length);
    return widget.lineDecoration!.lineColors![index];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 14),
          child: Center(
            child: GestureDetector(
              onPanStart: (DragStartDetails details) async {
                final provider =
                Provider.of<GameScreenProvider>(context, listen: false);

                if (provider.allowMark) {
                  color = generateRandomColor();

                  if (soundPref_ == "on") {
                    await AudioPlayer().play(soundConstants.selectSound);
                  }

                  setState(() {
                    startPoint = LetterOffset(
                        offset: details.localPosition, spacing: widget.spacing);
                    endPoint = LetterOffset(
                        offset: details.localPosition, spacing: widget.spacing);
                    lineList.add(WordLine(
                        offsets: [startPoint!, endPoint!],
                        color: color!,
                        letters: letters,
                        acceptReversedDirection:
                        widget.acceptReversedDirection!));
                    provider.setCurrentMarkedWord("");
                    provider.setIsMarkingCurrently(true);
                    provider.setCurrentMarkedWord(
                        lineList.last.word.substring(0, 1));
                    lastWord = lineList.last.word;
                    provider.setRandomColor(lineList.last.color);

                    // this is to avoid a bug with the grid that creates an unecessary line after matching a word
                    for (var i = 0; i < lineList.length - 1; i++) {
                      print(lineList
                          .elementAt(i)
                          .word);
                      if (!provider.filteredWordsFromAPI
                          .contains(lineList
                          .elementAt(i)
                          .word)) {
                        lineList.removeAt(i);
                      }
                    }
                  });
                }
              },
              onPanUpdate: (DragUpdateDetails details) async {
                final provider =
                Provider.of<GameScreenProvider>(context, listen: false);

                if (provider.allowMark) {
                  AudioPlayer audioPlayer = new AudioPlayer();

                  setState(() {
                    if (widget.incorrWords.contains(lineList.last.word)) {
                      isMarked = true;
                    }
                    //get initial positions based on user interaction on the panel
                    final dx = details.localPosition.dx - startPoint!.offset.dx;
                    final dy = details.localPosition.dy - startPoint!.offset.dy;

                    double angle = atan2(dy, dx);

                    // Round the angle to the nearesat multiple of 45 degrees
                    angle = (angle / (pi / 4)).round() * (pi / 4);

                    final length = sqrt(dx * dx + dy * dy);

                    //get the restricted coordinates using the angle
                    final restrictedDx = cos(angle) * length;
                    final restrictedDy = sin(angle) * length;
                    //Use a custom class to get suitable conversions
                    LetterOffset c = LetterOffset(
                        offset: Offset(startPoint!.offset.dx + restrictedDx,
                            startPoint!.offset.dy + restrictedDy),
                        spacing: widget.spacing);

                    //line can only be drawn by touching inside the panel
                    if (isWithinLimit(c)) {
                      endPoint = c;
                      print('angle');
                      // print(endPoint?.getBiggerOffset.direction);
                      // print(endPoint!.getBiggerOffset.direction - endPoint!.getSmallerOffset.direction);
                      // if(endPoint!.getBiggerOffset.direction > 0.20 &&
                      //     endPoint!.getBiggerOffset.direction < 0.80 ) {
                      //   return;
                      // }
                      lineList.last = WordLine(
                          offsets: [startPoint!, endPoint!],
                          color: color!,
                          letters: letters,
                          acceptReversedDirection:
                          widget.acceptReversedDirection!);

                      if (provider.currentMarkedWord.toString() !=
                          lineList.last.word) {
                        Future.delayed(const Duration(milliseconds: 10),
                                () async {
                              if (soundPref_ == "on") {
                                await AudioPlayer()
                                    .play(soundConstants.selectSound);
                              }
                            });
                        provider.setCurrentMarkedWord(lineList.last.word);
                      }
                      // this is to avoid a bug with the grid that creates an unecessary line after matching a word
                      for (var i = 0; i < lineList.length - 1; i++) {
                        print(lineList
                            .elementAt(i)
                            .word);
                        if (!provider.filteredWordsFromAPI
                            .contains(lineList
                            .elementAt(i)
                            .word)) {
                          lineList.removeAt(i);
                        }
                      }
                    }
                  });
                }
              },
              onPanEnd: (DragEndDetails details) async {
                //get initial positions based on user interaction on the panel

                final provider =
                Provider.of<GameScreenProvider>(context, listen: false);

                if (provider.allowMark) {
                  //get the last line drawn from the list
                  List<Offset> usedOffsets = lineList.last.getTotalOffsets;
                  if (soundPref_ == "on") {
                    await AudioPlayer().play(soundConstants.selectSound);
                  }
                  setState(() {
                    provider.setIsMarkingCurrently(false);
                    provider.setCurrentMarkedWord(lineList.last.word);

                    //Check if the line can be drawn on specific angles
                    if (selectedOffsets
                        .toSet()
                        .intersection(usedOffsets.toSet())
                        .isEmpty &&
                        lineList.last.offsets
                            .map((e) => e.getSmallerOffset)
                            .toSet()
                            .length >
                            1 &&
                        (((widget.drawHorizontalLine ?? true)
                            ? isHorizontalLine(lineList.last.offsets)
                            : false) ||
                            ((widget.drawVerticalLine ?? true)
                                ? isVerticalLine(lineList.last.offsets)
                                : false) ||
                            ((widget.drawCrossLine ?? true)
                                ? isCrossLine(lineList.last.offsets)
                                : false))) {
                      //   selectedOffsets.addAll(usedOffsets);

                      final provider = Provider.of<GameScreenProvider>(context,
                          listen: false);
                      print('word:');
                      print(lineList.last.word);

                      print('incorrect words:');
                      print(widget.incorrWords);

                      print('marked words:');
                      print(wordsMarked.length);

                      var reverseWord = lineList.last.word
                          .toString()
                          .split('')
                          .reversed
                          .join('');
                      print(reverseWord);

                      if (wordsMarked.contains(lineList.last.word) == false) {
                        if (widget.allWords.contains(lineList.last.word) ||
                            widget.allWords.contains(reverseWord)) {

                          if (widget.correctWords.contains(lineList.last.word) ||
                              widget.correctWords.contains(reverseWord)) {
                            print('correct');

                            wordsMarked.add(lineList.last.word);
                            wordsAreMarked.add(lineList.last);
                            provider.addToWordLineMarkedWords(lineList.last);

                          } else if (widget.incorrWords.contains(lineList.last.word) ||
                              widget.incorrWords.contains(reverseWord)) {
                            //set a line color when the selected word is incorrect
                            lineList.last.color =
                            widget.lineDecoration!.incorrectColor!;
                            print('incorrect');
                            if(widget.incorrWords.contains(lineList.last.word)) {
                              wordsMarked.add(lineList.last.word);
                              incorrectMarked.add(lineList.last.word);
                              wordsAreMarked.add(lineList.last);
                              print('straight');
                            }
                            else if(widget.incorrWords.contains(reverseWord)) {
                              wordsMarked.add(reverseWord);
                              incorrectMarked.add(reverseWord);
                              WordLine line = lineList.last;
                              wordsAreMarked.add(lineList.last);
                              print('reverse');
                            }
                          }

                          widget.onLineDrawn(
                              lineList.map((e) => e.word).toList());
                        } else {
                          Future.delayed(const Duration(milliseconds: 50),
                                  () async {
                                if (soundPref_ == "on") {
                                  await AudioPlayer()
                                      .play(soundConstants.notMatched);
                                }
                              });
                          startPoint = null;
                          endPoint = null;
                          lineList.removeLast();
                        }
                      } else {
                        startPoint = null;
                        endPoint = null;
                        lineList.removeLast();
                      }
                      //return a list of word
                    } else {
                      print('already used');
                      startPoint = null;
                      endPoint = null;
                      lineList.removeLast();
                    }
                  });
                }
              },
              child: CustomPaint(
                //paints lines on the screen
                painter: LinePainter(
                    lineDecoration: widget.lineDecoration,
                    letters: letters,
                    lineList: lineList,
                    textStyle: widget.textStyle,
                    context_: context,
                    incorrWords: widget.incorrWords,
                    wordsMarked: wordsAreMarked,
                    borderColor: Colors.red,
                    isMarked: isMarked,
                    incorrectMarked: incorrectMarked,
                    spacing: widget.spacing,
                    hints: widget.allWords),
                size: Size(letters.length * widget.spacing.dx,
                    letters.first.length * widget.spacing.dy),
              ),
            ),
          ),
        )
      ],
    );
  }
}
