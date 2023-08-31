import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebPageScreen extends StatefulWidget {
  final String url;

  WebPageScreen({required this.url});

  @override
  _WebPageScreenState createState() => _WebPageScreenState();
}

class _WebPageScreenState extends State<WebPageScreen> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff388e3c),
        title: Text('Transactions'),
        titleTextStyle: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w500,
        ),
        toolbarHeight: 65,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            useOnLoadResource: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
        ),
        onLoadStop: (controller, url) async {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          final viewportWidth = screenWidth.toInt();
          final viewportHeight = screenHeight.toInt();

          await controller.evaluateJavascript(
            source:
            'document.querySelector("meta[name=viewport]").setAttribute("content", "width=$viewportWidth, height=$viewportHeight, initial-scale=1.0, maximum-scale=1.0, user-scalable=no");',
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _webViewController?.reload();
        },
        child: Icon(Icons.refresh),
        backgroundColor: Color(0xff388e3c),
      ),
    );
  }
}
