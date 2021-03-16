import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

InputDecoration textFieldInputDeco(String hintText) {
  return InputDecoration(
    hintText: '$hintText',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      gapPadding: 4,
    ),
    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
    // errorText: 'hi'
  );
}
