import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController myController;
  final String hintTxt;
  const BlogEditor(
      {super.key, required this.myController, required this.hintTxt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: myController,
        validator: (value){
          if(value!.isEmpty){
            return '$hintTxt is required';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintTxt,

        ),
        maxLines: null,
      ),
      
    );
  }
}
