import 'package:flutter/material.dart';

class ListCard extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;

  const ListCard({super.key, required this.text, this.onTap});

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          print("${widget.text} - gesture");
        },
        child: SizedBox(
          height: 100,
          width: 400,
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "CupertinoSystemText",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
