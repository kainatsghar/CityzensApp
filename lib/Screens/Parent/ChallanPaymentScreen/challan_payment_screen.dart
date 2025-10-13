import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChallanPaymentScreen extends StatefulWidget {
  const ChallanPaymentScreen({super.key});

  @override
  State<ChallanPaymentScreen> createState() => _ChallanPaymentScreenState();
}

class _ChallanPaymentScreenState extends State<ChallanPaymentScreen> {
  int loadingPercentage = 0;
  late WebViewController controller;

  void onProgressChange(int value) {
    if (mounted) {
      setState(() => loadingPercentage = value);
    }
  }

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) => onProgressChange(progress),
          onPageStarted: (String url) => onProgressChange(loadingPercentage),
          onPageFinished: (String url) => onProgressChange(loadingPercentage),
        ),
      )
      ..loadRequest(
        Uri.parse(
          localDataProvider.userData!.userType == 'Parent'
              ? '${AppConstants.paymentGatewayURLForParent}${localDataProvider.userData!.userName}'
              : AppConstants.paymentGatewayURL,
        ),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'CHALLAN BILL'),
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
