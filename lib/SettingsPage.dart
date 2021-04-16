import 'package:easacc_task/AppSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  static String url;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  String _noDevices = 'No Device Selected';
  String _dropDownValue = 'No Device Selected';
  List<String> _devices = [];

  void initState() {
    super.initState();
    _devices.add(_noDevices);
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 10));
    var subscription = FlutterBlue.instance.scanResults.listen((event) {
      for (ScanResult r in event) {
        print('${r.device.name} found! rssi: ${r.rssi}');
        if (r.device.name.isEmpty) {
          _devices.add(r.device.id.id + ' (Bluetooth)');
        } else {
          _devices.add(r.device.name + ' (Bluetooth)');
        }
      }
    });
    FlutterBlue.instance.stopScan();
  }

  Widget _urlTile() {
    return ListTile(
      title: Text('Web URL'),
      leading: Icon(Icons.web),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  contentPadding: EdgeInsets.all(5), content: _formWidget());
            });
      },
    );
  }

  Widget _urlForm() {
    return TextFormField(
      autofocus: true,
      controller: _urlController,
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: () {
          context.read<AppSettings>().updateWebURL(_urlController.text);
          Navigator.pop(context);
        },
        child: Text('Submit'));
  }

  Widget _formWidget() {
    return ListView(
      shrinkWrap: true,
      children: [
        Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [Align(child: Text('Enter your web url here:'))],
                ),
                _urlForm(),
                _submitButton()
              ],
            ))
      ],
    );
  }

  Widget _devicesList() {
    return DropdownButton<String>(
      value: _dropDownValue,
      onChanged: (newValue) {
        setState(() {
          _dropDownValue = newValue;
        });
      },
      items: _devices.isNotEmpty
          ? _devices.map<DropdownMenuItem<String>>((e) {
              return DropdownMenuItem<String>(value: e, child: Text(e));
            }).toList()
          : <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(
                child: Text(_noDevices),
                value: _noDevices,
              )
            ].toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          children: [_urlTile(), _devicesList()],
        ));
  }
}
