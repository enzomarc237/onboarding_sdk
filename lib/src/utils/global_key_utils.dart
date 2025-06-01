/// This file provides utility functions related to [GlobalKey] for
/// calculating widget positions and sizes within the Flutter widget tree.
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

/// A utility class containing helper methods for working with [GlobalKey]s.
///
/// This class is primarily used to obtain the [Rect] (position and size)
/// of a widget identified by a [GlobalKey], which is crucial for positioning
/// overlays and highlights in a feature tour.
class GlobalKeyUtils {
  /// Calculates and returns the [Rect] of the widget associated with the given [GlobalKey].
  ///
  /// This method traverses the widget tree to find the [RenderBox] corresponding
  /// to the widget identified by [key]. It then calculates the global position
  /// and size of that render box.
  ///
  /// Returns:
  /// - A [Rect] object representing the position and size of the widget in
  ///   global coordinates if the widget's context and render object are found.
  /// - `null` if the [key]'s [BuildContext] or its associated [RenderObject]
  ///   (or if it's not a [RenderBox]) cannot be found.
  ///
  /// Parameters:
  /// - [key]: The [GlobalKey] of the target widget whose [Rect] is to be calculated.
  static Rect? getWidgetRect(GlobalKey key) {
    final RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final RenderBox renderBox = renderObject;
      final Offset offset = renderBox.localToGlobal(Offset.zero);
      return Rect.fromLTWH(
        offset.dx,
        offset.dy,
        renderBox.size.width,
        renderBox.size.height,
      );
    }
    return null;
  }
}