// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel? user;

  ChatDetailsScreen({
    required this.user,
    super.key,
  });

  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receiverId: user!.uId!);

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
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        user!.profileImage!,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      user!.name!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: cubit.messages!.isNotEmpty,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (uId == cubit.messages![index].senderId) {
                                return sentMessageItem(cubit.messages![index]);
                              }
                              return receivedMessageItem(
                                  cubit.messages![index]);
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15.0,
                            ),
                            itemCount: cubit.messages!.length,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write your message here...',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  controller: messageController,
                                  onFieldSubmitted: (value) {
                                    cubit.sendMessage(
                                      receiverId: user!.uId!,
                                      text: value,
                                      date: DateTime.now().toString(),
                                    );
                                    messageController.text = '';
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                IconBroken.Image,
                                color: defaultColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (messageController.text != '') {
                                  cubit.sendMessage(
                                    receiverId: user!.uId!,
                                    text: messageController.text,
                                    date: DateTime.now().toString(),
                                  );
                                  messageController.text = '';
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
                    ],
                  ),
                ),
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget receivedMessageItem(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
                bottomEnd: Radius.circular(10.0),
              )),
          child: Text(
            message.text!,
          ),
        ),
      );

  Widget sentMessageItem(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
              color: defaultColor,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
                bottomStart: Radius.circular(10.0),
              )),
          child: Text(
            message.text!,
          ),
        ),
      );
}
