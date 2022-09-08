import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {

  //String text;

  const NoDataWidget({Key key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     // margin: EdgeInsets.only(bottom: 214),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Image.asset('assets/img/novacancy.png'),
          //Text(text)
        ],
      ),
    );
  }
}
