import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';

class Label extends StatelessWidget {
  final String text;
  final double? fontSize;

  final FontWeight? fontWeight;
  final int? maxLine;
  final TextOverflow? overflow;
  final TextAlign? align;
  final Color? color;

  const Label({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.align,
    this.color,
    this.maxLine,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLine ?? 50,
        overflow: overflow ?? TextOverflow.visible,
        textAlign: align ?? TextAlign.left,
        style: GoogleFonts.inter(
            fontSize: fontSize ?? 14,
            fontWeight: fontWeight ?? FontWeight.normal,
            color: color ?? AllColors.white));
  }
}
