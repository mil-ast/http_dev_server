import 'dart:io';

abstract interface class IDatabase {
  Future<String> read();
  Future<void> save(String contents);
}

class Database implements IDatabase {
  final File _dbFile;

  Database(String path) : _dbFile = File(path) {
    if (!_dbFile.existsSync()) {
      _dbFile.createSync(recursive: true);
    }
  }

  @override
  Future<String> read() {
    return _dbFile.readAsString();
  }

  @override
  Future<void> save(String contents) async {
    await _dbFile.writeAsString(contents);
  }
}
