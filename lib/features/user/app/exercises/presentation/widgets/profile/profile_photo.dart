import 'package:top_gym/app/welcome_view/widgets/show_model_bottom_sheet.dart';

import '../../../../../../../core/config/routes/app.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    Key? key,
    this.isButton = false,
    this.radius = 40,
  }) : super(key: key);
  final bool isButton;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child:
              // userImage != null
              //     ? CircleAvatar(
              //         radius: radius,
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(50.sp),
              //           child: Image.asset(
              //             AppImages.noPerson,
              //             width: 30.w,
              //             height: 14.h,
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //       )
              //     :

              BlocBuilder<ProfileUserCubit, ProfileUserState>(
            builder: (context, state) {
              ProfileUserCubit cubit = ProfileUserCubit.get(context);
              String userImage = cubit.userData!.imageUrl;
              return state is UploadUserImageLoading
                  ? CircleAvatar(
                      radius: radius,
                      child: const CircularProgressIndicator(),
                    )
                  : CircleAvatar(
                      radius: radius,
                      backgroundColor: Colors.black26,
                      backgroundImage: NetworkImage(userImage),
                    );
              // SizedBox(
              // height: 13.h,
              // width: 30.w,
              // child:

              // CircleAvatar(child: ImageNetworkComponent(image: userImage)),
              // );
            },
          ),

          // cubit.userImg == ''
          //     ? CircleAvatar(
          //         radius: 60,
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(50.sp),
          //           child: Image.asset(
          //             AppImages.noPerson,
          //             width: 30.w,
          //             height: 14.h,
          //             fit: BoxFit.fill,
          //           ),
          //         ),
          //       )
          //     : ImageNetworkComponent(image: cubit.userImg),
        ),
        isButton
            ? Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.zero,
                  // padding: EdgeInsets.all(0.002.w),

                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(50.sp)),

                  child: BlocBuilder<ProfileUserCubit, ProfileUserState>(
                    builder: (context, state) {
                      ProfileUserCubit cubit = ProfileUserCubit.get(context);
                      return IconButton(
                        splashColor: AppColor.noColor,
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          showModalBottomSheet(
                            backgroundColor: AppColor.noColor,
                            context: context,
                            builder: (c) => ShowModelBottomSheet(
                              galleryFunction: () {
                                cubit.imageSelector(context, "gallery");
                                // imageSelector(context, "gallery");
                                Navigator.pop(context);
                              },
                              cameraFunction: () {
                                cubit.imageSelector(context, "camera");
                                // imageSelector(context, "camera");
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      );
                    },
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
