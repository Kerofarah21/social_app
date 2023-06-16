// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

class CommentsScreen extends StatelessWidget {
  int postIndex;

  CommentsScreen({required this.postIndex, super.key});

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getComments(postIndex: postIndex);

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
                  'People who commented',
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ConditionalBuilder(
                      condition: cubit.comments!.isNotEmpty,
                      builder: (context) => ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            commentItem(cubit, index, context),
                        separatorBuilder: (context, index) => divider(),
                        itemCount: cubit.comments!.length,
                      ),
                      fallback: (context) => Center(
                        child: Text(
                          'No Comments Yet....',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadiusDirectional.circular(
                          15.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Write your comment here...',
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                ),
                                controller: textController,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (textController.text != '') {
                                cubit.commentPost(
                                  postIndex: postIndex,
                                  text: textController.text,
                                );
                                textController.text = '';
                              }
                            },
                            icon: Icon(
                              IconBroken.Send,
                              color: defaultColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget commentItem(SocialCubit cubit, int commentIndex, context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                cubit.comments![commentIndex].profileImage!,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cubit.comments![commentIndex].name!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    cubit.comments![commentIndex].text!,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Text(
                        cubit.comments![commentIndex].date!,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      Spacer(),
                      if (cubit.userCommentsIds!
                          .contains(cubit.commentsIds![commentIndex]))
                        IconButton(
                          onPressed: () {
                            cubit.deleteComment(
                              postIndex: postIndex,
                              commentId: cubit.commentsIds![commentIndex],
                            );
                          },
                          icon: Icon(
                            IconBroken.Delete,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
