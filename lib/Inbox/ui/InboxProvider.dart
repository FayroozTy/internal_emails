import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_emails/Inbox/ui/InboxScreen.dart';

import '../repository/MemoServive.dart';


class MemoProvider extends StatelessWidget {

  const MemoProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MemoRepository(),
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home:  InboxScreen(429),

      ),
    );
  }
}
