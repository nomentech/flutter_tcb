import 'package:flutter/material.dart';

import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:flutter_tcb/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter TCB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Flutter TCB Test'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  CloudBaseCore core;
  CloudBaseAuth auth;

  @override
  void initState() {
    core = CloudBaseCore.init({
      'env': 'play-2gvsk2on63228367',
      'appAccess': {
        'key': FlutterConfig.get('KEY') as String,
        'version': FlutterConfig.get('VERSION') as String,
      }
    });

    auth = CloudBaseAuth(core);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Center(child: Text('List Page')),
          FutureBuilder(
            future: auth.getAuthState(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FutureBuilder(
                  future: auth.getUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(child: Text(snapshot.data.toString()));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else {
                // auth.signInByWx(
                //   wxAppId: FlutterConfig.get('WXAPPID') as String,
                //   wxUniLink: FlutterConfig.get('WXUNILINK') as String,
                // );
                auth.signInAnonymously();
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
