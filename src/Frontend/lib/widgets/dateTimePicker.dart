import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Datetimepicker extends StatefulWidget{
  const Datetimepicker({Key? key}): super(key: key);

@override
  State<Datetimepicker> createState() => _DatetimepickerState();
}

class _DatetimepickerState extends State<Datetimepicker>{
  DateTime dateTime= DateTime(2024,06,1,10,20);
  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
      child: Center(
        child: CupertinoButton( 
          child:  Text('${dateTime.month}-${dateTime.day}-${dateTime.year}'),
          onPressed: () {
            showCupertinoDialog(
              context: context, 
              builder: (BuildContext context)=>SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  backgroundColor: Colors.white ,
                  initialDateTime: dateTime,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(()=> dateTime= newTime); 
                      
                    },
                    use24hFormat: true,
                    
                    ),
                   ), 
                   );  
                  },
                ),

              ),
            );
          }
      
    
    
  }
