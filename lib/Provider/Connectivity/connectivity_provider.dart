import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Provider to track network connectivity status
///
/// Usage in app initialization:
/// ```dart
/// ChangeNotifierProvider(
///   create: (_) => ConnectivityProvider()..initializeConnectivity(),
///   child: YourApp(),
/// ),
/// ```
///
/// Usage in widgets:
/// ```dart
/// Consumer<ConnectivityProvider>(
///   builder: (context, connectivity, _) {
///     if (connectivity.isOnline) {
///       return SyncingDataView();
///     } else {
///       return OfflineView();
///     }
///   },
/// ),
/// ```
class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;
  bool _isLoading = true;

  bool get isOnline => _isOnline;
  bool get isLoading => _isLoading;

  /// Initialize connectivity monitoring
  Future<void> initializeConnectivity() async {
    try {
      // Check initial connectivity status (returns List<ConnectivityResult> in 7.0.0+)
      final results = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(results);

      // Listen to future connectivity changes (stream now emits List<ConnectivityResult>)
      _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
          _updateConnectivityStatus(results);
        },
        onError: (dynamic error) {
          print('ConnectivityProvider Error: $error');
          _isOnline = false;
          notifyListeners();
        },
      );
    } catch (e) {
      print('ConnectivityProvider Initialization Error: $e');
      _isOnline = true; // Assume online if we can't determine
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;

    // Check if device has any active internet connection
    // Results list contains connectivity types. If ANY result is not 'none', we're online.
    // Examples:
    // - [ConnectivityResult.wifi] → online
    // - [ConnectivityResult.mobile] → online
    // - [ConnectivityResult.none] → offline
    // - [] → offline
    _isOnline = results.any((result) => result != ConnectivityResult.none);
    _isLoading = false;

    // Only notify if status changed
    if (wasOnline != _isOnline) {
      notifyListeners();
    }
  }

  /// Get human-readable connection status
  String getStatusText() {
    if (_isLoading) {
      return 'Checking connection...';
    }
    return _isOnline ? 'Online' : 'Offline';
  }
}
