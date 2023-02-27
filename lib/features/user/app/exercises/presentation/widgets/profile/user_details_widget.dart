import '../../../../../../../core/config/routes/app.dart';

class UserDetailsWidget extends StatelessWidget {
  const UserDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<ProfileUserCubit, ProfileUserState>(
      builder: (context, state) {
        var cubit = ProfileUserCubit.get(context);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const ProfilePhoto(
              height: 10,
              width: 22,
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.40,
                  padding: EdgeInsets.only(right: 1.w),
                  child: Text(
                    cubit.userData != null
                        ? cubit.userData!.name != ''
                            ? cubit.userData!.name
                            : 'Add Your Name'
                        : 'Loading..',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 17.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(cubit.userEmail),
                SizedBox(height: 2.h),
              ],
            ),
            SizedBox(
              height: 5.h,
              width: 20.w,
              child: MainButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(Routes.profileUserDataScreen);
                },
                text: 'Edit Profile',
                fontSizeText: 8,
                borderRadius: 8,
              ),
            ),
          ],
        );
      },
    );
  }
}
