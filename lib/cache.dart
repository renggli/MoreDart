/// Collection of different caching strategies and their expiry policy.
import 'dart:async' show Future, FutureOr;

import 'src/cache/empty.dart';
import 'src/cache/expiry.dart';
import 'src/cache/fifo.dart';
import 'src/cache/loader.dart';
import 'src/cache/lru.dart';

export 'src/cache/delegate.dart';
export 'src/cache/loader.dart';

abstract class Cache<K, V> {
  /// Constructs an empty or null cache, useful mostly for testing.
  ///
  /// The [loader] defines the function to construct items for the cache.
  factory Cache.empty({required Loader<K, V> loader}) =>
      EmptyCache<K, V>(loader);

  /// Constructs an expiry cache.
  ///
  /// The [loader] defines the function to construct items for the cache.
  ///
  /// [updateExpiry] is the maximal duration after which an updated item
  /// exists. [accessExpiry] is the maximal duration an item does not
  /// expire without being accessed. Whatever happens last, causes the
  /// expiration.
  ///
  /// Note that cached items do not magically disappear when they expire.
  /// Manually call [reap()], or setup a timer to regularly free items.
  factory Cache.expiry(
      {required Loader<K, V> loader,
      Duration? updateExpiry,
      Duration? accessExpiry}) {
    if (updateExpiry == null && accessExpiry == null) {
      throw ArgumentError(
          "Either 'updateExpiry' or 'accessExpiry' must be provided.");
    }
    if (updateExpiry != null && updateExpiry.inMicroseconds <= 0) {
      throw ArgumentError("Negative 'updateExpire' provided.");
    }
    if (accessExpiry != null && accessExpiry.inMicroseconds <= 0) {
      throw ArgumentError("Negative 'accessExpiry' provided.");
    }
    return ExpiryCache<K, V>(
        loader, updateExpiry ?? Duration.zero, accessExpiry ?? Duration.zero);
  }

  /// Constructs a First-in/First-out (FIFO) cache.
  ///
  /// The [loader] defines the function to construct items for the cache; and
  /// [maximumSize] defines the maximum number of items cached.
  factory Cache.fifo({required Loader<K, V> loader, int maximumSize = 100}) {
    if (maximumSize <= 0) {
      throw ArgumentError("Non-positive 'maximumSize' provided.");
    }
    return FifoCache<K, V>(loader, maximumSize);
  }

  /// Constructs a Least Recently Used (LRU) cache.
  ///
  /// The [loader] defines the function to construct items for the cache; and
  /// [maximumSize] defines the maximum number of items cached.
  factory Cache.lru({required Loader<K, V> loader, int maximumSize = 100}) {
    if (maximumSize <= 0) {
      throw ArgumentError("Non-positive 'maximumSize' provided.");
    }
    return LruCache<K, V>(loader, maximumSize);
  }

  /// Unnamed default constructor.
  const Cache();

  /// Returns the value associated with the [key], otherwise `null`.
  Future<V?> getIfPresent(K key);

  /// Returns the value associated with the [key].
  Future<V> get(K key);

  /// Stores the [value] associated with the [key].
  Future<V> set(K key, FutureOr<V> value);

  /// Number of currently cached values.
  Future<int> size();

  /// Discards any cached value with the [key].
  Future<void> invalidate(K key);

  /// Discards all cached values.
  Future<void> invalidateAll();

  /// Returns the number of reaped items.
  Future<int> reap();
}
