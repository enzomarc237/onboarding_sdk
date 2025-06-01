/// This file provides the [TourPersistenceService] for managing the completion
/// status of feature tours using `shared_preferences`.
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for persisting the completion status of feature tours.
///
/// This service uses `shared_preferences` to store a boolean flag indicating
/// whether a specific tour has been completed by the user.
class TourPersistenceService {
  /// The [SharedPreferences] instance used for reading and writing tour completion data.
  static late SharedPreferences _prefs;

  /// Initializes the [TourPersistenceService] by getting an instance of [SharedPreferences].
  ///
  /// This method must be called before any other methods of this service are used.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Marks a specific tour as completed.
  ///
  /// The completion status is stored using a unique key derived from the [tourId].
  ///
  /// Parameters:
  /// - [tourId]: The unique identifier of the tour to mark as completed.
  static Future<void> setTourCompleted(String tourId) async {
    await _prefs.setBool('tour_completed_$tourId', true);
  }

  /// Checks if a specific tour has been completed.
  ///
  /// Returns `true` if the tour has been marked as completed, `false` otherwise.
  ///
  /// Parameters:
  /// - [tourId]: The unique identifier of the tour to check.
  static Future<bool> isTourCompleted(String tourId) async {
    return _prefs.getBool('tour_completed_$tourId') ?? false;
  }

  /// Clears the completion status for a specific tour.
  ///
  /// This effectively resets the tour's completion status, allowing it to be
  /// shown again.
  ///
  /// Parameters:
  /// - [tourId]: The unique identifier of the tour whose completion status should be cleared.
  static Future<void> clearTourCompletion(String tourId) async {
    await _prefs.remove('tour_completed_$tourId');
  }
}