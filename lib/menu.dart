import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wardi/webview_screen.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        label: Row(
          children: [
            Image.asset('assets/icons/whatsapp.png', width: 25,),
            const SizedBox(width: 10,),
            const Text('تحدث مع الطبيب', style: TextStyle(fontSize: 12),)
          ],
        ),
        onPressed: (){
          _launchUrl(
              Uri.parse("https://api.whatsapp.com/send/?phone=966543504864&text&app_absent=0")
          );
        },
      ),
      appBar: AppBar(
        title: const Text('القائمة'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30,),
          const MenuItem(
            title: 'من نحن',
            url: "https://wardi.me/About%20Us",
          ),
          const MenuItem(
            title: 'تواصل معنا',
            url: "https://wardi.me/contact",
          ),
          const MenuItem(
            title: 'سياسة الاستبدال والاسترجاع',
            url: "https://wardi.me/exchange-and-return-policy",
          ),
          const MenuItem(
            title: 'الامان والخصوصية',
            url: "https://wardi.me/Privacy%20&%20Policy",
          ),
          const MenuItem(
            title: 'الشروط والأحكام',
            url: "https://wardi.me/Terms%20&%20Condition",
          ),
          const MenuItem(
            title: 'سياسة الشحن والتخزين',
            url: "https://wardi.me/shipping-and-storage-policy",
          ),
          const MenuItem(
            title: 'الأسئلة الشائعة',
            url: "https://wardi.me/faq",
          ),
          const MenuItem(
            title: 'ارسال الوصفة الطبية',
            url: "https://wardi.me/faq",
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialIcon(
                iconPath: 'assets/icons/facebook.png',
                onTap: (){
                  _launchUrl(
                    Uri.parse("https://www.facebook.com/OnlinestoreWardi/")
                  );
                },
              ),
              const SizedBox(width: 10,),
              SocialIcon(
                iconPath: 'assets/icons/instagram.png',
                onTap: (){
                  _launchUrl(
                      Uri.parse("https://www.instagram.com/wardistoreonline/")
                  );
                },
              ),
              const SizedBox(width: 10,),
              SocialIcon(
                iconPath: 'assets/icons/twitter.png',
                onTap: (){
                  _launchUrl(
                      Uri.parse("https://twitter.com/StoreWardi")
                  );
                },
              ),
              const SizedBox(width: 10,),
              SocialIcon(
                iconPath: 'assets/icons/whatsapp.png',
                onTap: (){
                  _launchUrl(
                      Uri.parse("https://api.whatsapp.com/send/?phone=966543504864&text&app_absent=0")
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}


class MenuItem extends StatelessWidget {
  final String title;
  final String url;
  const MenuItem({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewExample(url: url,)));
      },
      child: Container(
          padding: const EdgeInsets.only(
            right: 12,
            left: 12
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(title),
                 // const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 17,)
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(),
            ],
          ),
        ),
    );
  }

}

class SocialIcon extends StatelessWidget {
  final String iconPath;
  final void Function() onTap;
  const SocialIcon({Key? key,
    required this.iconPath,
    required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
        padding: const EdgeInsets.all(12),
        child: Image.asset(iconPath),
      ),
    );
  }
}

