import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'login.dart';

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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For example, reload the web page
          _webViewController?.reload();
        },
        child: Icon(Icons.refresh),
        backgroundColor: Color(0xff388e3c),
      ),
    );
  }
}
