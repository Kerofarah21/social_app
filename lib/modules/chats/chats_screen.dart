// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/models/user_model.dart';
import 'package:social/modules/chat_details/chat_details_screen.dart';
import 'package:social/shared/components/components.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getUsers();

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            var users = cubit.users;

            return ConditionalBuilder(
              condition: users!.isNotEmpty,
              builder: (context) => ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    chatItem(users[index], context),
                separatorBuilder: (context, index) => divider(),
                itemCount: users.length,
              ),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }

  Widget chatItem(UserModel user, context) => InkWell(
        onTap: () {
          navigateTo(context, ChatDetailsScreen(user: user));
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  user.profileImage!,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                user.name!,
              ),
            ],
          ),
        ),
      );
}
