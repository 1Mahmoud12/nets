import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nets/core/component/custom_app_bar.dart';
import 'package:nets/core/component/loadsErros/loading_widget.dart';
import 'package:nets/core/utils/app_images.dart';

import '../network/local/cache.dart';
import '../utils/constant_gaping.dart';

class MyInAppWebView extends StatefulWidget {
  final String authorizationUrl;
  final BuildContext scaffoldContext;
  final void Function(String)? onPageFinished;
  final void Function(String)? onPageStarted;
  final void Function(bool, Object?)? onPopInvokedWithResult;

  const MyInAppWebView({
    super.key,
    required this.authorizationUrl,
    required this.scaffoldContext,
    this.onPageFinished,
    this.onPopInvokedWithResult,
    this.onPageStarted,
  });

  @override
  State<MyInAppWebView> createState() => _MyInAppWebViewState();
}

class _MyInAppWebViewState extends State<MyInAppWebView> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  bool _isLoading = true;
  bool _paymentProcessed = false;

  late InAppWebViewSettings options;

  @override
  void initState() {
    super.initState();
    _initializeWebViewSettings();
  }

  void _initializeWebViewSettings() {
    options = InAppWebViewSettings(
      javaScriptCanOpenWindowsAutomatically: true,
      mediaPlaybackRequiresUserGesture: false,

      // Navigation settings
      useShouldOverrideUrlLoading: true,

      // Security settings - More permissive for payment processing
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      allowsInlineMediaPlayback: true,

      // iOS specific settings
      allowsLinkPreview: false,
      isFraudulentWebsiteWarningEnabled: false,
      // User agent
      userAgent: Platform.isIOS
          ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1'
          : null,

      // Disable problematic features
      supportZoom: false,
      builtInZoomControls: false,
    );
  }

  void _handlePaymentResult(String url, String type) {
    if (_paymentProcessed) return;

    setState(() {
      _paymentProcessed = true;
    });

    log('Payment $type detected: $url');

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && widget.scaffoldContext.mounted) {
        if (widget.onPopInvokedWithResult != null) {
          widget.onPopInvokedWithResult!(true, type);
        }
        Navigator.of(widget.scaffoldContext).pop(type);
      }
    });
  }

  @override
  void dispose() {
    webViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (widget.onPopInvokedWithResult != null) {
            widget.onPopInvokedWithResult!(false, null);
          }
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: customAppBar(
          stopLeading: true,
          actions: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios, color: darkModeValue ? Colors.white : null),
              ),
              w10,
              Image.asset(AppImages.smallAppLogo),
            ],
          ),
          context: context,
        ),
        body: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(widget.authorizationUrl)),
              initialSettings: options,
              onWebViewCreated: (controller) {
                webViewController = controller;
                log('WebView created successfully');
              },
              onLoadStart: (controller, url) {
                if (url != null && !_paymentProcessed) {
                  setState(() {
                    _isLoading = true;
                  });

                  log('Page started loading: $url');
                  widget.onPageStarted?.call(url.toString());

                  final urlString = url.toString().toLowerCase();

                  // Check for payment results
                  if (urlString.contains('payment-success') || urlString.contains('paymentsuccess')) {
                    _handlePaymentResult(url.toString(), 'success');
                  } else if (urlString.contains('payment-fail') ||
                      urlString.contains('paymentfail') ||
                      urlString.contains('payment-error') ||
                      urlString.contains('paymenterror')) {
                    _handlePaymentResult(url.toString(), 'failed');
                  }
                }
              },
              onLoadStop: (controller, url) async {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }

                if (url != null && !_paymentProcessed && mounted) {
                  log('Page finished loading: $url');
                  widget.onPageFinished?.call(url.toString());

                  final urlString = url.toString().toLowerCase();

                  // Double-check for payment results on load stop
                  if (urlString.contains('payment-success') || urlString.contains('paymentsuccess')) {
                    _handlePaymentResult(url.toString(), 'success');
                  } else if (urlString.contains('payment-fail') ||
                      urlString.contains('paymentfail') ||
                      urlString.contains('payment-error') ||
                      urlString.contains('paymenterror')) {
                    _handlePaymentResult(url.toString(), 'failed');
                  }
                }
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request.url!;
                final urlString = uri.toString();

                log('Navigation request: $urlString');

                // Always allow navigation to prevent Frame load interrupted error
                return NavigationActionPolicy.ALLOW;
              },
              onReceivedServerTrustAuthRequest: (controller, serverTrustAuthRequest) async {
                // Handle SSL certificate issues
                log('SSL Certificate request for: ${serverTrustAuthRequest.protectionSpace.host}');

                // For your domain and payment domains, accept the certificate
                final host = serverTrustAuthRequest.protectionSpace.host;
                if (host.contains('almamlka01jo2025.dev2.dot.jo') || host.contains('payments.tap.company') || host.contains('m-clean.net')) {
                  return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                }

                return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
              },
              onConsoleMessage: (controller, consoleMessage) {
                log('Console: ${consoleMessage.message}');
              },
              onProgressChanged: (controller, progress) {
                log('Loading progress: $progress%');
              },
              onReceivedHttpError: (controller, request, errorResponse) {
                log('HTTP Error: ${errorResponse.statusCode} - ${errorResponse.reasonPhrase}');
              },
              onReceivedError: (controller, request, error) {
                log('WebView Error: ${error.description}');

                // Handle specific error codes
                if (error.type == WebResourceErrorType.CANNOT_LOAD_FROM_NETWORK) {
                  log('Frame load interrupted - this might be normal for redirects');
                  // Don't show loading false for this error as it might be a redirect
                  return;
                }

                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              onNavigationResponse: (controller, navigationResponse) async {
                final url = navigationResponse.response?.url?.toString() ?? '';
                log('Navigation response: $url');

                // Check response status
                final statusCode = navigationResponse.response?.statusCode ?? 0;
                if (statusCode >= 400) {
                  log('HTTP Error response: $statusCode');
                }

                return NavigationResponseAction.ALLOW;
              },
            ),
            // Loading indicator
            if (_isLoading && !_paymentProcessed) const Center(child: LoadingWidget()),
          ],
        ),
      ),
    );
  }
}
