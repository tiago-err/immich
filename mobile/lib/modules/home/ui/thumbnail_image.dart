import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/constants/hive_box.dart';
import 'package:immich_mobile/modules/home/providers/home_page_state.provider.dart';
import 'package:immich_mobile/routing/router.dart';
import 'package:immich_mobile/shared/models/immich_asset.model.dart';
import 'package:photo_manager/photo_manager.dart';

class ThumbnailImage extends HookConsumerWidget {
  final ImmichAsset asset;

  const ThumbnailImage({Key? key, required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var endpoint = Hive.box(userInfoBox).get(serverEndpointKey);
    var thumbnailRequestUrl =
        '$endpoint/asset/file?aid=${asset.backupAsset?.deviceAssetId}&did=${asset.backupAsset?.deviceId}&isThumb=true';

    var selectedAsset = ref.watch(homePageStateProvider).selectedItems;
    var isMultiSelectEnable = ref.watch(homePageStateProvider).isMultiSelectEnable;

    Widget _buildSelectionIcon(ImmichAsset asset) {
      if (selectedAsset.contains(asset)) {
        return Icon(
          Icons.check_circle,
          color: Theme.of(context).primaryColor,
        );
      } else {
        return const Icon(
          Icons.circle_outlined,
          color: Colors.white,
        );
      }
    }

    Future<Uint8List?> getThumbData(ImmichAsset asset) async {
      if (asset.type == ImmichAssetType.local) {
        var thumbData = await asset.localAsset!.thumbDataWithSize(300, 300);
        return thumbData;
      }
      return null;
    }

    return GestureDetector(
      onTap: () {
        if (isMultiSelectEnable && selectedAsset.contains(asset) && selectedAsset.length == 1) {
          ref.watch(homePageStateProvider.notifier).disableMultiSelect();
        } else if (isMultiSelectEnable && selectedAsset.contains(asset) && selectedAsset.length > 1) {
          ref.watch(homePageStateProvider.notifier).removeSingleSelectedItem(asset);
        } else if (isMultiSelectEnable && !selectedAsset.contains(asset)) {
          ref.watch(homePageStateProvider.notifier).addSingleSelectedItem(asset);
        } else {
          if (asset.mediaType == AssetType.image && asset.type == ImmichAssetType.backup) {
            if (asset.backupAsset != null) {
              print(asset.backupAsset);
              AutoRouter.of(context).push(
                ImageViewerRoute(
                  imageUrl:
                      '$endpoint/asset/file?aid=${asset.backupAsset?.deviceAssetId}&did=${asset.backupAsset?.deviceId}&isThumb=false',
                  heroTag: asset.assetId,
                  thumbnailUrl: thumbnailRequestUrl,
                  asset: asset.backupAsset!,
                ),
              );
            }
          } else if (asset.mediaType == AssetType.image && asset.type == ImmichAssetType.local) {
            debugPrint("Show image from local");
          } else {
            AutoRouter.of(context).push(
              VideoViewerRoute(
                videoUrl:
                    '$endpoint/asset/file?aid=${asset.backupAsset?.deviceAssetId}&did=${asset.backupAsset?.deviceId}',
              ),
            );
          }
        }
      },
      onLongPress: () {
        // Enable multi selecte function
        ref.watch(homePageStateProvider.notifier).enableMultiSelect({asset});
        HapticFeedback.heavyImpact();
      },
      child: Hero(
        tag: asset.assetId,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: isMultiSelectEnable && selectedAsset.contains(asset)
                    ? Border.all(color: Theme.of(context).primaryColorLight, width: 10)
                    : const Border(),
              ),
              child: asset.type == ImmichAssetType.backup
                  ? CachedNetworkImage(
                      cacheKey: asset.assetId,
                      width: 300,
                      height: 300,
                      memCacheHeight: asset.mediaType == AssetType.image ? 250 : 400,
                      fit: BoxFit.cover,
                      imageUrl: thumbnailRequestUrl,
                      httpHeaders: {"Authorization": "Bearer ${Hive.box(userInfoBox).get(accessTokenKey)}"},
                      fadeInDuration: const Duration(milliseconds: 150),
                      progressIndicatorBuilder: (context, url, downloadProgress) => Transform.scale(
                        scale: 0.1,
                        child: CircularProgressIndicator(value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) {
                        return const Icon(Icons.error);
                      },
                    )
                  : FutureBuilder<Uint8List?>(
                      future: getThumbData(asset),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                            width: 300,
                            height: 300,
                            cacheHeight: 250,
                          );
                        } else {
                          return Transform.scale(
                            scale: 0.1,
                            child: const CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
            ),
            Container(
              child: isMultiSelectEnable
                  ? Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: _buildSelectionIcon(asset),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
