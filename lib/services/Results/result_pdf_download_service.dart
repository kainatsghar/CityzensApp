import 'dart:developer' as dev;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tcs_app/model/Results/all_pdf_results_response.dart';
import 'package:tcs_app/services/FirebaseServices/app_analytics_service.dart';
import 'package:tcs_app/services/Results/result_pdf_cache_service.dart';

/// Thrown when the backend does not provide a downloadable PDF for a result.
///
/// Callers should fall back to the system print sheet (view + Save as PDF).
class NoServerPdfException implements Exception {
  final String message;
  const NoServerPdfException([
    this.message = 'No downloadable PDF available for this result.',
  ]);

  @override
  String toString() => 'NoServerPdfException: $message';
}

/// Downloads a result as a PDF from the backend and caches it locally.
///
/// The backend is expected to serve a real `application/pdf` at
/// [PDFResultItem.pdfUrl]. When it does not, [NoServerPdfException] is thrown
/// and the caller uses the system print fallback instead.
class ResultPdfDownloadService {
  ResultPdfDownloadService._();

  static const Duration _httpTimeout = Duration(seconds: 30);

  static Future<SavedResultPdf> download(
    PDFResultItem item, {
    bool forceRedownload = false,
  }) async {
    final cacheKey = ResultPdfCacheService.buildKey(item);

    if (!forceRedownload) {
      final cached = await ResultPdfCacheService.getEntry(cacheKey);
      if (cached != null) {
        await AppAnalyticsService.logResultPdfEvent(
          'download_cache_hit',
          stage: 'cache',
        );
        return cached;
      }
    }

    final pdfUrl = item.pdfUrl?.trim();
    if (pdfUrl == null || pdfUrl.isEmpty) {
      throw const NoServerPdfException();
    }

    await AppAnalyticsService.logResultPdfEvent(
      'download_started',
      stage: 'server_pdf',
    );

    try {
      final pdfBytes = await _getWithRetry(pdfUrl);
      if (!_looksLikePdf(pdfBytes)) {
        throw const NoServerPdfException('PDFURL did not return a PDF file.');
      }

      final saved = await ResultPdfCacheService.save(
        cacheKey: cacheKey,
        bytes: pdfBytes,
        title: item.displayName,
        sourceUrl: pdfUrl,
        studentId: item.studentId?.toString(),
      );

      await AppAnalyticsService.logResultPdfEvent(
        'download_success',
        stage: 'server_pdf',
        byteCount: pdfBytes.length,
      );
      return saved;
    } on NoServerPdfException {
      rethrow;
    } catch (e, st) {
      _log('Download failed: $e');
      await AppAnalyticsService.logResultPdfEvent(
        'download_failed',
        stage: 'server_pdf',
        errorType: e.runtimeType.toString(),
      );
      await FirebaseCrashlytics.instance.recordError(
        e,
        st,
        reason: 'result_pdf_download',
        information: ['cacheKey=$cacheKey'],
      );
      rethrow;
    }
  }

  static Future<Uint8List> _getWithRetry(String url) async {
    Object? lastError;
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(_httpTimeout);
        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw Exception('HTTP ${response.statusCode}');
        }
        return response.bodyBytes;
      } catch (e) {
        lastError = e;
        if (attempt == 0) {
          await Future.delayed(const Duration(milliseconds: 600));
        }
      }
    }
    throw lastError ?? Exception('Failed to download PDF');
  }

  static bool _looksLikePdf(Uint8List bytes) {
    if (bytes.length < 5) return false;
    return bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46;
  }

  static void _log(String message) {
    if (kDebugMode) {
      dev.log(message, name: 'ResultPdfDownload');
    }
  }
}
