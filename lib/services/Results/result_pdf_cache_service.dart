import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcs_app/model/Results/all_pdf_results_response.dart';
import 'package:tcs_app/services/LocalCache/local_cache_manager.dart';

/// Metadata for a locally cached result PDF.
class SavedResultPdf {
  final String cacheKey;
  final String localPath;
  final String title;
  final String? sourceUrl;
  final String downloadedAt;
  final int bytes;
  final String? studentId;

  const SavedResultPdf({
    required this.cacheKey,
    required this.localPath,
    required this.title,
    required this.downloadedAt,
    required this.bytes,
    this.sourceUrl,
    this.studentId,
  });

  File get file => File(localPath);

  Map<String, dynamic> toJson() => {
        'cacheKey': cacheKey,
        'localPath': localPath,
        'title': title,
        'sourceUrl': sourceUrl,
        'downloadedAt': downloadedAt,
        'bytes': bytes,
        'studentId': studentId,
      };

  factory SavedResultPdf.fromJson(Map<String, dynamic> json) {
    return SavedResultPdf(
      cacheKey: json['cacheKey'] as String,
      localPath: json['localPath'] as String,
      title: json['title'] as String? ?? 'Report Card',
      sourceUrl: json['sourceUrl'] as String?,
      downloadedAt: json['downloadedAt'] as String? ?? '',
      bytes: json['bytes'] as int? ?? 0,
      studentId: json['studentId']?.toString(),
    );
  }
}

/// Persists result PDFs under app documents and indexes them in SharedPreferences.
class ResultPdfCacheService {
  ResultPdfCacheService._();

  static const String _indexCacheKey = 'result_pdf_index';
  static const String _indexDataType = 'result_pdf_index_v1';

  /// Stable key: prefer [PDFResultItem.documentId], else student/session/term/class.
  static String buildKey(PDFResultItem item) {
    final docId = item.documentId?.trim();
    if (docId != null && docId.isNotEmpty) return docId;
    return '${item.studentId}_${item.sessionId}_${item.termGroupId}_${item.classId}';
  }

  static Future<Directory> _pdfDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/result_pdfs');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<Map<String, SavedResultPdf>> _loadIndex() async {
    final raw = await LocalCacheManager.getData(key: _indexCacheKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (key, value) => MapEntry(
          key,
          SavedResultPdf.fromJson(Map<String, dynamic>.from(value as Map)),
        ),
      );
    } catch (e) {
      debugPrint('ResultPdfCacheService: failed to parse index: $e');
      return {};
    }
  }

  static Future<void> _saveIndex(Map<String, SavedResultPdf> index) async {
    final encoded = jsonEncode(
      index.map((key, value) => MapEntry(key, value.toJson())),
    );
    await LocalCacheManager.saveData(
      key: _indexCacheKey,
      jsonData: encoded,
      dataType: _indexDataType,
    );
  }

  static Future<bool> isDownloaded(String cacheKey) async {
    final file = await getLocalFile(cacheKey);
    return file != null;
  }

  static Future<SavedResultPdf?> getEntry(String cacheKey) async {
    final index = await _loadIndex();
    final entry = index[cacheKey];
    if (entry == null) return null;
    if (!await File(entry.localPath).exists()) {
      index.remove(cacheKey);
      await _saveIndex(index);
      return null;
    }
    return entry;
  }

  static Future<File?> getLocalFile(String cacheKey) async {
    final entry = await getEntry(cacheKey);
    if (entry == null) return null;
    final file = entry.file;
    return await file.exists() ? file : null;
  }

  /// Returns a snapshot of cache keys that currently have a local file.
  static Future<Set<String>> downloadedKeys() async {
    final index = await _loadIndex();
    final keys = <String>{};
    var dirty = false;
    for (final entry in index.entries) {
      if (await File(entry.value.localPath).exists()) {
        keys.add(entry.key);
      } else {
        dirty = true;
      }
    }
    if (dirty) {
      index.removeWhere((key, value) => !keys.contains(key));
      await _saveIndex(index);
    }
    return keys;
  }

  static Future<SavedResultPdf> save({
    required String cacheKey,
    required Uint8List bytes,
    required String title,
    String? sourceUrl,
    String? studentId,
  }) async {
    final dir = await _pdfDirectory();
    final safeKey = cacheKey.replaceAll(RegExp(r'[^\w\-.]'), '_');
    final file = File('${dir.path}/$safeKey.pdf');
    await file.writeAsBytes(bytes, flush: true);

    final saved = SavedResultPdf(
      cacheKey: cacheKey,
      localPath: file.path,
      title: title,
      sourceUrl: sourceUrl,
      downloadedAt: DateTime.now().toIso8601String(),
      bytes: bytes.length,
      studentId: studentId,
    );

    final index = await _loadIndex();
    index[cacheKey] = saved;
    await _saveIndex(index);
    return saved;
  }

  static Future<void> delete(String cacheKey) async {
    final index = await _loadIndex();
    final entry = index.remove(cacheKey);
    await _saveIndex(index);
    if (entry != null) {
      final file = File(entry.localPath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  /// Removes all cached PDFs for a student (call on logout).
  static Future<void> deleteForStudent(String studentId) async {
    final index = await _loadIndex();
    final toRemove = <String>[];
    for (final entry in index.entries) {
      if (entry.value.studentId == studentId ||
          entry.key.startsWith('${studentId}_')) {
        toRemove.add(entry.key);
      }
    }
    for (final key in toRemove) {
      final entry = index.remove(key);
      if (entry != null) {
        final file = File(entry.localPath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    await _saveIndex(index);
  }

  /// Clears the entire PDF index and files.
  static Future<void> clearAll() async {
    final index = await _loadIndex();
    for (final entry in index.values) {
      final file = File(entry.localPath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    await LocalCacheManager.clearCache(key: _indexCacheKey);
    try {
      final dir = await _pdfDirectory();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('ResultPdfCacheService: clearAll dir cleanup: $e');
    }
  }
}
