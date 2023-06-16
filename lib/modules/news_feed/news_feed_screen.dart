// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/modules/comments/comments_screen.dart';
import 'package:social/modules/edit_post/edit_post.dart';
import 'package:social/modules/likes/likes_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/styles/icon_broken.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getPosts();

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);

            return ConditionalBuilder(
              condition: cubit.posts!.isNotEmpty && cubit.currentUser != null,
              builder: (context) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Card(
                        elevation: 5.0,
                        margin: EdgeInsets.all(8.0),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Stack(
                          children: [
                            Image(
                              image: NetworkImage(
                                'https://img.freepik.com/free-photo/bearded-youngman-looks-excited-delighted-gladden-amazed-pointing-with-index-finger-aside_295783-1430.jpg?w=1060&t=st=1685634395~exp=1685634995~hmac=31ae15e03fdd90108a97d46268a2ebca0fc5d056c77fc9df5c4a478cf37b221d',
                              ),
                              width: double.infinity,
                              height: 200.0,
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Communicate with friends',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => postItem(
                          cubit,
                          index,
                          context,
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 5.0,
                        ),
                        itemCount: cubit.posts!.length,
                      ),
                    ],
                  ),
                );
              },
              fallback: (context) => Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }

  Widget postItem(SocialCubit cubit, int postIndex, context) => Card(
        elevation: 5.0,
        margin: EdgeInsets.all(8.0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                      cubit.posts![postIndex].profileImage!,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cubit.posts![postIndex].name!,
                      ),
                      Text(
                        cubit.posts![postIndex].date!,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                  Spacer(),
                  if (cubit.userPostsIds!.contains(cubit.postsIds![postIndex]))
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Text(
                            'Edit Post',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text(
                            'Delete Post',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 1) {
                          navigateTo(
                            context,
                            EditPostScreen(
                              postIndex: postIndex,
                            ),
                          );
                        } else {
                          cubit.deletePost(postIndex: postIndex);
                        }
                      },
                      icon: Icon(
                        IconBroken.More_Circle,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Container(
                  height: 1.0,
                  color: Colors.grey[350],
                ),
              ),
              if (cubit.posts![postIndex].text != '')
                Text(
                  cubit.posts![postIndex].text!,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        height: 1.3,
                      ),
                ),
              SizedBox(
                height: 5.0,
              ),
              if (cubit.posts![postIndex].postImage != null)
                Card(
                  elevation: 0.0,
                  margin: EdgeInsets.all(8.0),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                    children: [
                      Image(
                        image: NetworkImage(
                          cubit.posts![postIndex].postImage!,
                        ),
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      navigateTo(
                        context,
                        LikesScreen(postIndex: postIndex),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                          size: 20.0,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${cubit.posts![postIndex].likes!.length}',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      navigateTo(
                        context,
                        CommentsScreen(postIndex: postIndex),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Chat,
                          size: 20.0,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${cubit.posts![postIndex].comments} comments',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Container(
                  height: 1.0,
                  color: Colors.grey[350],
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 15.0,
                    backgroundImage: NetworkImage(
                      cubit.currentUser!.profileImage!,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          CommentsScreen(postIndex: postIndex),
                        );
                      },
                      child: Text(
                        'Write a comment ...',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      SocialCubit.get(context).likePost(
                        postIndex: postIndex,
                      );
                    },
                    icon: Icon(
                      cubit.posts![postIndex].likes!.contains(uId)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
