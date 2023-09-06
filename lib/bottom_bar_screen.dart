import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wardi/menu.dart';
import 'package:webview_flutter/webview_flutter.dart';


class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {

  bool canBack=false;
  int selectedIndex = 0;
  final List<String> webViewList = [
      "https://wardi.me",
      "https://wardi.me/banners",
      "https://wardi.me/cart",
      "https://wardi.me/best-offers",
      "https://wardi.me/our-stores",
  ];
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
   // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
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
              icon: Icon(CupertinoIcons.shopping_cart),
              label: 'السله',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.ticket),
              label: 'العروض',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.location),
              label: 'فروعنا',
            ),

          ],
          currentIndex: selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: (i) {
            controller.loadUrl(webViewList[i]);
            setState(() => selectedIndex = i);
          },
        ),
        appBar: canBack?AppBar(backgroundColor: Colors.white,title: Image.asset('assets/logo.png',
          height:50,
          width:50,
        ),centerTitle: true,

        leading: canBack
            ? IconButton(
          onPressed: () {
            controller.goBack();
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Color.fromRGBO(220, 108, 163, 1),
          ),
        )
            : Container(),
        actions: [
          IconButton(
          onPressed: () {
            controller.loadUrl( webViewList[selectedIndex]);
          },
          icon: Icon(
            Icons.refresh,
            color: Color.fromRGBO(220, 108, 163, 1),
          ),
        )],):null,
        body: SafeArea(
          child: WebView(
            initialUrl: webViewList[selectedIndex],
            onWebViewCreated: (c) {
              controller = c;

            },
            onPageStarted: (String url)  {
              controller.canGoBack().then((value) =>
                  setState(() {
                    canBack = value;
                  }));

            },
          //  javascriptMode: JavascriptMode.unrestricted,
            userAgent: Platform.isIOS ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_2 like Mac OS X) AppleWebKit/605.1.15' +
                ' (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1' :
            'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) ' 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
            navigationDelegate: (NavigationRequest request)async{
              debugPrint('URL IS ${request.url}');
              if(request.url.contains("https://api.whatsapp.com/")){
                //await FlutterOpenWhatsapp.sendSingleMessage("+966543504864", "Hello");
              }
              return NavigationDecision.navigate;
            },
          ),
        ) ,

      ),
    );
  }
  Future<bool> _exitApp(BuildContext context) async {
    if (await controller.canGoBack()) {
      print("onwill goback");
      controller.goBack();
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
}
