import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/challan_args.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChallanPaymentScreen extends StatefulWidget {
  const ChallanPaymentScreen({super.key, required this.arguments});

  final ChallanArgs? arguments;

  @override
  State<ChallanPaymentScreen> createState() => _ChallanPaymentScreenState();
}

class _ChallanPaymentScreenState extends State<ChallanPaymentScreen> {
  int loadingPercentage = 0;
  late final WebViewController controller;
  late final String urlLink;

  bool _pageFinished = false;
  String? _errorMessage;
  String? _currentUrl;
  Timer? _loadTimeoutTimer;

  static const Duration _loadTimeout = Duration(seconds: 30);

  bool get _hasValidUrl {
    final trimmed = urlLink.trim();
    if (trimmed.isEmpty) return false;
    final uri = Uri.tryParse(trimmed);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    urlLink =
        widget.arguments != null && widget.arguments!.isNewPaymentFlowEnabled
        ? '${AppConstants.paymentGatewayNewURL}${widget.arguments!.fatherCnic}/${widget.arguments!.studentId}'
        : AppConstants.paymentGatewayURL;
    log(urlLink);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: _onProgressChange,
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onWebResourceError: _onWebResourceError,
          onHttpError: _onHttpError,
        ),
      );

    if (_hasValidUrl) {
      _startLoadTimeout();
      controller.loadRequest(Uri.parse(urlLink));
    } else {
      _errorMessage =
          'The payment page is unavailable right now. Please try again later.';
    }
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
            'The payment page is taking too long to load. Please check your connection and try again.';
      });
    });
  }

  void _onProgressChange(int value) {
    if (mounted) setState(() => loadingPercentage = value);
  }

  void _onPageStarted(String url) {
    _currentUrl = url;
    if (mounted) {
      setState(() {
        loadingPercentage = 0;
        _pageFinished = false;
        _errorMessage = null;
      });
    }
    _startLoadTimeout();
  }

  void _onPageFinished(String url) {
    _loadTimeoutTimer?.cancel();
    if (mounted) {
      setState(() {
        loadingPercentage = 100;
        _pageFinished = true;
      });
    }
  }

  void _onWebResourceError(WebResourceError error) {
    log('challan web error: ${error.description}');
    // Only fail the screen for main-document errors that happen before load.
    final isMainFrame = error.isForMainFrame ?? true;
    if (!isMainFrame || _pageFinished || !mounted) return;
    _loadTimeoutTimer?.cancel();
    setState(() {
      _errorMessage =
          'Could not load the payment page. Check your connection and try again.';
    });
  }

  void _onHttpError(HttpResponseError error) {
    final status = error.response?.statusCode ?? 0;
    final failedUri = error.request?.uri.toString();
    // Only fail for the main document, not for sub-resources.
    final isMainDoc = failedUri == null || failedUri == _currentUrl;
    if (status < 400 || !isMainDoc || !mounted) return;
    _loadTimeoutTimer?.cancel();
    setState(() {
      _errorMessage = 'Could not load the payment page (HTTP $status).';
    });
  }

  Future<void> _retry() async {
    if (!_hasValidUrl) return;
    setState(() {
      _errorMessage = null;
      loadingPercentage = 0;
      _pageFinished = false;
    });
    _startLoadTimeout();
    await controller.loadRequest(Uri.parse(urlLink));
  }

  void _handleBack() {
    Provider.of<FeeChallanProvider>(
      AppNavigation.currentContext!,
      listen: false,
    ).loadOutstandingRecords();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'CHALLAN BILL', onBackPressed: _handleBack),
      body: Column(
        children: [
          if (_errorMessage == null && loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
              color: AppColors.lightRed,
            ),
          Expanded(
            child: _errorMessage != null
                ? _WebErrorState(
                    message: _errorMessage!,
                    onRetry: _hasValidUrl ? _retry : null,
                  )
                : WebViewWidget(controller: controller),
          ),
        ],
      ),
    );
  }
}

class _WebErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _WebErrorState({required this.message, this.onRetry});

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
