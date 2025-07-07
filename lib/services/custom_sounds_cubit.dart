import "dart:async";
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CustomSoundsCubit extends Cubit<List<String>> {
  CustomSoundsCubit() : super([]) {
    unawaited(_loadSounds());
  }

  Future<Directory> get _customDir async {
    final dir = await getApplicationDocumentsDirectory();
    final custom = Directory(join(dir.path, 'custom_alarm_sounds'));
    if (!await custom.exists()) {
      await custom.create(recursive: true);
    }
    return custom;
  }

  Future<void> _loadSounds() async {
    final dir = await _customDir;
    final files = dir.listSync().whereType<File>().map((f) => f.path).toList();
    emit(files);
  }

  Future<String?> addSound(String path) async {
    final dir = await _customDir;
    final newPath = join(dir.path, basename(path));
    await File(path).copy(newPath);
    await _loadSounds();
    return newPath;
  }

  Future<void> clearSounds() async {
    final dir = await _customDir;
    if (await dir.exists()) {
      await for (final entity in dir.list()) {
        if (entity is File) {
          await entity.delete();
        }
      }
    }
    await _loadSounds();
  }
}
