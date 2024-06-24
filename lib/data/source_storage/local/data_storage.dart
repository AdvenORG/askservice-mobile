abstract class DataStorage {
  Future<bool> write<T>(String key, T data);

  T read<T>(String key);

  Future<bool> delete(String key);

  Future<bool> clear();
}
