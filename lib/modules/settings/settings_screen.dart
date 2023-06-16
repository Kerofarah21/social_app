// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/modules/login/login_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/cubit/cubit.dart';
import 'package:social/shared/network/local/cache_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dark Mode',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Spacer(),
                  Switch.adaptive(
                    value: AppCubit.get(context).isDark,
                    onChanged: (value) {
                      AppCubit.get(context).changeAppMode();
                    },
                  )
                ],
              ),
              Spacer(),
              defaultButton(
                onPressed: () {
                  CacheHelper.removeData(key: 'uId').then((value) {
                    if (value) navigateAndFinish(context, LoginScreen());
                  });
                },
                text: 'logout',
              ),
            ],
          ),
        );
      },
    );
  }
}
