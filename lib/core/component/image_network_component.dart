import '../config/routes/app.dart';

class ImageNetworkComponent extends StatelessWidget {
  const ImageNetworkComponent({Key? key, required this.image})
      : super(key: key);
  final String? image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.sp),
      child: Image.network(
        fit: BoxFit.contain,
        image ?? AppNetworkImage.noPhoto,
        // cacheHeight: 15.h.toInt(),
        // cacheWidth: 35.w.toInt(),
        height: 12.h,
        width: 28.w,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(seconds: 5),
            curve: Curves.easeOut,
            child: child,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              // value: loadingProgress.expectedTotalBytes != null
              //     ? loadingProgress.cumulativeBytesLoaded /
              //         loadingProgress.expectedTotalBytes!
              //     : null,

              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text(
              '😢',
              style: TextStyle(fontSize: 40),
            ),
          );
        },
      ),
    );
  }
}

class CacheNetworkImageComponant extends StatelessWidget {
  const CacheNetworkImageComponant({
    super.key,
    required this.image,
    this.height = 5,
    this.width = 5,
  });
  final String? image;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.sp),
      child: CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) {
          return Center(
            child: CircularProgressIndicator(
              value: progress.progress,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        },
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 50,
          backgroundImage: imageProvider,
        ),
        errorWidget: (context, url, error) {
          return const Center(
            child: Text('😢'),
          );
        },
        fit: BoxFit.contain,
        imageUrl: image ?? AppNetworkImage.noPhoto,
        height: height.h,
        width: width.w,
      ),
    );
  }
}
