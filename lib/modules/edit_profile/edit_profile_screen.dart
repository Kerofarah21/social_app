// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var user = cubit.currentUser;

        nameController.text = user!.name!;
        emailController.text = user.email!;
        phoneController.text = user.phone!;
        bioController.text = user.bio!;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                IconBroken.Arrow___Left_2,
              ),
            ),
            title: Text(
              'Edit Profile',
            ),
            titleSpacing: 0.0,
            actions: [
              if (state is! SocialUploadImageLoadingState)
                defaultTextButton(
                  onPressed: () {
                    cubit.updateUserData(
                      uId: user.uId!,
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                      profileImage: cubit.profileImageURL ?? user.profileImage!,
                      coverImage: cubit.coverImageURL ?? user.coverImage!,
                      isEmailVerified: user.isEmailVerified!,
                    );
                  },
                  text: 'update',
                ),
            ],
          ),
          body: ConditionalBuilder(
            condition: state is! SocialUpdateUserDataLoadingState,
            builder: (context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (state is SocialUploadImageLoadingState)
                      LinearProgressIndicator(),
                    Container(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.only(
                                      topStart: Radius.circular(4.0),
                                      topEnd: Radius.circular(4.0),
                                    ),
                                    image: DecorationImage(
                                      image: cubit.coverImage == null
                                          ? NetworkImage(
                                              user.coverImage!,
                                            )
                                          : FileImage(cubit.coverImage!)
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    cubit.getImageFromGallery(pickFor: 'cover');
                                  },
                                  icon: CircleAvatar(
                                    radius: 17.0,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: CircleAvatar(
                                      radius: 15.0,
                                      child: Icon(
                                        IconBroken.Camera,
                                        size: 19.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 55.0,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: cubit.profileImage == null
                                      ? NetworkImage(
                                          user.profileImage!,
                                        )
                                      : FileImage(cubit.profileImage!)
                                          as ImageProvider,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.getImageFromGallery(pickFor: 'profile');
                                },
                                icon: CircleAvatar(
                                  radius: 17.0,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 15.0,
                                    child: Icon(
                                      IconBroken.Camera,
                                      size: 19.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      context,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      label: 'Name',
                      prefix: IconBroken.User,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                      context,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      label: 'Email Address',
                      prefix: Icons.email_outlined,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                      context,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      label: 'Phone',
                      prefix: Icons.phone,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                      context,
                      controller: bioController,
                      keyboardType: TextInputType.text,
                      label: 'Bio',
                      prefix: IconBroken.Info_Circle,
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) => Center(child: LinearProgressIndicator()),
          ),
        );
      },
    );
  }
}
