import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData usericon;
  final String text;
  final void Function()? onTap;

  const MyListTile({
    super.key,
    required this.usericon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        usericon,
        color: Colors.white,
      ),
      onTap: onTap,
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
