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
  late WebViewController controller;
  late String urlLink;

  void onProgressChange(int value) {
    if (mounted) {
      setState(() => loadingPercentage = value);
    }
  }

  @override
  void initState() {
    urlLink =
        widget.arguments != null && widget.arguments!.isNewPaymentFlowEnabled
        ? '${AppConstants.paymentGatewayNewURL}${widget.arguments!.fatherCnic}/${widget.arguments!.studentId}'
        : AppConstants.paymentGatewayURL;
    log(urlLink);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) => onProgressChange(progress),
          onPageStarted: (String url) => onProgressChange(loadingPercentage),
          onPageFinished: (String url) => onProgressChange(loadingPercentage),
        ),
      )
      ..loadRequest(Uri.parse(urlLink));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'CHALLAN BILL',
        onBackPressed: () {
          var provider = Provider.of<FeeChallanProvider>(
            AppNavigation.currentContext!,
            listen: false,
          );

          provider.loadOutstandingRecords();
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
              color: AppColors.lightRedColor,
            ),
          Expanded(child: WebViewWidget(controller: controller)),
        ],
      ),
    );
  }
}
