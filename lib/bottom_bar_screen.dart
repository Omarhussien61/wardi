import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:wardi/menu.dart';
import 'package:webview_flutter/webview_flutter.dart';


class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {

  int selectedIndex = 0;
  final List<String> webViewList = [
      "https://wardi.me",
      "https://wardi.me/banners",
      "https://wardi.me/quick-deal",
      "https://wardi.me/branches",
      "https://wardi.me",
  ];
  late WebViewController controller;


  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.circle_grid_3x3_fill),
            label: 'الأقسام',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.ticket),
            label: 'العروض',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.location),
            label: 'فروعنا',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_list),
            label: 'القائمة',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (i) {
          controller.loadUrl(webViewList[i]);
          setState(() => selectedIndex = i);
        },
      ),
      body: selectedIndex != 4 ? SafeArea(
        child: WebView(
          initialUrl: webViewList[selectedIndex],
          onWebViewCreated: (c) {
            controller = c;
          },
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
      ) : const MenuScreen(),
    );
  }
}
