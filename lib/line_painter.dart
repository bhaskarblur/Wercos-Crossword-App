
import 'dart:ui';

import 'package:crossword/components/word_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_word_search/providers/game_screen_provider.dart';
import 'package:provider/provider.dart';

import 'linedecoration.dart';

class LinePainter extends CustomPainter {
  final List<WordLine> lineList;
  final List<List<String>> letters;
  final Offset spacing;
  final List<String> hints;
  final Color? correctColor;
  final TextStyle? textStyle;
  final List<String> incorrWords;
  var context_;
  List<WordLine> wordsMarked;
  var incorrectMarked;
  var isMarked=false;
  final Color? borderColor;
  final LineDecoration? lineDecoration;

  LinePainter({
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.lineDecoration = const LineDecoration(),
    required this.letters,
    required this.lineList,
    required this.spacing,
    required this.hints,
    required this.incorrWords,
    this.context_,
    this.incorrectMarked,
    required this.wordsMarked,
    required this.isMarked,
    this.correctColor = Colors.green,
    this.borderColor
  });



  @override
  void paint(Canvas canvas, Size size) {
    List<PaintingStyle> styles=[];
    styles.add(PaintingStyle.fill);
    styles.add(PaintingStyle.stroke);
    final paint = Paint()
      ..strokeWidth = lineDecoration!.strokeWidth!
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = lineDecoration!.strokeCap!;

    Paint paintBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..color = borderColor!
    ..strokeCap = StrokeCap.round;

    // paint already marked word lines on the grid
    for (var wordLine_ in wordsMarked) {
      //set the line color
      paint.color = wordLine_.color;

      // Paint each part of a word on the grid
      for (int i = 0; i < wordLine_.offsets.length - 1; i++) {

        if(incorrWords.contains(wordLine_.word)) {
             canvas.drawRRect(RRect.fromRectAndRadius(
          Rect.fromLTRB(wordLine_.offsets[i].getBiggerOffset.dx - 14,
              wordLine_.offsets[i].getBiggerOffset.dy - 14,
              wordLine_.offsets[i + 1].getBiggerOffset.dx + 14,
              wordLine_.offsets[i + 1].getBiggerOffset.dy + 14),
          Radius.circular(15.0)), paintBorder);
        }
        else {
          canvas.drawLine(wordLine_.offsets[i].getBiggerOffset,
              wordLine_.offsets[i + 1].getBiggerOffset, paint);
        }
      }
    }

    // paint each word lines on the grid
    for (var wordLine in lineList) {
      //set the line color
      paint.color = wordLine.color;

      if(wordsMarked.contains(wordLine)) {

      }
      else {
        for (int i = 0; i < wordLine.offsets.length - 1; i++) {

          if(incorrWords.contains(wordLine.word) && !isMarked) {
            canvas.drawRRect(RRect.fromRectAndRadius(
                Rect.fromLTRB(wordLine.offsets[i].getBiggerOffset.dx - 14,
                    wordLine.offsets[i].getBiggerOffset.dy - 14,
                    wordLine.offsets[i + 1].getBiggerOffset.dx + 14,
                    wordLine.offsets[i + 1].getBiggerOffset.dy + 14),
                Radius.circular(15.0)), paintBorder);
          }
          else {
            // isMarked = false;
            canvas.drawLine(wordLine.offsets[i].getBiggerOffset,
                wordLine.offsets[i + 1].getBiggerOffset, paint);
          }

        }
      }
      // Paint each part of a word on the grid

    }

    //paint texts on the grid
    for (int i = 0; i < letters.length; i++) {
      for (int j = 0; j < letters.first.length; j++) {
        double x = i.toDouble() * spacing.dx + spacing.dx / 2;
        double y = j.toDouble() * spacing.dy + spacing.dy / 2;

        // Draw letters

        TextPainter painter = TextPainter(
          text: TextSpan(
            text: letters[i][j],
            style: GoogleFonts.inter(textStyle:
            Theme.of(context_).textTheme.headlineLarge,fontSize: 23, color: const Color(0xFF221962)
                , fontWeight: FontWeight.w800),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center
        );
        painter.layout();
        painter.paint(
            canvas, Offset(x - painter.width / 2, y - painter.height / 2));
      }
    }
  }


  @override
  bool shouldRepaint(LinePainter oldDelegate) => true;
}

// Path path= Path();
// path.moveTo(points.offsets[i].getBiggerOffset.dx-8,
//     points.offsets[i].getBiggerOffset.dy-10);
//
// path.lineTo(points.offsets[i+1].getBiggerOffset.dx+8,
//     points.offsets[i+1].getBiggerOffset.dy+10);
//
// path.arcToPoint(Offset(points.offsets[i+1].getBiggerOffset.dx+8,
//     points.offsets[i+1].getBiggerOffset.dy+10), radius:
// Radius.circular(10));
//
// path.moveTo(points.offsets[i+1].getBiggerOffset.dx+8,
//     points.offsets[i+1].getBiggerOffset.dy+10);
//
// path.lineTo(points.offsets[i].getBiggerOffset.dx + 10,
//     points.offsets[i].getBiggerOffset.dy-12);
//
// path.arcToPoint(Offset(points.offsets[i].getBiggerOffset.dx-8,
//     points.offsets[i].getBiggerOffset.dy-10),
//     radius:
// Radius.circular(10));
//
// canvas.drawPath(path, paintBorder);

// if (incorrectMarked.contains(points.word) && !isMarked ) {
//   print('i touched');
//   canvas.drawRRect(RRect.fromRectAndRadius(
//       Rect.fromLTRB(points.offsets[i].getBiggerOffset.dx - 14,
//           points.offsets[i].getBiggerOffset.dy - 14,
//           points.offsets[i + 1].getBiggerOffset.dx + 14,
//           points.offsets[i + 1].getBiggerOffset.dy + 14),
//       Radius.circular(15.0)), paintBorder);
//
//
// }
// else if (!incorrectMarked.contains(points.word) && !isMarked ) {
//   isMarked=false;
//   if (!incorrWords.contains(points.word)
//       && !incorrectMarked.contains(lineList.last.word)) {
//
//       canvas.drawLine(points.offsets[i].getBiggerOffset,
//           points.offsets[i + 1].getBiggerOffset, paint);
//       print('this');
//
//   }
//
//   else {
//     if (!incorrWords.contains(lineList.last.word)
//         && !incorrectMarked.contains(lineList.last.word)) {
//       canvas.drawLine(points.offsets[i].getBiggerOffset,
//           points.offsets[i + 1].getBiggerOffset, paint);
//       // print('this');
//     }
//   }
//
//   // else {
//   //   if (!incorrWords.contains(lineList.last.word)
//   //       && !incorrectMarked.contains(lineList.last.word)) {
//   //
//   //
//   //       canvas.drawLine(points.offsets[i].getBiggerOffset,
//   //           points.offsets[i + 1].getBiggerOffset, paint);
//   //     print('that');
//   //   }
//   //
//   // }
//
// }
// else {
//   isMarked=false;
//   canvas.drawLine(points.offsets[i].getBiggerOffset,
//       points.offsets[i + 1].getBiggerOffset, paint);
// }