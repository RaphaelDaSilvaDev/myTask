import 'package:flutter/material.dart';
import 'package:my_tasks/constants/colors.dart';
import 'package:my_tasks/screens/home/components/app_bar.dart';
import 'package:my_tasks/screens/home/components/body/home_body.dart';

import 'components/add_note_sheet/add_note_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray300,
      appBar: appBarWidget(),
      body: const homeBodyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              useSafeArea: false,
              isScrollControlled: true,
              builder: (_) => const AddNoteSheet());
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              gradient: LinearGradient(
                  colors: [blue200, blue400],
                  begin: Alignment.topLeft,
                  end: AlignmentDirectional.bottomEnd)),
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
    );
  }
}
