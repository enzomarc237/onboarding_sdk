/// This file defines the [TooltipWidget], a customizable Flutter widget
/// used to display information and navigation controls for a single step
/// in a feature tour.
import 'package:flutter/material.dart';

/// A customizable tooltip widget displayed during a feature tour.
///
/// This widget shows a title, description, and provides navigation buttons
/// (Next, Previous, Skip, Finish) based on the current tour step.
class TooltipWidget extends StatelessWidget {
  /// The title text to display in the tooltip.
  final String title;

  /// The detailed description text to display in the tooltip.
  final String description;

  /// The background color of the tooltip.
  ///
  /// Defaults to [Colors.blue].
  final Color backgroundColor;

  /// The color of the text within the tooltip.
  ///
  /// Defaults to [Colors.white].
  final Color textColor;

  /// The border radius for the tooltip container.
  ///
  /// Defaults to `BorderRadius.all(Radius.circular(8.0))`.
  final BorderRadius borderRadius;

  /// Callback function invoked when the "Next" or "Finish" button is pressed.
  final VoidCallback? onNext;

  /// Callback function invoked when the "Previous" button is pressed.
  final VoidCallback? onPrevious;

  /// Callback function invoked when the "Skip" button is pressed.
  final VoidCallback? onSkip;

  /// A boolean indicating if the current tour step is the last one.
  ///
  /// This affects the text of the "Next" button (changes to "Finish").
  final bool isLastStep;

  /// A boolean indicating if the current tour step is the first one.
  ///
  /// This controls the visibility of the "Previous" button.
  final bool isFirstStep;

  /// Creates a [TooltipWidget].
  ///
  /// Parameters:
  /// - [key]: Optional key for the widget.
  /// - [title]: The title text (required).
  /// - [description]: The description text (required).
  /// - [backgroundColor]: The background color of the tooltip (defaults to blue).
  /// - [textColor]: The text color of the tooltip (defaults to white).
  /// - [borderRadius]: The border radius of the tooltip (defaults to 8.0 circular).
  /// - [onNext]: Callback for the next/finish button.
  /// - [onPrevious]: Callback for the previous button.
  /// - [onSkip]: Callback for the skip button.
  /// - [isLastStep]: True if it's the last step, changes "Next" to "Finish".
  /// - [isFirstStep]: True if it's the first step, hides "Previous" button.
  const TooltipWidget({
    Key? key,
    required this.title,
    required this.description,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.onNext,
    this.onPrevious,
    this.onSkip,
    this.isLastStep = false,
    this.isFirstStep = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              description,
              style: TextStyle(
                color: textColor,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isFirstStep && onPrevious != null)
                  TextButton(
                    onPressed: onPrevious,
                    child: Text(
                      'Previous',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                const SizedBox(width: 8.0),
                if (onNext != null)
                  TextButton(
                    onPressed: onNext,
                    child: Text(
                      isLastStep ? 'Finish' : 'Next',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                const SizedBox(width: 8.0),
                if (onSkip != null)
                  TextButton(
                    onPressed: onSkip,
                    child: Text(
                      'Skip',
                      style: TextStyle(color: textColor),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}