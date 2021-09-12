import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomProgressRangeViewer extends LeafRenderObjectWidget {
  const CustomProgressRangeViewer({
    Key? key,
    required this.barColor,
    required this.thumbColor,
    this.thumbSize = 20.0,
    required this.breakPoints,
    required this.activeThumbColor,
    required this.activeIndex
  }) : super(key: key);

  final Color barColor;
  final Color thumbColor;
  final double thumbSize;
  final List<int> breakPoints;
  final Color activeThumbColor;
  final int activeIndex;

  @override
  RenderRangeSlider createRenderObject(BuildContext context) {
    return RenderRangeSlider(
      barColor: barColor,
      thumbColor: thumbColor,
      thumbSize: thumbSize,
      breakPoints: breakPoints,
      activeThumbColor: activeThumbColor,
      activeIndex: activeIndex
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderRangeSlider renderObject) {
    renderObject
      ..barColor = barColor
      ..thumbColor = thumbColor
      ..thumbSize = thumbSize
      ..activeThumbColor = activeThumbColor
      ..breaks = breakPoints;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('barColor', barColor));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(DoubleProperty('thumbSize', thumbSize));
    properties.add(ColorProperty('activeThumbColor', activeThumbColor));
    properties.add(IterableProperty('breaks', breakPoints));
  }
}

class RenderRangeSlider extends RenderBox {
  static const _minDesiredWidth = 100.0;
  double _currentThumbValue = 0.5;
  late HorizontalDragGestureRecognizer _drag;

  Color get barColor => _barColor;
  Color _barColor;

  set barColor(Color value) {
    if (_barColor == value) return;
    _barColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;

  set thumbColor(Color value) {
    if (_thumbColor == value) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  Color get activeThumbColor => _activeThumbColor;
  Color _activeThumbColor;

  set activeThumbColor(Color value) {
    if (_thumbColor == value) return;
    _activeThumbColor = value;
    markNeedsPaint();
  }

  double get thumbSize => _thumbSize;
  double _thumbSize;

  set thumbSize(double value) {
    if (_thumbSize == value) return;
    _thumbSize = value;
    markNeedsLayout();
  }

  List<int> get breaks => _breaks;
  List<int> _breaks;
  set breaks(List<int> value) {
    if (_breaks == value) return;
    _breaks = value;
    markNeedsLayout();
  }

  int get activeIndex => _activeIndex;
  int _activeIndex;
  set activeIndex(int value) {
    if (_activeIndex == value) return;
    _activeIndex = value;
    markNeedsLayout();
  }

  RenderRangeSlider(
      {required Color barColor,
        required Color thumbColor,
        required double thumbSize,
        required List<int> breakPoints,
        required Color activeThumbColor,
        required int activeIndex})
      : _barColor = barColor,
        _thumbColor = thumbColor,
        _thumbSize = thumbSize,
        _activeThumbColor = activeThumbColor,
        _breaks = breakPoints,
        _activeIndex = activeIndex
  {
    // initialize the gesture recognizer
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = (DragStartDetails details) {
        _updateThumbPosition(details.localPosition);
      }
      ..onUpdate = (DragUpdateDetails details) {
        _updateThumbPosition(details.localPosition);
      };
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return thumbSize;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return thumbSize;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _minDesiredWidth;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _minDesiredWidth;
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final desiredWidth = constraints.maxWidth;
    final desiredHeight = thumbSize + 50;
    final desiredSize = Size(desiredWidth, desiredHeight);
    return constraints.constrain(desiredSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {

    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    // paint bar
    final barPaint = Paint()
      ..color = barColor
      ..strokeWidth = 5;
    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width, size.height / 2);
    canvas.drawLine(point1, point2, barPaint);
    // paint thumb
    for(int index=0; index < _breaks.length; index++) {
      int value = _breaks[index];
      String textValue = '${'$value%'}';
      final thumbDx = (_breaks[index] * size.width) / 100;
      if(index == activeIndex) {
        final thumbPaint = Paint()..color = activeThumbColor;
        final thumbPosition = Offset(thumbDx, size.height / 2);
        Offset offsetText1 = Offset(thumbPosition.dx-10.0, thumbPosition.dy+20.0);
        Offset offsetText2 = Offset(thumbPosition.dx-10.0, thumbPosition.dy-30.0);
        canvas.drawCircle(thumbPosition, thumbSize / 2, thumbPaint);
        var painter1 = getTextPainter(textValue);
        var painter2 = getTextPainter(textValue, isActive: true);
        painter1.paint(canvas, offsetText1);
        painter2.paint(canvas, offsetText2);
      } else {
        final thumbPaint = Paint()..color = thumbColor;
        final center = Offset(thumbDx, size.height / 2);
        final Offset offsetText1 =  Offset(center.dx-10.0, center.dy+20.0);
        canvas.drawCircle(center, thumbSize / 2, thumbPaint);
        var painter1 = getTextPainter(textValue);
        painter1.paint(canvas, offsetText1);
      }
    }
    canvas.restore();
  }


  TextPainter getTextPainter(String text, {bool isActive = false}) {
    final textSpan = TextSpan(
      text: text,
      style: getTextStyle(isActive: isActive),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 40,
    );
    return textPainter;
  }

  TextStyle getTextStyle({bool isActive = false}) {
    if (isActive) {
      return TextStyle(
        color: activeThumbColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );
    } else {
      return TextStyle(
        color: thumbColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }

  @override
  bool get isRepaintBoundary => true;

  void _updateThumbPosition(Offset localPosition) {

    // var dx = localPosition.dx.clamp(0, size.width);
    // _currentThumbValue = dx / size.width;
    // markNeedsPaint();
    // markNeedsSemanticsUpdate();
  }
}
