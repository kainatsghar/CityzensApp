import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/utils/app_colors.dart';

/// Desktop Chrome UA so report-card CSS matches the browser layout.
const String _kDesktopChromeUserAgent =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36';

/// Read-only, in-app result viewer that matches Chrome desktop rendering.
///
/// When [autoPrint] is true, the OS system print sheet (Save as PDF) opens once
/// the report card has loaded — used as the fallback when the backend does not
/// provide a downloadable PDF.
class ResultPDFViewerScreen extends StatefulWidget {
  final String url;
  final String title;
  final bool autoPrint;

  const ResultPDFViewerScreen({
    super.key,
    required this.url,
    required this.title,
    this.autoPrint = false,
  });

  @override
  State<ResultPDFViewerScreen> createState() => _ResultPDFViewerScreenState();
}

class _ResultPDFViewerScreenState extends State<ResultPDFViewerScreen> {
  InAppWebViewController? _controller;
  int _loadingPercentage = 0;
  bool _printTriggered = false;
  bool _pageFinished = false;
  String? _errorMessage;
  Timer? _loadTimeoutTimer;

  static const Duration _printSettleDelay = Duration(milliseconds: 800);
  static const Duration _loadTimeout = Duration(seconds: 30);

  bool get _hasValidUrl {
    final trimmed = widget.url.trim();
    if (trimmed.isEmpty) return false;
    final uri = Uri.tryParse(trimmed);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  @override
  void dispose() {
    _loadTimeoutTimer?.cancel();
    super.dispose();
  }

  void _startLoadTimeout() {
    _loadTimeoutTimer?.cancel();
    _loadTimeoutTimer = Timer(_loadTimeout, () {
      if (!mounted || _pageFinished) return;
      setState(() {
        _errorMessage =
            'The report card is taking too long to load. Please check your connection and try again.';
      });
    });
  }

  final InAppWebViewSettings _settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    mediaPlaybackRequiresUserGesture: false,
    useShouldOverrideUrlLoading: false,
    preferredContentMode: UserPreferredContentMode.DESKTOP,
    userAgent: _kDesktopChromeUserAgent,
    supportZoom: true,
    builtInZoomControls: true,
    displayZoomControls: false,
    useWideViewPort: true,
    loadWithOverviewMode: false,
    horizontalScrollBarEnabled: true,
    verticalScrollBarEnabled: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    allowsInlineMediaPlayback: true,
    iframeAllowFullscreen: true,
  );

  Future<void> _retryLoad() async {
    if (!_hasValidUrl) return;
    setState(() {
      _errorMessage = null;
      _loadingPercentage = 0;
      _pageFinished = false;
      _printTriggered = false;
    });
    _startLoadTimeout();
    await _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(widget.url)));
  }

  /// Opens the native print sheet once, after content has settled.
  Future<void> _maybeAutoPrint() async {
    if (!widget.autoPrint || _printTriggered) return;
    _printTriggered = true;

    await Future.delayed(_printSettleDelay);
    final controller = _controller;
    if (!mounted || controller == null) return;

    HapticFeedback.mediumImpact();
    try {
      await controller.printCurrentPage(
        settings: PrintJobSettings(
          handledByClient: false,
          jobName: widget.title.isNotEmpty ? widget.title : 'Report Card',
        ),
      );
      if (mounted) {
        _showSnackBar(
          'Choose “Save as PDF” to keep a copy on your device.',
          icon: Icons.picture_as_pdf_rounded,
          color: AppColors.primaryBlue,
        );
      }
    } catch (e) {
      _log('printCurrentPage error: $e');
      if (mounted) {
        _showSnackBar(
          'Could not open Save as PDF. Please try again.',
          icon: Icons.error_rounded,
          color: AppColors.errorRed,
        );
      }
    }
  }

  void _showSnackBar(
    String message, {
    required IconData icon,
    required Color color,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _log(String message) {
    if (kDebugMode) {
      dev.log(message, name: 'ResultViewer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title.toUpperCase(),
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          if (_loadingPercentage < 100 && _errorMessage == null)
            LinearProgressIndicator(
              value: _loadingPercentage / 100.0,
              backgroundColor: AppColors.ultraLightGrey,
              color: AppColors.primaryBlue,
              minHeight: 3,
            ),
          Expanded(
            child: !_hasValidUrl
                ? const _ErrorState(
                    message:
                        'This result link is unavailable. Please try again later.',
                    onRetry: null,
                  )
                : _errorMessage != null
                ? _ErrorState(message: _errorMessage!, onRetry: _retryLoad)
                : InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                    initialSettings: _settings,
                    onWebViewCreated: (controller) {
                      _controller = controller;
                    },
                    onProgressChanged: (controller, progress) {
                      if (mounted) {
                        setState(() => _loadingPercentage = progress);
                      }
                    },
                    onLoadStart: (controller, url) {
                      if (mounted) {
                        setState(() {
                          _loadingPercentage = 0;
                          _pageFinished = false;
                          _errorMessage = null;
                        });
                      }
                      _startLoadTimeout();
                    },
                    onLoadStop: (controller, url) async {
                      _loadTimeoutTimer?.cancel();
                      if (mounted) {
                        setState(() {
                          _loadingPercentage = 100;
                          _pageFinished = true;
                        });
                      }
                      _log('onLoadStop');
                      _maybeAutoPrint();
                    },
                    onReceivedError: (controller, request, error) {
                      _log('load error: ${error.description}');
                      if (request.isForMainFrame == true && mounted) {
                        _loadTimeoutTimer?.cancel();
                        setState(() {
                          _errorMessage =
                              'Could not load the report card. Check your connection and try again.';
                        });
                      }
                    },
                    onReceivedHttpError: (controller, request, response) {
                      if (request.isForMainFrame == true &&
                          (response.statusCode ?? 0) >= 400 &&
                          mounted) {
                        _loadTimeoutTimer?.cancel();
                        setState(() {
                          _errorMessage =
                              'Could not load the report card (HTTP ${response.statusCode}).';
                        });
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorState({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: AppColors.softGreyText,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.neutral700,
                height: 1.4,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('RETRY'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
