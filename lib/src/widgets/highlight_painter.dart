/// This file defines the [HighlightPainter] class, a custom painter used to
/// draw an overlay with a highlighted area around a target widget for feature tours.
library onboarding_sdk;
import 'package:flutter/material.dart';
import 'package:onboarding_sdk/src/models/tour_step.dart';

/// A [CustomPainter] that draws a semi-transparent overlay over the entire screen
/// while creating a "punch-out" effect to highlight a specific [highlightRect].
///
/// It can also draw a border around the highlighted area and supports different
/// highlight shapes.
class HighlightPainter extends CustomPainter {
  /// The rectangle defining the area to be highlighted.
  final Rect highlightRect;

  /// The color of the overlay that dims the non-highlighted areas of the screen.
  final Color overlayColor;

  /// The color of the border drawn around the highlighted area.
  final Color highlightColor;

  /// The border radius to apply to the highlighted rectangle.
  ///
  /// Defaults to `BorderRadius.all(Radius.circular(8.0))`.
  final BorderRadius borderRadius;

  /// The shape of the highlight.
  ///
  /// Defaults to [HighlightShape.roundedRect].
  final HighlightShape highlightShape;

  /// Creates a [HighlightPainter].
  ///
  /// Parameters:
  /// - [highlightRect]: The [Rect] of the widget to highlight.
  /// - [overlayColor]: The color for the overlay.
  /// - [highlightColor]: The color for the highlight border.
  /// - [borderRadius]: The border radius for the highlight (defaults to 8.0 circular).
  /// - [highlightShape]: The shape of the highlight (defaults to rounded rectangle).
  HighlightPainter({
    required this.highlightRect,
    required this.overlayColor,
    required this.highlightColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.highlightShape = HighlightShape.roundedRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create a path for the full screen
    final fullScreenPath = Path()..addRect(Offset.zero & size);

    // Initialize RRect for the highlight, will be updated based on shape
    RRect highlightRRect = RRect.fromRectAndRadius(highlightRect, Radius.zero);

    // Determine the shape of the highlight
    switch (highlightShape) {
      case HighlightShape.roundedRect:
        highlightRRect = RRect.fromRectAndCorners(
          highlightRect,
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        );
        break;
      // Add cases for other shapes like circle, oval, etc., if needed in the future
    }

    // Create a path for the highlight area
    final highlightPath = Path()..addRRect(highlightRRect);

    // Paint for the dimmed overlay
    final dimPaint = Paint()..color = overlayColor;

    // Draw the dimmed overlay by subtracting the highlight path from the full screen path
    canvas.drawPath(
      Path.combine(PathOperation.difference, fullScreenPath, highlightPath),
      dimPaint,
    );

    // Paint for the highlight border
    final highlightPaint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw the highlight border around the punch-out area
    canvas.drawRRect(highlightRRect, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant HighlightPainter oldDelegate) {
    // Repaint only if any of the properties that affect the painting change
    return oldDelegate.highlightRect != highlightRect ||
        oldDelegate.overlayColor != overlayColor ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.highlightShape != highlightShape;
  }
}