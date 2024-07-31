import 'package:flutter/cupertino.dart';

class Widget062 extends StatelessWidget{

Widget062({super.key});

final TextEditingController _textController =
  TextEditingController(text:'Search');


@override
  Widget build(BuildContext context){
  return Container(
    padding: const EdgeInsets.all(10),
    child: Center(
      child: CupertinoSearchTextField(
        controller: _textController,
        ),
    )
  );
}


}

