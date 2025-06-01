/// This file contains the [TourOverlayController] class, which manages the
/// display and removal of the tour overlay in a Flutter application.
library onboarding_sdk;
import 'package:flutter/material.dart';

/// A controller class responsible for managing the display of an [OverlayEntry]
/// for the feature tour.
///
/// It provides methods to show, hide, and update the overlay content, ensuring
/// that only one tour overlay is active at a time.
class TourOverlayController {
  /// The currently active [OverlayEntry] for the tour.
  ///
  /// This will be `null` if no overlay is currently displayed.
  OverlayEntry? _overlayEntry;

  /// The [BuildContext] associated with the currently displayed overlay.
  ///
  /// This context is used to insert and remove the [OverlayEntry] from the
  /// application's overlay. It is `null` when no overlay is active.
  BuildContext? context;

  /// Displays an overlay with the given [overlayContent] on top of the application.
  ///
  /// If an existing overlay is active, it will be removed before the new one
  /// is displayed. The [context] is required to insert the overlay.
  ///
  /// Parameters:
  /// - [context]: The [BuildContext] to use for inserting the overlay.
  /// - [overlayContent]: The widget to display within the overlay.
  void showOverlay({required BuildContext context, required Widget overlayContent}) {
    this.context = context;
    hideOverlay(); // Remove any existing overlay before showing a new one

    _overlayEntry = OverlayEntry(
      builder: (context) => overlayContent,
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hides the currently active overlay, if any.
  ///
  /// Removes the [_overlayEntry] from the overlay and nullifies it,
  /// along with clearing the stored [context].
  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    context = null;
  }

  /// Updates the content of the currently displayed overlay.
  ///
  /// This method first hides the existing overlay and then shows a new one
  /// with the provided [overlayContent] and [context].
  ///
  /// Parameters:
  /// - [context]: The [BuildContext] to use for updating the overlay.
  /// - [overlayContent]: The new widget content to display within the overlay.
  void updateOverlay({required BuildContext context, required Widget overlayContent}) {
    this.context = context;
    hideOverlay();
    showOverlay(context: context, overlayContent: overlayContent);
  }
}