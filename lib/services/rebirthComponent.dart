import 'package:flutter/widgets.dart';

class PhoenixReborn extends StatefulWidget {
  final Widget child;

  PhoenixReborn({this.child});

  @override
  _PhoenixRebornState createState() => _PhoenixRebornState();

  static rebirth(BuildContext context) {
    context.findAncestorStateOfType<_PhoenixRebornState>().restartApp();
  }
}

class _PhoenixRebornState extends State<PhoenixReborn> {
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
