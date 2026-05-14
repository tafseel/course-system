import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  Future<String> uploadFile({
    required File file,
    required String path,
    String? fileName,
  }) async {
    final ref = _storage.ref('$path/${fileName ?? _uuid.v4()}');
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<String> uploadPdf({
    required File file,
    required String schoolId,
    required String courseId,
    String? subjectId,
    String? chapterId,
  }) async {
    final path = 'schools/$schoolId/courses/$courseId'
        '${subjectId != null ? '/subjects/$subjectId' : ''}'
        '${chapterId != null ? '/chapters/$chapterId' : ''}';
    return await uploadFile(file: file, path: path);
  }

  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {}
  }
}
