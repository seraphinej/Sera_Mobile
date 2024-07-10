import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TextBox extends StatelessWidget{
  const TextBox({
    super.key,
    required this.sectionName,
    required this.inputText
});

  final String sectionName;
  final String inputText;

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8)
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: const EdgeInsets.only(
        left: 15,
        right: 15
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                  color: HexColor("#212A91"),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSerif'
                ),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(
                  Icons.edit,
                  color: Colors.grey[400],
                ),
              )
            ],
          ),
          Text(
            inputText,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'NotoSerif'
            ),
          )
        ],
      ),
    );
  }
}