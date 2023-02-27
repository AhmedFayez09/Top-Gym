import 'package:top_gym/features/user/app/exercises/presentation/view/user_details/field_user_details.dart';
import '../../../../../../core/config/routes/app.dart';

class ProfileUSerDataScreen extends StatelessWidget {
  const ProfileUSerDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.wColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).cardColor,
          ),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Theme.of(context).cardColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ProfilePhoto(
            isButton: true,
            height: 20,
            width: 43,
            radius: 60,
          ),
          SizedBox(height: 3.h),
          Text(
            'Your Information',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).cardColor,
                ),
          ),
          SizedBox(height: 3.h),
          FieldUserDetails(),
        ],
      ),
    );
  }
}
