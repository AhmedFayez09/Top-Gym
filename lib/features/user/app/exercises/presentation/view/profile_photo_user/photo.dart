import '../../../../../../../core/config/routes/app.dart';

class Photo extends StatelessWidget {
  const Photo({
    super.key,
    required this.height,
    required this.radius,
    required this.width,
  });
  final double radius;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUserCubit, ProfileUserState>(
      builder: (context, state) {
        ProfileUserCubit cubit = ProfileUserCubit.get(context);
        String imageUser = cubit.userData!.imageUrl;
        return imageUser != ''
            ? state is UploadUserImageLoading
                ? CircleAvatar(
                    radius: radius,
                    backgroundColor: AppColor.noColor,
                    child: const CircularProgressIndicator(),
                  )
                : CacheNetworkImageComponant(
                    height: height,
                    width: width,
                    image: imageUser,
                  )
            : CircleAvatar(
                radius: radius,
                backgroundImage: const AssetImage(AppImages.noPerson),
              );
      },
    );
  }
}
