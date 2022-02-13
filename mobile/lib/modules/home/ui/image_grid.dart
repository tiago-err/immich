import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/ui/thumbnail_image.dart';
import 'package:immich_mobile/shared/models/immich_asset.model.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageGrid extends ConsumerWidget {
  final List<ImmichAsset> assetGroup;

  const ImageGrid({Key? key, required this.assetGroup}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverGrid(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5.0, mainAxisSpacing: 5),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return assetGroup[index].type == 'local'
              ? LocalAssetThumbnail(localImmichAsset: assetGroup[index])
              : BackupAssetThumbnail(backupImmichAsset: assetGroup[index]);
        },
        childCount: assetGroup.length,
      ),
    );
  }
}

class LocalAssetThumbnail extends StatelessWidget {
  final ImmichAsset localImmichAsset;

  const LocalAssetThumbnail({
    Key? key,
    required this.localImmichAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<Uint8List?> getThumbData(ImmichAsset asset) async {
      if (asset.type == 'local') {
        var thumbData = await asset.localAsset!.thumbDataWithSize(300, 300);
        return thumbData;
      }
      return null;
    }

    return FutureBuilder<Uint8List?>(
      future: getThumbData(localImmichAsset),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {},
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  width: 300,
                  height: 300,
                  cacheHeight: 250,
                ),
              ),
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
        } else {
          return Container(
            width: 512,
            height: 512,
            color: Colors.grey[400],
          );
        }
      },
    );
  }
}

class BackupAssetThumbnail extends StatelessWidget {
  final ImmichAsset backupImmichAsset;

  const BackupAssetThumbnail({Key? key, required this.backupImmichAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ThumbnailImage(asset: backupImmichAsset.backupAsset!),
        backupImmichAsset.mediaType == AssetType.image
            ? Container()
            : Positioned(
                top: 5,
                right: 5,
                child: Row(
                  children: [
                    Text(
                      backupImmichAsset.backupAsset!.duration.toString().substring(0, 7),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    const Icon(
                      Icons.play_circle_outline_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Icon(
            backupImmichAsset.isBackup ? Icons.cloud_done_outlined : null,
            color: Colors.white,
            size: 15,
          ),
        )
      ],
    );
  }
}
