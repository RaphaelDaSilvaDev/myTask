import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

AppBar appBarWidget() {
  return AppBar(
    backgroundColor: gray300,
    title: Text("Entrada",
        style: GoogleFonts.quicksand(
            fontSize: 24, color: gray900, fontWeight: FontWeight.w400)),
    elevation: 0,
  );
}
