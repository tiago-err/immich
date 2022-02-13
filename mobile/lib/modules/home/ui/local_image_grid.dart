import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/ui/thumbnail_image.dart';
import 'package:immich_mobile/shared/models/immich_asset.model.dart';
import 'package:photo_manager/photo_manager.dart';

class LocalImageGrid extends ConsumerWidget {
  final List<ImmichAsset> assetGroup;

  const LocalImageGrid({Key? key, required this.assetGroup}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<Uint8List?> getThumbData(ImmichAsset asset) async {
      if (asset.type == 'local') {
        var thumbData = await asset.localAsset!.thumbData;
        return thumbData;
      }
      return null;
    }

    return SliverGrid(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5.0, mainAxisSpacing: 5),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return assetGroup[index].type == 'local'
              ? FutureBuilder<Uint8List?>(
                  future: getThumbData(assetGroup[index]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: 512,
                              height: 512,
                              cacheHeight: 250,
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Text(
                              assetGroup[index].isBackup ? "local+backup" : "local",
                              style:
                                  const TextStyle(color: Color.fromARGB(255, 2, 255, 15), fontWeight: FontWeight.bold),
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
                )
              : Stack(
                  children: [
                    ThumbnailImage(asset: assetGroup[index].backupAsset!),
                    assetGroup[index].mediaType == AssetType.image
                        ? Container()
                        : Positioned(
                            top: 5,
                            right: 5,
                            child: Row(
                              children: [
                                Text(
                                  assetGroup[index].backupAsset!.duration.toString().substring(0, 7),
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
                      bottom: 5,
                      right: 5,
                      child: Icon(
                        assetGroup[index].isBackup ? Icons.cloud_done_outlined : Icons.mobile_friendly_outlined,
                        color: Colors.blue,
                      ),
                    )
                  ],
                );
        },
        childCount: assetGroup.length,
      ),
    );
  }
}
