import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/ui/backup_asset_thumbnail.dart';
import 'package:immich_mobile/modules/home/ui/local_asset_thumbnail.dart';
import 'package:immich_mobile/shared/models/immich_asset.model.dart';

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
          return assetGroup[index].type == ImmichAssetType.local
              ? LocalAssetThumbnail(localImmichAsset: assetGroup[index])
              : BackupAssetThumbnail(backupImmichAsset: assetGroup[index]);
        },
        childCount: assetGroup.length,
      ),
    );
  }
}
