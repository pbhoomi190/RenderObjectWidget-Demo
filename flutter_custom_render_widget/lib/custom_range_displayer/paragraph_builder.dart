import 'dart:ui' as ui;


ui.Paragraph getText(String percentage) {
  final ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        fontSize:   14,
        fontWeight: ui.FontWeight.w500,
        textAlign: ui.TextAlign.center,
        fontStyle: ui.FontStyle.normal,
      )
  )
    ..addText(percentage);
  final ui.Paragraph paragraph = paragraphBuilder.build()
    ..layout(ui.ParagraphConstraints(width: 30));
  return paragraph;
}

//canvas.drawParagraph(paragraph, const Offset(12.0, 36.0));