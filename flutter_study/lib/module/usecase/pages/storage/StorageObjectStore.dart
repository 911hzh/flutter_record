// ignore_for_file: file_names

abstract class StorageObjectStore<T> {
  String get name;

  String get storageDescription;

  Future<void> save(T value);

  Future<T?> read();

  Future<void> delete();
}
