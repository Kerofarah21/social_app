// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/models/user_model.dart';
import 'package:social/shared/styles/icon_broken.dart';

class LikesScreen extends StatelessWidget {
  int postIndex;

  LikesScreen({required this.postIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getLikes(postIndex: postIndex);

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    IconBroken.Arrow___Left_2,
                  ),
                ),
                titleSpacing: 0.0,
                title: Text(
                  'People who liked',
                ),
              ),
              body: ConditionalBuilder(
                condition: cubit.usersLiked!.isNotEmpty,
                builder: (context) => ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      likeItem(cubit.usersLiked![index]),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 5.0,
                  ),
                  itemCount: cubit.posts![postIndex].likes!.length,
                ),
                fallback: (context) => Center(
                  child: Text(
                    'No Likes Yet....',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget likeItem(UserModel? user) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.5,
              backgroundImage: NetworkImage(
                user!.profileImage!,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              user.name!,
            ),
            Spacer(),
            Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ],
        ),
      );
}
