import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'profile_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Credentials? _credentials;

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0(dotenv.env['AUTHO_DOMAIN']!, dotenv.env['AUTHO_CLIENT_ID']!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_credentials == null)
          ElevatedButton(
              onPressed: () async {
                final credentials =
                await auth0.webAuthentication().login();

                setState(() {
                  _credentials = credentials;
                });
              },
              child: const Text("Log in"))
        else
          Column(
            children: [
              ProfileView(user: _credentials!.user),
              ElevatedButton(
                  onPressed: () async {
                    await auth0.webAuthentication().logout();

                    setState(() {
                      _credentials = null;
                    });
                  },
                  child: const Text("Log out"))
            ],
          )
      ],
    );
  }
}