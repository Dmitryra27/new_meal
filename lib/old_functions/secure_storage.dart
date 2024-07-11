import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
// Использование:
/*
final secureStorage = SecureStorage();
// Сохранение API key:
await
secureStorage.write
('apiKey
'
,
'
your_api_key
'
);
// Чтение API key:
final apiKey = await secureStorage.read('apiKey');
// Удаление API key:
await secureStorage.delete('apiKey');
*/
