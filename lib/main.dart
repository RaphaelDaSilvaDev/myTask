// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_tasks/app.dart';
import 'package:my_tasks/providers.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting("pt_BR", null).then(
    (_) => runApp(MultiProvider(
      providers: providers,
      child: const App(),
    )),
  );
}
