import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wechat/wechat.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _result = 'no result';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    Wechat.register('APPID');
    _result = 'no result';
    print('inited');
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Wechat.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _share (arguments) async {
    try {
      var result = await Wechat.share(arguments);
      _result = result.toString() ?? 'null result';
    } catch (e) {
      _result = e.toString();
    }
  }

  void _shareText ([String to = 'session']) async {
    var arguments = {
      'to': to,
      'text': 'Welcome to user flutter wechat plugin.'
    };
    await _share(arguments);
  }

  void _shareImage ([String to = 'session']) async {
    _share({
      'kind': 'image',
      'to': to,
      'resourceUrl': 'https://files.onmr.com/wild/2018/09/3177628278.jpg',
      'url': 'https://wild.onmr.com/trails',
      'title': '荒僧',
      'description': '大丈夫当朝游碧海而暮苍梧'
    });
  }

  void _shareMusic ([String to = 'session']) async {
    _share({
      'kind': 'music',
      'to': to,
      'resourceUrl': 'https://pantao.onmr.com/usr/uploads/2018/12/2839345471.mp3',
      'url': 'https://pantao.onmr.com/demo-files',
      'coverUrl': 'https://pantao.onmr.com/usr/uploads/2018/12/2293691504.jpg',
      'title': 'Jingle Bells',
      'description': 'Children\'s Christmas Favorites-Jingle Bells (Album Version)'
    });
  }

  void _shareWebpage ([String to = 'session']) async {
    _share({
      'kind': 'webpage',
      'to': to,
      'url': 'https://pantao.onmr.com/demo-files',
      'coverUrl': 'https://pantao.onmr.com/usr/uploads/2018/12/2293691504.jpg',
      'title': 'Jingle Bells',
      'description': 'Children\'s Christmas Favorites-Jingle Bells (Album Version)'
    });
  }

  void _login () async {
    var result = await Wechat.login({
      'scope': 'snsapi_userinfo',
      'state': 'customstate'
    });
    _result = result.toString();
  }

  void _openWechat () async {
    var result = await Wechat.openWechat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wechat Plugin App'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.system_update),
              title: Text('Running on: $_platformVersion\n'),
            ),
            ListTile(
              leading: Icon(Icons.text_format),
              title: Text('Share text to wechat'),
              onTap: () {
                _shareText();
              },
            ),
            ListTile(
              leading: Icon(Icons.text_format),
              title: Text('Share text to wechat timeline'),
              onTap: () {
                _shareText('timeline');
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Share image to wechat'),
              onTap: () {
                _shareImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.music_note),
              title: Text('Share music to wechat'),
              onTap: () {
                _shareMusic();
              },
            ),
            ListTile(
              leading: Icon(Icons.web),
              title: Text('Share webpage to wechat'),
              onTap: () {
                _shareWebpage();
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Login via wechat'),
              onTap: () {
                _login();
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Open Wechat'),
              onTap: () {
                _openWechat();
              },
            ),
            Text('result: $_result')
          ],
        ),
      ),
    );
  }
}
