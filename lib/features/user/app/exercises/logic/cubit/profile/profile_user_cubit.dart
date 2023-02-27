import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_gym/core/config/routes/app.dart';

part 'profile_user_state.dart';

class ProfileUserCubit extends Cubit<ProfileUserState> {
  ProfileUserCubit() : super(ProfileUserInitial());

  static ProfileUserCubit get(context) => BlocProvider.of(context);

  bool lang = CacheHelper.getBoolean(key: MyCacheKeys.local);

  void onChangeValue(bool local) {
    emit(FalseValueState());
    lang = local;
    CacheHelper.putBoolean(key: MyCacheKeys.local, value: local);
    print(
        '5555555555555555555555555555555555555555555 $lang 5555555555555555555555555555555555555555555555');
    emit(TrueValueState());
  }

  ///////////////////////////////////////////////////////User Details/////////////////////////////////////////////////////////////////////////
  String userName = '';
  String userImg = '';
  String userEmail = '';

  void initUserDetails() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        userName = user.displayName ?? '';
        userImg = user.photoURL ?? '';
        userEmail = user.email ?? '';
      }
    });
  }

  ////////////////////////////////////////get user data from fireStore///////////////////////////////////////
  // CollectionReference profileData =
  //     FirebaseFirestore.instance.collection('users');

  // Future<void> getData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await profileData.get();
  //
  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) {
  //     doc.data();
  //   }).toList();
  //   log('all Data => ////////////////////////////////////////*********************');
  //   print(allData);
  // }
  void nameUpdateInMainScreen({required String name}) {
    FirebaseAuth.instance.currentUser!.updateDisplayName(name);
  }

  UserData? userData;

  void getUserProfileData() {
    emit(GetUserLoadingStates());
    final uId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userData = UserData.fromMap(value.data()!, uId!);
      emit(GetUserSuccessStates());
    }).catchError((e) {
      emit(GetUserErrorStates(e: e.toString()));
    });
  }

///////////////////////////////////////////////Update date User ////////////////////////////////////////////////////////
//

  void updateDate({required UserDetails key, required String value}) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userData!.uid)
        .update({key.name: value}).then((value) {
      getUserProfileData();
      emit(UpdateDateSuccess());
    }).catchError((e) {
      emit(UpdateDateError());
    });
    emit(NoUpdateDateYet());
  }

  bool isCheck = false;

  void changeAppCheck(bool check) async {
    emit(LightThemeState());
    isCheck = check;
    emit(DarkThemeState());
  }

// this must be initial Function when called the cubit
//   Future<bool> authFingerPrint() async {
//     bool isAuth = false;
//     FingerPrint fingerPrint = FingerPrint();
//     bool isFingerPrintEnabled = await fingerPrint.isFingerPrintEnabled();
//     if (isFingerPrintEnabled) {
//       isAuth = await fingerPrint.isAuth('login using finger print');
//     }
//     return isAuth;
//   }
//
// // check fingerprint
//
//   final FingerPrint fingerPrint = FingerPrint();
//   final storage = const FlutterSecureStorage();
//   bool isSwitchChecked = false;
//   String fPrint = '';
//
//   void checkFingerPrint() async {
//     fPrint = await storage.read(key: Keys.fingerPrint) ?? '';
//     isSwitchChecked = fPrint.isNotEmpty;
//     emit(CheckFingerPrintState());
//   }
//
//   void enableFingerPrint(value) async {
//     bool isFingerPrintEnabled = false;
//     if (value) {
//       isFingerPrintEnabled = await fingerPrint.isFingerPrintEnabled();
//       if (isFingerPrintEnabled) {
//         await storage.write(key: Keys.fingerPrint, value: 'checked');
//       }
//     } else {
//       storage.delete(key: Keys.fingerPrint);
//     }
//     isSwitchChecked = value;
//     print("${value} ********************************************************");
//     emit(EnableFingerPrintState());
//   }

  int titleIndex = 0;

  void changeTitleIndex(int index) {
    emit(CurrentChangeTitleIndex());
    titleIndex = index;
    emit(NextChangeTitleIndex());
  }



  //////////////////////upload user photo///////////////////////////////////
  File? file;
  String? imagePath;
  final imageHelper = ImageHelper();
  String? uploadedImagePath;
  final _cloudStorage = FirebaseStorage.instance;

  Future imageSelector(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "gallery":
        final files = await imageHelper.pickImageFromGallery();
        final croppedFile = await imageHelper.crop(
          file: files!,
          cropStyle: CropStyle.circle,
        );
        if (croppedFile != null) {
          String croppedImage = croppedFile.path.toString();
          file = File(croppedFile.path);
          uploadedImagePath = basename(croppedFile.path);
          emit(UploadUserImageLoading());
          try {
            Reference refStorage = _cloudStorage
                .ref("${ApiPath.productsImage}/$uploadedImagePath");
            await refStorage.putFile(file!);
            updateDate(
              key: UserDetails.imageUrl,
              value: await refStorage.getDownloadURL(),
            );
            emit(UploadUserImageSuccess());
          } catch (e) {
            emit(UploadUserImageError(msg: e.toString()));
          }
        }
        break;
      case "camera":
        final files = await imageHelper.pickImageFromCamera();
        if (files != null) {
          file = File(files.path);
          uploadedImagePath = basename(files.path);
          emit(UploadUserImageLoading());
          try {
            Reference refStorage = _cloudStorage
                .ref("${ApiPath.productsImage}/$uploadedImagePath");
            await refStorage.putFile(file!);
            updateDate(
              key: UserDetails.imageUrl,
              value: await refStorage.getDownloadURL(),
            );
            emit(UploadUserImageSuccess());
          } catch (e) {
            emit(UploadUserImageError(msg: e.toString()));
          }
          break;
        }
    }
  }






}

// import 'package:shared_preferences/shared_preferences.dart';

class ThemeCacheHelper {
  Future<void> cacheTheme(bool themeCon) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("THEME_INDEX", themeCon);
  }

  Future<bool> getCachedTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final cachedTheme = sharedPreferences.getBool("THEME");
    if (cachedTheme != null) {
      return cachedTheme;
    } else {
      return false;
    }
  }
}
