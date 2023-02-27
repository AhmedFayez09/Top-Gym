
import '../../../../../../../core/config/routes/app.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    Key? key,
    this.isButton = false,
    this.height = 5,
    this.width = 10,
    this.radius = 30,
  }) : super(key: key);
  final bool isButton;
  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Photo(
          height: height,
          width: width,
          radius: radius,
        ),
        ButtonChangePhoto(
          isButton: isButton,
        ),
      ],
    );
  }
}
