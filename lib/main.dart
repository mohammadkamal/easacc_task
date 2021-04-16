import 'package:easacc_task/AppSettings.dart';
import 'package:easacc_task/SettingsPage.dart';
import 'package:easacc_task/SocialMediaLogin.dart';
import 'package:easacc_task/WebViewPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AppSettings(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easacc Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error occured');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Easacc Task'),
                ),
                body: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.login),
                      title: Text('Social Media Login'),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SocialMediaLogin(),
                      )),
                    ),
                    ListTile(
                      leading: Icon(Icons.web),
                      title: Text('View Webpage'),
                      onTap: () {
                        if (context.read<AppSettings>().webURL == null) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Container(
                                        child: Text(
                                            'Please enter url in settings'),
                                      )
                                    ],
                                  ),
                                );
                              });
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WebViewPage(
                                url: Provider.of<AppSettings>(context).webURL),
                          ));
                        }
                      },
                    ),
                    ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SettingsPage(),
                            )))
                  ],
                ));
          }

          return Scaffold();
        });
  }
}
