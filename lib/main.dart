import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

import 'core/bloc_delegate.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inits all instances from one point
  await di.init();

  ///********************************************************
  /// TEST
  final FirebaseDynamicLinks firebaseDynamicLinks =
      FirebaseDynamicLinks.instance;

  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://linkerapp.page.link',
    link: Uri.parse('https://linkerapp.page.link/groups?group=test_group'),
    androidParameters: AndroidParameters(
      packageName: 'com.example.linker',
      minimumVersion: 0,
    ),
  );

  final Uri dynamicUrl = await parameters.buildUrl();
  final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
    dynamicUrl,
    DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
  );
  final Uri shortUrl = shortenedLink.shortUrl;

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp(
    url: Uri.parse("https://linkerapp.page.link" + shortUrl.path),
    firebaseDynamicLinks: firebaseDynamicLinks,
  ));
}

class MyApp extends StatefulWidget {
  final Uri url;
  final FirebaseDynamicLinks firebaseDynamicLinks;

  const MyApp({Key key, this.url, this.firebaseDynamicLinks}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/success': (context) => Scaffold(
              body: Center(
                child: Text('yay'),
              ),
            ),
      },
      home: Home(
        url: widget.url,
        firebaseDynamicLinks: widget.firebaseDynamicLinks,
      ),
    );
  }
}

class Home extends StatefulWidget {
  final FirebaseDynamicLinks firebaseDynamicLinks;
  final Uri url;

  const Home({Key key, this.url, this.firebaseDynamicLinks}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    widget.firebaseDynamicLinks.onLink(
      onSuccess: (url) async {
        print(url.link.toString());

        print(url.link.queryParameters);
        Navigator.of(context).pushNamed('/success');
      },
      onError: (yay) async {
        print('failure');
        print(yay.message);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.url.toString(),
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Share.share(widget.url.toString());
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///********************************************************
