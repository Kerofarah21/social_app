// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/models/comment_model.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/modules/chats/chats_screen.dart';
import 'package:social/modules/news_feed/news_feed_screen.dart';
import 'package:social/modules/profile/profile_screen.dart';
import 'package:social/modules/settings/settings_screen.dart';
import 'package:social/modules/users/users_screen.dart';
import 'package:social/shared/components/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  File? profileImage;
  File? coverImage;
  File? postImageFile;
  ImagePicker picker = ImagePicker();
  Future getImageFromGallery({
    required String pickFor,
  }) async {
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickFor == 'profile') {
      profileImage = File(pickedImage!.path);
      uploadImage(
        uploadFor: pickFor,
        path: profileImage!.path,
      );
    } else if (pickFor == 'cover') {
      coverImage = File(pickedImage!.path);
      uploadImage(
        uploadFor: pickFor,
        path: coverImage!.path,
      );
    } else {
      postImageFile = File(pickedImage!.path);
      uploadPostImage();
    }
  }

  String? profileImageURL;
  String? coverImageURL;
  void uploadImage({
    required String uploadFor,
    required String path,
  }) {
    emit(SocialUploadImageLoadingState());

    FirebaseStorage.instance
        .ref()
        .child('users/$uId/$uploadFor/${Uri.file(path).pathSegments.last}')
        .putFile(uploadFor == 'profile' ? profileImage! : coverImage!)
        .then((value) {
      emit(SocialUploadImageSuccessState());
      value.ref.getDownloadURL().then((value) {
        emit(SocialGetImageURLSuccessState());
        uploadFor == 'profile'
            ? profileImageURL = value
            : coverImageURL = value;
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetImageURLErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialUploadImageErrorState());
    });
  }

  UserModel? currentUser;
  void getUserData() {
    emit(SocialGetUserDataLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      currentUser = UserModel.fromJson(value.data()!);
      emit(SocialGetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserDataErrorState());
    });
  }

  void updateUserData({
    required String uId,
    required String name,
    required String email,
    required String phone,
    required String bio,
    required String profileImage,
    required String coverImage,
    required bool isEmailVerified,
  }) {
    emit(SocialUpdateUserDataLoadingState());

    currentUser = UserModel(
      uId: uId,
      name: name,
      email: email,
      phone: phone,
      bio: bio,
      profileImage: profileImage,
      coverImage: coverImage,
      isEmailVerified: isEmailVerified,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(currentUser!.toMap())
        .then((value) {
      profileImageURL = null;
      coverImageURL = null;
      userPostsIds!.forEach((postId) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
              'name': name,
              'profileImage': profileImage,
            })
            .then((value) {})
            .catchError((error) {
              print(error.toString());
            });
      });
      emit(SocialUpdateUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialUpdateUserDataErrorState());
    });
  }

  List<UserModel>? users = [];
  void getUsers() {
    emit(SocialGetUsersLoadingState());

    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      users = [];
      event.docs.forEach((user) {
        if (user.data()['uId'] != uId) {
          users!.add(UserModel.fromJson(user.data()));
        }
      });
      emit(SocialGetUsersSuccessState());
    });
  }

  String? postImageURL;
  void uploadPostImage() {
    emit(SocialUploadPostImageLoadingState());

    FirebaseStorage.instance
        .ref()
        .child('posts/$uId/${Uri.file(postImageFile!.path).pathSegments.last}')
        .putFile(postImageFile!)
        .then((value) {
      emit(SocialUploadPostImageSuccessState());
      value.ref.getDownloadURL().then((value) {
        emit(SocialGetPostImageURLSuccessState());
        postImageURL = value;
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetPostImageURLErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialUploadPostImageErrorState());
    });
  }

  void removePostImage() {
    FirebaseStorage.instance
        .ref()
        .child('posts/$uId/${Uri.file(postImageFile!.path).pathSegments.last}')
        .delete()
        .then((value) {
      postImageFile = null;
      emit(SocialRemovePostImageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialRemovePostImageErrorState());
    });
  }

  PostModel? post;
  void createNewPost({
    required String date,
    required String? text,
    required String? postImageUrl,
  }) {
    emit(SocialCreatePostLoadingState());

    post = PostModel(
      uId: currentUser!.uId,
      name: currentUser!.name,
      profileImage: currentUser!.profileImage,
      date: date,
      text: text,
      postImage: postImageUrl,
      comments: 0,
      likes: [],
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(post!.toMap())
        .then((value) {
      postImageURL = null;
      postImageFile = null;
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreatePostErrorState());
    });
  }

  void updatePost({
    required String postId,
    required String uId,
    required String name,
    required String profileImage,
    required String date,
    required String? text,
    required String? postImage,
    required int comments,
    required List<String> likes,
  }) {
    emit(SocialUpdatePostLoadingState());

    PostModel post = PostModel(
      uId: uId,
      name: name,
      profileImage: profileImage,
      date: date,
      text: text,
      postImage: postImage,
      likes: likes,
      comments: comments,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(post.toMap())
        .then((value) {
      postImageURL = null;
      postImageFile = null;
      emit(SocialUpdatePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialUpdatePostErrorState());
    });
  }

  List<PostModel>? posts = [];
  List<String>? postsIds = [];
  List<String>? userPostsIds = [];
  void getPosts() {
    emit(SocialGetPostsLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .orderBy(
          'date',
          descending: true,
        )
        .snapshots()
        .listen((event) {
      posts = [];
      postsIds = [];
      userPostsIds = [];

      event.docs.forEach((post) {
        postsIds!.add(post.id);
        posts!.add(PostModel.fromJson(post.data()));
        if (post.data()['uId'] == uId) {
          userPostsIds!.add(post.id);
        }
      });

      emit(SocialGetPostsSuccessState());
    });
  }

  void deletePost({
    required int postIndex,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postsIds![postIndex])
        .delete()
        .then((value) {
      emit(SocialDeletePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialDeletePostErrorState());
    });
  }

  void likePost({
    required int postIndex,
  }) {
    var likes = posts![postIndex].likes;

    if (likes!.contains(uId)) {
      likes.remove(uId);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postsIds![postIndex])
          .update({
        'likes': likes,
      }).then((value) {
        emit(SocialChangeLikePostSuccessState());
      }).catchError((error) {
        emit(SocialChangeLikePostErrorState());
      });
    } else {
      likes.add(uId!);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postsIds![postIndex])
          .update({
        'likes': likes,
      }).then((value) {
        emit(SocialChangeLikePostSuccessState());
      }).catchError((error) {
        emit(SocialChangeLikePostErrorState());
      });
    }
  }

  List<UserModel>? usersLiked = [];
  void getLikes({
    required int postIndex,
  }) {
    usersLiked = [];
    emit(SocialGetLikesLoadingState());
    posts![postIndex].likes!.forEach((like) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(like)
          .get()
          .then((value) {
        usersLiked!.add(UserModel.fromJson(value.data()!));
        emit(SocialGetLikesSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetLikesErrorState());
      });
    });
  }

  CommentModel? comment;
  void commentPost({
    required int postIndex,
    required String text,
  }) {
    comment = CommentModel(
      uId: uId,
      name: currentUser!.name,
      profileImage: currentUser!.profileImage,
      date: DateFormat.yMd().add_jm().format(DateTime.now()),
      text: text,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postsIds![postIndex])
        .collection('comments')
        .add(comment!.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postsIds![postIndex])
          .update({
            'comments': posts![postIndex].comments! + 1,
          })
          .then((value) {})
          .catchError((error) {
            print(error.toString());
          });
      emit(SocialCommentPostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCommentPostErrorState());
    });
  }

  List<CommentModel>? comments = [];
  List<String>? commentsIds = [];
  List<String>? userCommentsIds = [];
  void getComments({
    required int postIndex,
  }) {
    emit(SocialGetCommentsLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postsIds![postIndex])
        .collection('comments')
        .orderBy(
          'date',
          descending: true,
        )
        .snapshots()
        .listen((event) {
      comments = [];
      commentsIds = [];
      userCommentsIds = [];
      event.docs.forEach((comment) {
        commentsIds!.add(comment.id);
        comments!.add(CommentModel.fromJson(comment.data()));
        if (comment.data()['uId'] == uId) {
          userCommentsIds!.add(comment.id);
        }
      });
      emit(SocialGetCommentsSuccessState());
    });
  }

  void deleteComment({
    required int postIndex,
    required String commentId,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postsIds![postIndex])
        .collection('comments')
        .doc(commentId)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postsIds![postIndex])
          .update({
            'comments': posts![postIndex].comments! - 1,
          })
          .then((value) {})
          .catchError((error) {
            print(error.toString());
          });
      emit(SocialDeleteCommentSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialDeleteCommentErrorState());
    });
  }

  MessageModel? message;
  void sendMessage({
    required String receiverId,
    required String text,
    required String date,
  }) {
    message = MessageModel(
      senderId: uId,
      receiverId: receiverId,
      text: text,
      date: date,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(message!.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(message!.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel>? messages = [];
  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((message) {
        messages!.add(MessageModel.fromJson(message.data()));
      });
      emit(SocialGetMessagesSuccessState());
    });
  }

  List<Widget> screens = [
    NewsFeedScreen(),
    ChatsScreen(),
    ProfileScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    'News Feed',
    'Chats',
    'Profile',
    'Users',
    'Settings',
  ];
  int currentIndex = 0;
  void changeBottomNav(int index) {
    if (index == 1) {
      getUsers();
    }
    currentIndex = index;
    emit(SocialChangeBottomNavState());
  }
}
