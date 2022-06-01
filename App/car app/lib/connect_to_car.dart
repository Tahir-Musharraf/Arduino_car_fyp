import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';


class ConnectToCar extends StatefulWidget {
  String ip;
  ConnectToCar({Key? key,required this.ip}) : super(key: key);

  @override
  State<ConnectToCar> createState() => _ConnectToCarState();
}

class _ConnectToCarState extends State<ConnectToCar> {

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return  WebView(
      initialUrl: 'http://${widget.ip}',
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

}
