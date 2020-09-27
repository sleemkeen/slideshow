import 'package:flutter/material.dart';
class Code extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 80,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.black,
              ),
            ),
            Container(
              height: 80,
              color:  Colors.orange,
            )
          ],
        ),
      ),
    );
  }
}

