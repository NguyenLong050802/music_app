import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_app_flutter/src/firebase_service.dart';
import 'package:music_app_flutter/ui/account/sign_in.dart';
import 'package:music_app_flutter/ui/custom/custom_icon_buttom.dart';
import 'package:music_app_flutter/ui/custom/custom_list.dart';
import 'package:music_app_flutter/ui/custom/custom_textfield.dart';

const placeholderImage =
    'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';

class Profile extends StatefulWidget {
  final User user;
  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController nameCtl;
  late User userToEdit;
  late TextEditingController emailCtl;

  @override
  void initState() {
    userToEdit = widget.user;
    nameCtl = TextEditingController(text: userToEdit.displayName ?? '');
    emailCtl = TextEditingController(text: userToEdit.email);
    FirebaseAuth.instance.userChanges().listen((event) {
      if (event != null && mounted) {
        setState(() {
          userToEdit = event;
        });
      }
    });
    super.initState();
  }

  List get userProviders =>
      userToEdit.providerData.map((e) => e.providerId).toList();

  Future updateDisplayName() async {
    await userToEdit.updateDisplayName(nameCtl.text);
  }

  logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 50),
          MyListTitle(
            title: userToEdit.displayName ?? '',
            onTap: null,
            leading: avatar(userToEdit.photoURL ?? placeholderImage, 60, 60),
          ),
          Divider(
            color: Theme.of(context).colorScheme.secondary,
            thickness: 1,
          ),
          MyListTitle(
            leading: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: 'Edit profile',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => _EditProfile(parent: this)));
            },
          ),
          MyListTitle(
            leading: Icon(
              Icons.logout_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: 'Sign Out',
            onTap: logOut,
          ),
        ],
      ),
    );
  }
}

class _EditProfile extends StatefulWidget {
  final _ProfileState parent;
  const _EditProfile({required this.parent});

  @override
  State<_EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<_EditProfile> {
  final formKey = GlobalKey<FormState>();
  final fireBaseService = FireBaseService();
  final picker = ImagePicker();
  ValueNotifier isChange = ValueNotifier(false);
  double uploadProgress = 0.0;
  @override
  void initState() {
    FirebaseAuth.instance.userChanges().listen((event) {
      if (event != null && mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Stack(children: [
                if (uploadProgress > 0)
                  Center(child: LinearProgressIndicator(value: uploadProgress)),
                Center(
                  child: avatar(
                      widget.parent.userToEdit.photoURL ?? placeholderImage,
                      300,
                      300),
                ),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  end: 0,
                  bottom: 0,
                  child: MediaIconButton(
                    icon: Icons.edit_rounded,
                    size: 40,
                    onPressed: pickAndUploadImage,
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              MyTextField(
                controller: widget.parent.nameCtl,
                hintText: 'Name',
                labelText: 'Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value != widget.parent.userToEdit.displayName) {
                    isChange.value = true;
                  } else {
                    isChange.value = false;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: widget.parent.emailCtl,
                hintText: 'Email',
                labelText: 'Email',
                readOnly: true,
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                  valueListenable: isChange,
                  builder: (_, aa, __) {
                    return isChange.value
                        ? MyTextButton(
                            title: 'Save',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                widget.parent.updateDisplayName();
                                fireBaseService.updateUser(
                                    widget.parent.userToEdit.uid, {
                                  'name': widget.parent.nameCtl.text,
                                  'imgUrl': widget.parent.userToEdit.photoURL
                                });
                                isChange.value = false;
                                showMessage('Profile updated', context);
                              }
                            },
                          )
                        : const SizedBox();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future pickAndUploadImage() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      final imageFile = File(image.path);

      // Xóa ảnh cũ nếu có
      final oldPhotoURL = widget.parent.userToEdit.photoURL;
      if (oldPhotoURL != null && oldPhotoURL.isNotEmpty) {
        try {
          final oldFileRef = FirebaseStorage.instance.refFromURL(oldPhotoURL);
          await oldFileRef.delete();
        } catch (e) {
          debugPrint("Error deleting old photo: $e");
        }
      }

      // Tải ảnh mới lên
      final ref = FirebaseStorage.instance
          .ref('avatarImage/${widget.parent.userToEdit.uid}')
          .child(image.name);
      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(await imageFile.readAsBytes());
      } else {
        uploadTask = ref.putFile(imageFile);
      }
      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          uploadProgress = event.bytesTransferred / event.totalBytes;
        });
      });
      Future.value(uploadTask).then((value) {
        value.ref.getDownloadURL().then((url) {
          widget.parent.userToEdit.updatePhotoURL(url);
          setState(() {
            uploadProgress = 0.0;
          });
        });
      });
    }
  }
}
