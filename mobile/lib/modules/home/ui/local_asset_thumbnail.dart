import 'package:flutter/material.dart';
import 'package:immich_mobile/modules/home/ui/thumbnail_image.dart';
import 'package:immich_mobile/shared/models/immich_asset.model.dart';

class LocalAssetThumbnail extends StatelessWidget {
  final ImmichAsset localImmichAsset;

  const LocalAssetThumbnail({
    Key? key,
    required this.localImmichAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ThumbnailImage(asset: localImmichAsset),
        Positioned(
          bottom: 10,
          right: 10,
          child: Icon(
            localImmichAsset.isBackup ? Icons.cloud_done_outlined : null,
            color: Colors.white,
            size: 15,
          ),
        )
      ],
    );
  }
}
