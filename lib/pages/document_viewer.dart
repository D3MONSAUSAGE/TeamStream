import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentViewerPage extends StatefulWidget {
  final String fileUrl;

  const DocumentViewerPage({super.key, required this.fileUrl});

  @override
  DocumentViewerPageState createState() => DocumentViewerPageState();
}

class DocumentViewerPageState extends State<DocumentViewerPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(
          "https://docs.google.com/gview?embedded=true&url=${widget.fileUrl}")); // ✅ Google Docs Viewer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Document")),
      body: WebViewWidget(controller: controller),
    );
  }
}
