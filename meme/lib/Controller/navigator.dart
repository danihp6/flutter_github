import 'package:flutter/material.dart';
import 'package:meme/Controller/gallery.dart';
import 'package:meme/Models/Template.dart';
import 'package:meme/Pages/account_page.dart';
import 'package:meme/Pages/comments_page.dart';
import 'package:meme/Pages/contact_page.dart';
import 'package:meme/Pages/edit_profile_page.dart';
import 'package:meme/Pages/followers_list_page.dart';
import 'package:meme/Pages/gallery_page.dart';
import 'package:meme/Pages/image_editor_page.dart';
import 'package:meme/Pages/my_user_page.dart';
import 'package:meme/Pages/new_post_list_page.dart';
import 'package:meme/Pages/template_over_image_camera_page.dart';
import 'package:meme/Pages/post_list_page.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Pages/select_media_page.dart';
import 'package:meme/Pages/select_post_from_post_list_page.dart';
import 'package:meme/Pages/select_post_list_page.dart';
import 'package:meme/Pages/sign_in_page.dart';
import 'package:meme/Pages/tag_page.dart';
import 'package:meme/Pages/template_text.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

import 'db.dart';

class MyNavigator {
  pop(context, [var result]) => Navigator.pop(context, result);

  goUser(BuildContext context, String userId) {
    if (userId == db.userId)
      Navigator.push(context, SlideLeftRoute(page: MyUserPage()));
    else
      Navigator.push(
          context,
          SlideLeftRoute(
              page: UserPage(
            userId: userId,
          )));
  }

  goUploadPublication(BuildContext context, Function futureMedia,[Template template]) => Navigator.push(
      context,
      SlideLeftRoute(
          page: UploadPublicationPage(
        futureMedia : futureMedia,
        template: template,
      )));

  goGallery(BuildContext context, Function onMediaSelected) => Navigator.push(
      context,
      SlideLeftRoute(page: GalleryPage(onMediaSelected: onMediaSelected)));

  goImageEditor(
          BuildContext context, Function onMediaSelected, ImageMedia media) =>
      Navigator.push(
          context,
          SlideLeftRoute(
              page: ImageEditorPage(
                  onMediaSelected: onMediaSelected, imageMedia: media)));

  goSignIn(BuildContext context) =>
      Navigator.push(context, SlideLeftRoute(page: SignInPage()));

  goContact(BuildContext context) =>
      Navigator.push(context, SlideLeftRoute(page: ContactPage()));

  goAccount(BuildContext context) =>
      Navigator.push(context, SlideLeftRoute(page: AccountPage()));

  goTag(BuildContext context, String tagId) => Navigator.push(
      context,
      SlideLeftRoute(
          page: TagPage(
        tagId: tagId,
      )));

  goPostList(BuildContext context, String postListId, String authorId) =>
      Navigator.push(
          context,
          SlideLeftRoute(
              page: PostListPage(
            authorId: authorId,
            postListId: postListId,
          )));

  goPost(BuildContext context, String postId, String authorId) =>
      Navigator.push(
          context,
          SlideLeftRoute(
              page: PostPage(
            authorId: authorId,
            postId: postId,
          )));

  goSelectPost(BuildContext context, Function onSelected) => Navigator.push(
      context,
      SlideLeftRoute(
          page: SelectPostFromPostListPage(
        onTap: onSelected,
      )));

  goEditProfile(BuildContext context) =>
      Navigator.push(context, SlideLeftRoute(page: EditProfilePage()));

  goComments(BuildContext context, String postId, String authorId,
          String description) =>
      Navigator.of(context).push(SlideLeftRoute(
          page: CommentsPage(
        description: description,
        postId: postId,
        authorId: authorId,
      )));

  goNewPostList(BuildContext context) =>
      Navigator.push(context, SlideLeftRoute(page: NewPostListPage()));

  goSelectPostList(BuildContext context, String postId, String authorId) =>
      Navigator.push(
          context,
          SlideLeftRoute(
              page: SelectPostList(
            postId: postId,
            authorId: authorId,
          )));

  goSelectMedia(BuildContext context) =>
      Navigator.push(context, SlideLeftRoute(page: SelectMediaPage()));

  goFollowers(BuildContext context, String userId) => Navigator.push(
      context, SlideLeftRoute(page: FollowersListPage(userId: userId)));

  goTemplateOverImageCamera(BuildContext context, Template template) => Navigator.push(
      context,
      SlideLeftRoute(
          page: TemplateOverImageCameraPage(
        template: template,
      )));

  goTemplateText(BuildContext context, Template template) => Navigator.push(
      context, SlideLeftRoute(page: TemplateText(template: template)));
}

MyNavigator navigator = MyNavigator();
