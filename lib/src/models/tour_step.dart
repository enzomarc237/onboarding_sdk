/// This file defines the [TourStep] class, which represents a single step
/// in a feature tour, and the [HighlightShape] enum for customizing the
/// appearance of the highlighted target widget.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Represents a single step in a feature tour.
///
/// Each [TourStep] defines a target widget to highlight, the content for
/// its associated tooltip, and visual customization options for the highlight.
class TourStep {
  /// A [GlobalKey] that identifies the target widget to be highlighted for this step.
  final GlobalKey key;

  /// The title text displayed in the tooltip for this tour step.
  final String title;

  /// The detailed description text displayed in the tooltip for this tour step.
  final String description;

  /// The calculated [Rect] of the target widget in global coordinates.
  ///
  /// This property is typically calculated at runtime when the tour starts
  /// and the widget is rendered. It is nullable because it's not known at
  /// the time of [TourStep] creation.
  Rect? targetRect;

  /// The border radius applied to the highlighted area around the target widget.
  ///
  /// Defaults to `BorderRadius.all(Radius.circular(8.0))`.
  final BorderRadius borderRadius;

  /// The color of the overlay that covers the rest of the screen, dimming
  /// non-highlighted areas.
  ///
  /// Defaults to `Colors.black54`.
  final Color overlayColor;

  /// The color of the highlight around the target widget.
  ///
  /// Defaults to `Colors.white`.
  final Color highlightColor;

  /// The shape of the highlight around the target widget.
  ///
  /// Defaults to [HighlightShape.roundedRect].
  final HighlightShape highlightShape;

  /// Creates a [TourStep] instance.
  ///
  /// Parameters:
  /// - [key]: A [GlobalKey] for the target widget.
  /// - [title]: The title for the tooltip.
  /// - [description]: The description for the tooltip.
  /// - [targetRect]: Optional, the calculated rectangle of the target widget.
  /// - [borderRadius]: Optional, the border radius for the highlight.
  /// - [overlayColor]: Optional, the color of the overlay.
  /// - [highlightColor]: Optional, the color of the highlight.
  /// - [highlightShape]: Optional, the shape of the highlight.
  TourStep({
    required this.key,
    required this.title,
    required this.description,
    this.targetRect,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.overlayColor = Colors.black54,
    this.highlightColor = Colors.white,
    this.highlightShape = HighlightShape.roundedRect,
  });
}

/// Defines the available shapes for highlighting a target widget in a tour step.
enum HighlightShape {
  /// A rectangular highlight with rounded corners.
  roundedRect,
  // Future: Add other shapes like circle, oval, etc., if needed.
}