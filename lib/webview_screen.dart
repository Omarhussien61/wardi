import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:webview_flutter/webview_flutter.dart';



class WebViewScreen extends StatefulWidget {
  final String url;
  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String get url => widget.url;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: Platform.isIOS ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_2 like Mac OS X) AppleWebKit/605.1.15' +
            ' (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1' :
        'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) ' 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
        navigationDelegate: (NavigationRequest request)async{
          debugPrint('URL IS ${request.url}');
          if(request.url.contains("https://api.whatsapp.com/")){
            await FlutterOpenWhatsapp.sendSingleMessage("+966543504864", "Hello");
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
