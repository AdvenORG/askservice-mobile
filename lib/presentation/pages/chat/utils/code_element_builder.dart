import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_highlighter/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    final controller = ScrollController();
    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        child: HighlightView(
          // The original code to be highlighted
          element.textContent,

          // Specify language
          // It is recommended to give it a value for performance
          language: language,

          // Specify highlight theme
          // All available themes are listed in `themes` folder
          theme:
              MediaQueryData.fromView(PlatformDispatcher.instance.views.first)
                          .platformBrightness ==
                      Brightness.light
                  ? atomOneLightTheme
                  : atomOneDarkTheme,
          // Specify padding
          padding: const EdgeInsets.all(8),

          // Specify text style
        ),
      ),
    );
  }
}
