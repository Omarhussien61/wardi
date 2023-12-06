import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wardi/menu.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';


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
      "https://wardi.me/cart",
      "https://wardi.me/best-offers",
      "https://wardi.me/our-stores",
  ];
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
                controller.canGoBack().then((value) =>
                    setState(() {
                      canBack = value;
                    }));
                    },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
                debugPrint('URL IS ${request.url}');
                if(request.url.contains("https://api.whatsapp.com/")){
                  _controller.goBack();
                  launch( "https://wa.me/966543504864").then((value) {
                    _controller.goBack();
                    _controller.loadRequest(Uri.parse(webViewList[selectedIndex]));
                  });


                  // await FlutterOpenWhatsapp.sendSingleMessage("+966543504864", "Hello");
                }else if(request.url.startsWith("https://wardi.me/cart")){
                  setState(() {
                    canBack=false;
                  });
                }else if(request.url.startsWith("https://wardi.me/best-offers")){
                  setState(() {
                    canBack=false;
                  });
                }else if(request.url.startsWith("https://wardi.me/our-stores")){
                  setState(() {
                    canBack=false;
                  });
                }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(webViewList[selectedIndex]));


    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
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
            _controller.loadRequest(Uri.parse(webViewList[i]));
            setState(() => selectedIndex = i);
          },
        ),
        // appBar: canBack?
        // AppBar(
        //   backgroundColor: Colors.white,title: Image.asset('assets/logo.png',
        //   height:50,
        //   width:50,
        // ),centerTitle: true,
        //
        // leading: canBack
        //     ? IconButton(
        //   onPressed: () {
        //     _controller.goBack();
        //   },
        //   icon: Icon(
        //     Icons.arrow_back_outlined,
        //     color: Color.fromRGBO(220, 108, 163, 1),
        //   ),
        // )
        //     : Container(),
        // actions: [
        //   IconButton(
        //   onPressed: () {
        //     _controller.loadRequest(Uri.parse(webViewList[selectedIndex]));
        //
        //     // controller.loadUrl( webViewList[selectedIndex]);
        //   },
        //   icon: Icon(
        //     Icons.refresh,
        //     color: Color.fromRGBO(220, 108, 163, 1),
        //   ),
        // )],):null,
        body: SafeArea(
          child: WebViewWidget(controller: _controller,
          //   initialUrl: webViewList[selectedIndex],
          //   onWebViewCreated: (c) {
          //     controller = c;
          //
          //   },
          //   onPageStarted: (String url)  {
          //     controller.canGoBack().then((value) =>
          //         setState(() {
          //           canBack = value;
          //         }));
          //
          //   },
          // //  javascriptMode: JavascriptMode.unrestricted,
          //   userAgent: Platform.isIOS ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_2 like Mac OS X) AppleWebKit/605.1.15' +
          //       ' (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1' :
          //   'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) ' 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
          //   navigationDelegate: (NavigationRequest request)async{
          //     debugPrint('URL IS ${request.url}');
          //     if(request.url.contains("https://api.whatsapp.com/")){
          //       //await FlutterOpenWhatsapp.sendSingleMessage("+966543504864", "Hello");
          //     }else if(request.url.startsWith("https://wardi.me/cart")){
          //       setState(() {
          //         canBack=false;
          //       });
          //     }else if(request.url.startsWith("https://wardi.me/best-offers")){
          //       setState(() {
          //         canBack=false;
          //       });
          //     }else if(request.url.startsWith("https://wardi.me/our-stores")){
          //       setState(() {
          //         canBack=false;
          //       });
          //     }
          //     return NavigationDecision.navigate;
          //   },
          ),
        ) ,

      ),
    );
  }
  Future<bool> _exitApp(BuildContext context) async {
    if (await _controller.canGoBack()) {
      print("onwill goback");
      _controller.goBack();
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
}
