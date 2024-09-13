import 'dart:io';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snakbar.dart';
import 'package:blog_app/features/blog/presentation/blog/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlog extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const AddNewBlog());
  const AddNewBlog({super.key});

  @override
  State<AddNewBlog> createState() => _AddNewBlogState();
}

class _AddNewBlogState extends State<AddNewBlog> {
  final TextEditingController blogTitleController = TextEditingController();
  final TextEditingController blogContentController = TextEditingController();
  final GlobalKey<FormState> addBlogFormKey = GlobalKey<FormState>();
  File? blogImage;
  List<String> selectedTopics = [];

  void selectImage() async {
    final File? selectedImage = await pickImage();
    if (selectedImage != null) {
      setState(() {
        blogImage = selectedImage;
      });
    }
  }

  @override
  void dispose() {
    blogTitleController.dispose();
    blogContentController.dispose();
    super.dispose();
  }

  void uploadBlog() {
    if (addBlogFormKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        blogImage != null) {
      String userId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
            BlogUploadEvent(
              userId: userId,
              title: blogContentController.text,
              content: blogContentController.text,
              image: blogImage!,
              topics: selectedTopics,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Blog'),
        actions: [
          IconButton(
            onPressed: uploadBlog,
            icon: const Icon(
              Icons.done_rounded,
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
        if(state is BlogFailure){
          showSnackBar(context: context, content: state.message);
        }else if(state is BlogSuccess){
          Navigator.pop(context);
        }
        },
        builder: (context, state) {
          if(state is BlogLoading){
            return const Loader();
          }
          return Form(
            key: addBlogFormKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              children: [
                GestureDetector(
                  onTap: selectImage,
                  child: DottedBorder(
                    color: AppPallete.borderColor,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [12, 6],
                    strokeWidth: 2,
                    strokeCap: StrokeCap.round,
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: blogImage != null
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                    blogImage!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 25),
                                  child: Icon(
                                    Icons.folder_open_outlined,
                                    size: 50,
                                  ),
                                ),
                                Text(
                                  'Select Your Image',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'Technology',
                      'Business',
                      'Programming',
                      'Entertainment',
                    ]
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsetsDirectional.only(end: 12),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selectedTopics.contains(e)) {
                                    selectedTopics.remove(e);
                                  } else {
                                    selectedTopics.add(e);
                                  }
                                });
                              },
                              child: Chip(
                                label: Text(e),
                                color: selectedTopics.contains(e)
                                    ? const WidgetStatePropertyAll(
                                        AppPallete.gradient1,
                                      )
                                    : null,
                                side: selectedTopics.contains(e)
                                    ? null
                                    : const BorderSide(
                                        color: AppPallete.borderColor,
                                      ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                BlogEditor(
                  myController: blogTitleController,
                  hintTxt: 'Blog Title',
                ),
                BlogEditor(
                  myController: blogContentController,
                  hintTxt: 'Blog Content',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
