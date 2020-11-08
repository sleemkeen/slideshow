import 'package:flutter/widgets.dart';

/// Wrap your root App widget in this widget and call [PhoenixCode.rebirth] to restart your app.
class PhoenixCode extends StatefulWidget {
  final Widget child;

  PhoenixCode({this.child});

  @override
  _PhoenixCodeState createState() => _PhoenixCodeState();

  static rebirth(BuildContext context) {
    context.findAncestorStateOfType<_PhoenixCodeState>().restartApp();
  }
}

class _PhoenixCodeState extends State<PhoenixCode> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
