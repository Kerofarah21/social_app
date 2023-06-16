// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/icon_broken.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({super.key});

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var user = cubit.currentUser;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                IconBroken.Arrow___Left_2,
              ),
            ),
            title: Text(
              'Create Post',
            ),
            titleSpacing: 0.0,
            actions: [
              if (state is! SocialUploadPostImageLoadingState)
                defaultTextButton(
                  onPressed: () {
                    cubit.createNewPost(
                      date: DateFormat.yMMMMEEEEd()
                          .add_jm()
                          .format(DateTime.now()),
                      text: textController.text,
                      postImageUrl: cubit.postImageURL,
                    );
                    Navigator.pop(context);
                  },
                  text: 'post',
                ),
            ],
          ),
          body: ConditionalBuilder(
            condition: user != null,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (state is SocialCreatePostLoadingState)
                    LinearProgressIndicator(),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(
                          user!.profileImage!,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name!,
                          ),
                          Text(
                            'public',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What is on your mind ...',
                        hintStyle: Theme.of(context).textTheme.bodyLarge,
                      ),
                      controller: textController,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  if (cubit.postImageFile != null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 140.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                              image: FileImage(cubit.postImageFile!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            cubit.removePostImage();
                          },
                          icon: CircleAvatar(
                            radius: 17.0,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 15.0,
                              child: Icon(
                                Icons.close,
                                size: 19.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 20.0,
                  ),
                  if (cubit.postImageFile == null)
                    TextButton(
                      onPressed: () {
                        cubit.getImageFromGallery(pickFor: 'post');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            IconBroken.Image,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Add photo',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
