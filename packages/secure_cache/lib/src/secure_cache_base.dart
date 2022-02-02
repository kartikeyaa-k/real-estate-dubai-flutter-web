library cache;

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// {@template cache_client}
/// An in-memory cache client.
/// {@endtemplate}
class SecureCache {
  /// {@macro cache_client}
  SecureCache();
  final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();

  /// Writes the provide [key], [value] pair to the in-memory cache.
  void write<T extends SecureCacheModel>({required String key, required T value}) {
    _flutterSecureStorage.write(key: key, value: json.encode(value.toJson()));
  }

  /// Looks up the value for the provided [key].
  /// takes [instance] of object T and converts string to [T]
  /// Defaults to `null` if no value exists for the provided key.
  Future<T?> read<T extends SecureCacheModel>({required String key, required T instance}) async {
    final value = await _flutterSecureStorage.read(key: key);
    var jsonDecodedValue = json.decode(value ?? "{}");
    T object = instance.fromJson(jsonDecodedValue);
    if (object is T) return object;
    return null;
  }
}

/// abstraction to use any model class with [SecureCache]
/// extends [Equatable] use [props] to enable equatable
abstract class SecureCacheModel<T> extends Equatable {
  const SecureCacheModel();

  Map<String, dynamic> toJson();

  T fromJson(Map<String, dynamic> json);
}
