import '../../../../../../../core/config/routes/app.dart';

class ButtonChangePhoto extends StatelessWidget {
  const ButtonChangePhoto({
    super.key,
    required this.isButton,
  });
  final bool isButton;
  @override
  Widget build(BuildContext context) {
    return isButton
        ? Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.zero,
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
        : const SizedBox.shrink();
  }
}
