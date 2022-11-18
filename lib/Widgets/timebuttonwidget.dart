import 'package:flutter/material.dart';
import 'package:sports_club/utils/colors.dart';

class TimeButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const TimeButtonWidget({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: const Size(100, 42),primary: appbarColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time_outlined, size: 28),
            const SizedBox(width: 9),
            Text(
              '選擇時間 ',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        onPressed: onClicked,
      );
}
