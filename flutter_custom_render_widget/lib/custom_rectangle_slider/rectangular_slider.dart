import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnSliderValueChange = Function(BreakPoints);

class BreakPoints {
  int start;
  int end;

  BreakPoints({
    required this.start,
    required this.end
  });
}

class RectangularSlider extends LeafRenderObjectWidget {

  RectangularSlider({
    required this.borderColor,
    required this.selectionColor,
    required this.selectionWidth,
    required this.height,
    required this.width,
    required this.strokeWidth,
    required this.sliderStartPoint,
    this.onSliderValueChange
}) : assert(selectionWidth < width);

  final Color borderColor;
  final Color selectionColor;
  final double strokeWidth;
  final double height;
  final double width;
  final double selectionWidth;
  final double sliderStartPoint;
  final OnSliderValueChange? onSliderValueChange;

  @override
  RenderObject createRenderObject(BuildContext context) {
   return RectangularSliderRenderBox(
       width: width,
       height: height,
       strokeWidth: strokeWidth,
       selectionWidth: selectionWidth,
       borderColor: borderColor,
       selectionColor: selectionColor,
       currentStartPos: sliderStartPoint,
       onSliderValueChange: onSliderValueChange
   );
  }

  @override
  void updateRenderObject(
      BuildContext context, RectangularSliderRenderBox renderObject) {
    renderObject
      ..width = width
      ..height = height
      ..strokeWidth = strokeWidth
      ..selectionWidth = selectionWidth
      ..borderColor = borderColor
      ..selectionColor = selectionColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(ColorProperty('selectionColor', selectionColor));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('selectionWidth', selectionWidth));
    properties.add(DoubleProperty('strokeWidth', strokeWidth));
  }
}

class RectangularSliderRenderBox extends RenderBox {

  late HorizontalDragGestureRecognizer _drag;

  Color get borderColor => _borderColor;
  Color _borderColor;

  set borderColor(Color value) {
    if (_borderColor == value) return;
    _borderColor = value;
    markNeedsPaint();
  }


  Color get selectionColor => _selectionColor;
  Color _selectionColor;

  set selectionColor(Color value) {
    if (_selectionColor == value) return;
    _selectionColor = value;
    markNeedsPaint();
  }

  double get selectionWidth => _selectionWidth;
  double _selectionWidth;

  set selectionWidth(double value) {
    if (_selectionWidth == value) return;
    _selectionWidth = value;
    markNeedsLayout();
  }

  double get strokeWidth => _strokeWidth;
  double _strokeWidth;

  set strokeWidth(double value) {
    if (_strokeWidth == value) return;
    _strokeWidth = value;
    markNeedsLayout();
  }

  double get height => _height;
  double _height;

  set height(double value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  double get width => _width;
  double _width;

  set width(double value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  double get currentStartPos => _currentStartPos;
  double _currentStartPos;

  set currentStartPos(double value) {
    if (_currentStartPos == value) return;
    _currentStartPos = value;
    markNeedsLayout();
  }

  OnSliderValueChange? get onSliderValueChange => _onSliderValueChange;
  OnSliderValueChange? _onSliderValueChange;

  set onSliderValueChange(OnSliderValueChange? value) {
    if (_onSliderValueChange == value) return;
    _onSliderValueChange = value;
  }

  RectangularSliderRenderBox({
    required double width,
    required double height,
    required double strokeWidth,
    required double selectionWidth,
    required Color borderColor,
    required Color selectionColor,
    required double currentStartPos,
    OnSliderValueChange? onSliderValueChange,
  })
  :
        _width = width,
        _height = height,
        _selectionColor = selectionColor,
        _selectionWidth = selectionWidth,
        _borderColor = borderColor,
        _strokeWidth = strokeWidth,
        _currentStartPos = currentStartPos,
        _onSliderValueChange = onSliderValueChange,
  assert(selectionWidth < width)
  {
      // initialize the gesture recognizer
      _drag = HorizontalDragGestureRecognizer()
        ..onStart = (DragStartDetails details) {
          _updateRectanglePosition(details.localPosition);
        }
        ..onUpdate = (DragUpdateDetails details) {
          _updateRectanglePosition(details.localPosition);
        };

  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _height;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _width;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _height;
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final desiredWidth = width;
    final desiredHeight = height;
    final desiredSize = Size(desiredWidth, desiredHeight);
    return constraints.constrain(desiredSize);
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
  void paint(PaintingContext context, Offset offset) {

    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    // paint bar
    final mainRectanglePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final sliderRectanglePaint = Paint()
      ..color = selectionColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final centerLinePain = Paint()
      ..color = borderColor.withOpacity(0.5)
      ..strokeWidth = strokeWidth;

    Rect mainRect = Rect.fromLTWH(0, 0, width, height);
      canvas.drawRect(mainRect, mainRectanglePaint);

      Offset offset1 = Offset(width/2, 0);
      Offset offset2 = Offset(width/2, height);
      canvas.drawLine(offset1, offset2, centerLinePain);
    Rect selectionRect = Rect.fromLTWH(_currentStartPos, 0, selectionWidth, height);
    canvas.drawRect(selectionRect, sliderRectanglePaint);
    canvas.restore();
  }

  @override
  bool get isRepaintBoundary => true;

  void _updateRectanglePosition(Offset localPosition) {
    var maxSlideLimit = size.width - selectionWidth;
    var dx = localPosition.dx.clamp(0, maxSlideLimit);
    _currentStartPos = dx.toDouble();

    var break1 = ((_currentStartPos / width) * 100).toInt();
    var break2 = 100 - break1; // TODO: calculation pending
    BreakPoints points = BreakPoints(start: break1, end: break2);
    if(_onSliderValueChange != null) {
      _onSliderValueChange!(points);
    }
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

}