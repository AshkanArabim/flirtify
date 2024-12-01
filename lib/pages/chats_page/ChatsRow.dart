import 'package:flutter/material.dart';

class ChatsRow extends StatelessWidget {
  const ChatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('clicked');
      },
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.black12),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TestName'),
                        Text('Last chat...'),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('17:35'),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
