/// Manages the lifecycle and state of feature tours in Flutter applications.
///
/// The [TourController] class orchestrates the display of interactive tour steps,
/// handles navigation between steps, and integrates with persistence services
/// to track tour completion status. It works in conjunction with [TourOverlayController]
/// to display highlights and tooltips.
library onboarding_sdk;
import 'package:flutter/material.dart';
import 'package:onboarding_sdk/src/models/tour_step.dart';
import 'package:onboarding_sdk/src/controllers/tour_overlay_controller.dart';
import 'package:onboarding_sdk/src/widgets/highlight_painter.dart';
import 'package:onboarding_sdk/src/widgets/tooltip_widget.dart';
import 'package:onboarding_sdk/src/utils/global_key_utils.dart';
import 'package:onboarding_sdk/src/services/tour_persistence_service.dart';

/// Central controller for managing feature tours in a Flutter application.
///
/// This class extends [ChangeNotifier] to provide state change notifications
/// to listening widgets. It manages:
/// - Tour step progression and navigation
/// - Overlay display for highlights and tooltips
/// - Persistence of tour completion status
/// - Callbacks for tour events
///
/// Example usage:
/// ```dart
/// final tourController = TourController(
///   steps: myTourSteps,
///   tourId: 'main_tour',
///   onTourComplete: () => print('Tour completed!'),
/// );
/// ```
class TourController extends ChangeNotifier {
  /// The sequence of tour steps to be displayed.
  ///
  /// This list defines the order and content of each step in the tour.
  final List<TourStep> _steps;

  /// Unique identifier for the tour, used for persistence.
  ///
  /// This ID is used to store and retrieve tour completion status
  /// from persistent storage.
  final String tourId;

  /// Callback invoked when the tour completes successfully.
  ///
  /// This is called after the last step is completed and the tour is marked
  /// as completed in persistent storage.
  final VoidCallback? onTourComplete;

  /// Callback invoked when the user skips the tour.
  ///
  /// This is called when the user explicitly skips the tour before completion.
  final VoidCallback? onTourSkipped;

  /// Index of the currently active tour step in the [_steps] list.
  ///
  /// A value of -1 indicates that no tour is currently active.
  int _currentStepIndex = -1;

  /// Manages the overlay display for tour steps.
  ///
  /// This controller handles adding and removing overlay entries that display
  /// tour highlights and tooltips. It is initialized when a tour starts and
  /// disposed when the tour ends.
  TourOverlayController? _tourOverlayController;

  /// Creates a [TourController] instance.
  ///
  /// Parameters:
  /// - [steps]: List of [TourStep] objects defining the tour sequence
  /// - [tourId]: Unique identifier for the tour (required for persistence)
  /// - [onTourComplete]: Optional callback when tour completes successfully
  /// - [onTourSkipped]: Optional callback when tour is skipped
  ///
  /// Initializes the persistence service when created.
  TourController({
    required List<TourStep> steps,
    required this.tourId,
    this.onTourComplete,
    this.onTourSkipped,
  }) : _steps = steps {
    TourPersistenceService.init();
  }

  /// Gets the currently active tour step.
  ///
  /// Returns the [TourStep] at the current index, or `null` if:
  /// - No tour is active
  /// - Current index is out of bounds
  TourStep? get currentStep {
    if (_currentStepIndex >= 0 && _currentStepIndex < _steps.length) {
      return _steps[_currentStepIndex];
    }
    return null;
  }

  /// Indicates whether a tour is currently active.
  ///
  /// Returns `true` if a tour is in progress, `false` otherwise.
  bool get isTourActive => _currentStepIndex != -1 && _currentStepIndex < _steps.length;

  /// Indicates whether the current step is the last step.
  ///
  /// Returns `true` if the current step is the final step in the tour.
  bool get isLastStep => _currentStepIndex == _steps.length - 1;

  /// Indicates whether the current step is the first step.
  ///
  /// Returns `true` if the current step is the first step in the tour.
  bool get isFirstStep => _currentStepIndex == 0;

  /// Starts the feature tour from the first step.
  ///
  /// Parameters:
  /// - [context]: BuildContext used to find target widgets and show overlays
  ///
  /// If the tour has no steps, logs a debug message and returns.
  /// Initializes the overlay controller and shows the first step.
  Future<void> startTour(BuildContext context) async {
    if (_steps.isEmpty) {
      debugPrint('Tour has no steps.');
      return;
    }

    _currentStepIndex = 0;
    _tourOverlayController = TourOverlayController();
    _showCurrentStepOverlay();
    notifyListeners();
  }

  /// Starts the tour only if it hasn't been completed before.
  ///
  /// Parameters:
  /// - [context]: BuildContext used to start the tour
  ///
  /// Checks persistent storage to see if the tour has been completed.
  /// If completed, invokes [onTourComplete] and skips starting the tour.
  /// Otherwise, starts the tour normally.
  Future<void> startTourIfNecessary(BuildContext context) async {
    if (await TourPersistenceService.isTourCompleted(tourId)) {
      debugPrint('Tour "$tourId" already completed. Skipping.');
      onTourComplete?.call();
      return;
    }
    await startTour(context);
  }

  /// Advances the tour to the next step.
  ///
  /// If the current step is the last step, ends the tour.
  /// Otherwise, hides the current overlay and shows the next step's overlay.
  void nextStep() {
    _currentStepIndex++;
    if (_currentStepIndex >= _steps.length) {
      endTour();
      return;
    }
    _tourOverlayController?.hideOverlay();
    _showCurrentStepOverlay();
    notifyListeners();
  }

  /// Returns to the previous tour step.
  ///
  /// Does nothing if the current step is the first step.
  /// Hides the current overlay and shows the previous step's overlay.
  void previousStep() {
    if (_currentStepIndex > 0) {
      _tourOverlayController?.hideOverlay();
      _currentStepIndex--;
      _showCurrentStepOverlay();
      notifyListeners();
    }
  }

  /// Skips the entire tour.
  ///
  /// Invokes the [onTourSkipped] callback and ends the tour.
  void skipTour() {
    onTourSkipped?.call();
    endTour();
  }

  /// Ends the current tour.
  ///
  /// Performs cleanup operations:
  /// - Hides active overlays
  /// - Resets tour state
  /// - Marks tour as completed in persistent storage
  /// - Invokes [onTourComplete] callback
  Future<void> endTour() async {
    _tourOverlayController?.hideOverlay();
    _tourOverlayController = null;
    _currentStepIndex = -1;
    await TourPersistenceService.setTourCompleted(tourId);
    onTourComplete?.call();
    notifyListeners();
  }

  /// Displays the overlay for the current tour step.
  ///
  /// This private method handles:
  /// - Finding the target widget's context and render box
  /// - Calculating position and size of the target
  /// - Creating and showing the overlay with highlight and tooltip
  ///
  /// Uses a new [TourOverlayController] for each step to ensure fresh context.
  void _showCurrentStepOverlay() {
    if (currentStep == null) {
      _tourOverlayController?.hideOverlay();
      return;
    }

    final BuildContext? targetContext = currentStep!.key.currentContext;
    if (targetContext == null) {
      debugPrint('Target widget context not found for step: ${currentStep!.title}');
      _tourOverlayController?.hideOverlay();
      return;
    }

    // Always create a new TourOverlayController to ensure a fresh context
    // This is crucial for tests where the widget tree might be re-mounted.
    _tourOverlayController = TourOverlayController();

    final RenderBox? renderBox = targetContext.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      debugPrint('Target widget render box not found for step: ${currentStep!.title}');
      _tourOverlayController?.hideOverlay();
      return;
    }

    final Rect? targetRect = GlobalKeyUtils.getWidgetRect(currentStep!.key);
    if (targetRect == null) {
      debugPrint('Target widget rect not found for step: ${currentStep!.title}');
      _tourOverlayController?.hideOverlay();
      return;
    }
    currentStep!.targetRect = targetRect;

    final overlayContent = Stack(
      children: [
        // HighlightPainter covers the entire screen
        Positioned.fill(
          child: CustomPaint(
            painter: HighlightPainter(
              highlightRect: targetRect,
              borderRadius: currentStep!.borderRadius,
              overlayColor: currentStep!.overlayColor,
              highlightColor: currentStep!.highlightColor,
              highlightShape: currentStep!.highlightShape,
            ),
          ),
        ),
        // TooltipWidget positioned relative to targetRect
        Positioned(
          top: targetRect.bottom + 10, // Position below the target
          left: targetRect.left,
          child: TooltipWidget(
            title: currentStep!.title,
            description: currentStep!.description,
            onNext: isLastStep ? endTour : nextStep,
            onPrevious: isFirstStep ? null : previousStep,
            onSkip: skipTour,
            isLastStep: isLastStep,
            isFirstStep: isFirstStep,
          ),
        ),
      ],
    );

    _tourOverlayController?.showOverlay(context: targetContext, overlayContent: overlayContent);
  }

  /// Disposes the [TourController].
  ///
  /// Hides any active overlay and nullifies the [_tourOverlayController]
  /// to prevent memory leaks.
  @override
  void dispose() {
    _tourOverlayController?.hideOverlay();
    _tourOverlayController = null;
    super.dispose();
  }
}