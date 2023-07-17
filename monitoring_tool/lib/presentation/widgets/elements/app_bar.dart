import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../responsive.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Visibility(
            visible: Responsive.isDesktop(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 30.0),
              child: Text(
                "Overview",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
