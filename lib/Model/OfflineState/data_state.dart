/// Represents the different states of data in an offline-first application
/// This allows the UI to display appropriate messages based on data availability
abstract class DataState<T> {
  const DataState();

  /// Returns true if this state represents successfully loaded data
  bool get isSuccess => this is DataLoaded;

  /// Returns true if data is currently being loaded/synced
  bool get isLoading => this is DataLoading;

  /// Returns true if the data is stale (loaded from offline cache)
  bool get isStale => this is DataLoaded ? (this as DataLoaded).isStale : false;

  /// Returns true if offline
  bool get isOffline => this is OfflineData || this is FirstRunError;

  /// Get the data if available
  T? get data {
    if (this is DataLoaded) {
      return (this as DataLoaded).data;
    }
    return null;
  }

  /// Get the error message if available
  String? get errorMessage {
    if (this is DataError) {
      return (this as DataError).message;
    } else if (this is FirstRunError) {
      return (this as FirstRunError).message;
    }
    return null;
  }
}

/// Initial load state
class DataLoading<T> extends DataState<T> {
  final T? previousData; // Can hold previously cached data while loading

  const DataLoading({this.previousData});

  @override
  String toString() => 'DataLoading(previousData: $previousData)';
}

/// Successfully loaded data
class DataLoaded<T> extends DataState<T> {
  final T data;
  final bool
  isStale; // true if loaded from local cache and not yet synced with server
  final DateTime? lastSyncedAt; // Timestamp of the last successful sync

  const DataLoaded(this.data, {this.isStale = false, this.lastSyncedAt});

  @override
  String toString() =>
      'DataLoaded(data: $data, isStale: $isStale, lastSyncedAt: $lastSyncedAt)';
}

/// Error while loading online data
class DataError<T> extends DataState<T> {
  final String message;
  final T? cachedData; // Can hold previously cached data as fallback

  const DataError(this.message, {this.cachedData});

  @override
  String toString() => 'DataError(message: $message, cachedData: $cachedData)';
}

/// Offline data (showing local cache)
class OfflineData<T> extends DataState<T> {
  final T data;
  final DateTime? lastSyncedAt;

  const OfflineData(this.data, {this.lastSyncedAt});

  @override
  String toString() => 'OfflineData(data: $data, lastSyncedAt: $lastSyncedAt)';
}

/// First run error - no local cache and no internet
class FirstRunError<T> extends DataState<T> {
  final String message;

  const FirstRunError(this.message);

  @override
  String toString() => 'FirstRunError(message: $message)';
}
