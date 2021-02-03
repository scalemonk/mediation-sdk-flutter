import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/*
 * @SMAds: This is a demo application you can find on 
 * https://flutter.dev/docs/get-started/install which has been modified
 * to show ads when requested. The original functionality of the application
 * was to 'increment a counter' so you'll see some code that has to do with 
 * that.
 */

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMAds Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SMAds Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static const platform = const MethodChannel('scalemonk.com/ads');

  String _adsInitializationResult = 'SMAds not initialized yet';
  String _wasRewarded = 'This is where rewarded and interstitial callback results are shown';

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(callbacksHandler);
  }

  Future<void> _initializeSMAds() async {
    String initializationResult;
    try {
      final String result = await platform.invokeMethod('initializeSMAds');
      initializationResult = "ScaleMonk initialization result is: $result";
    } on PlatformException catch (e) {
      initializationResult = "Error initializing ScaleMonk. Message: '${e.message}'.";
    }

    setState(() {
      _adsInitializationResult = initializationResult;
    });
  }

  /*
   * @SMAds: this is relevant, here you will receive the callbacks from SMAds
   * These callbacks are called on the Swift side (AppDelegate.swift), on the Rewarded Video Callbacks MARK
   */
  Future<dynamic> callbacksHandler(MethodCall methodCall) async {
    String newText = _wasRewarded;
    switch (methodCall.method) {
      case 'onRewardedFinish':       
        newText = "Video completed, reward given";
        break;
       case 'onRewardedFail':
        newText = "Video not shown";
        break;
        case 'onRewardedFinishNoReward':
        newText = "Video not completed, reward not given";
        break;
        case 'onInterstitialView':
          newText = "Interstitial shown correctly";
        break;
          case 'onInterstitialClick':
          newText = "Interstitial clicked";
        break;
        case 'onInterstitialFail':
          newText = "Interstitial not shown";
        break;
        case 'onRewardedClick':
          newText = "Rewarded video clicked";
        break;
      default:
    }
    setState(() {
        _wasRewarded = newText;
      });
  }

  Future<void> _showInterstitial() async {
    await platform.invokeMethod('showInterstitial');
  }

  Future<void> _showRewarded() async {
    await platform.invokeMethod('showRewarded');
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Initialize SM Ads'),
              onPressed: _initializeSMAds,
            ),
            Text(_adsInitializationResult),
            ElevatedButton(
              child: Text('Show interstitial'),
              onPressed: _showInterstitial,
            ),
            ElevatedButton(
              child: Text('Show Rewarded'),
              onPressed: _showRewarded,
            ),
            Text(_wasRewarded),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
