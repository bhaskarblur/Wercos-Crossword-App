
import 'dart:ui';

import 'package:crossword/components/word_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      ..strokeWidth = 10
      ..color = borderColor!
    ..strokeCap = StrokeCap.round;

    //paint lines on the grid
    for (var points in lineList) {
      //set the line color
      paint.color = points.color;

      for (int i = 0; i < points.offsets.length - 1; i++) {

        // Path path= Path();
        // path.moveTo(points.offsets[i].getBiggerOffset.dx-2,
        //     points.offsets[i].getBiggerOffset.dy-4);
        // path.lineTo(points.offsets[i+1].getBiggerOffset.dx+4,
        //     points.offsets[i+1].getBiggerOffset.dy+4);
        //
        // canvas.drawPath(path, paint);


        // if(incorrWords.contains(points.word)) {
        //   canvas.drawRRect(RRect.fromRectAndRadius(
        //       Rect.fromLTRB(points.offsets[i].getBiggerOffset.dx -14,
        //           points.offsets[i].getBiggerOffset.dy -14 ,
        //           points.offsets[i+1].getBiggerOffset.dx +14,
        //           points.offsets[i+1].getBiggerOffset.dy+14),Radius.circular(15.0)),paintBorder);
        //
        // }
        // else {


          canvas.drawLine(points.offsets[i].getBiggerOffset,
              points.offsets[i + 1].getBiggerOffset, paint);


        }
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
