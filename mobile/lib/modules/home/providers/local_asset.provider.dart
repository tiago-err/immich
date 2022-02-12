import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/shared/models/immich_asset.model.dart';
import 'package:immich_mobile/shared/services/device_info.service.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:immich_mobile/modules/home/services/asset.service.dart';
import 'package:immich_mobile/shared/models/backup_asset.model.dart';
import 'package:collection/collection.dart';

class LocalAssetNotifier extends StateNotifier<List<ImmichAsset>> {
  LocalAssetNotifier() : super([]);

  final AssetService _assetService = AssetService();
  final DeviceInfoService _deviceInfoService = DeviceInfoService();

  getLocalAsset() async {
    List<ImmichAsset> ultimateAsset = [];
    var deviceInfo = await _deviceInfoService.getDeviceInfo();
    var deviceId = deviceInfo["deviceId"];
    List<AssetEntity>? localAssets = await _assetService.getLocalAsset();

    if (localAssets != null) {
      for (var asset in localAssets) {
        ultimateAsset.add(
          ImmichAsset(
              assetId: asset.id,
              deviceId: deviceId,
              mediaType: asset.type,
              createdDate: asset.createDateTime,
              type: "local",
              localAsset: asset,
              backupAsset: null),
        );
      }
    }

    List<BackupAsset>? backupAsset = await _assetService.getBackupAsset();

    if (backupAsset != null) {
      for (var asset in backupAsset) {
        ultimateAsset.add(
          ImmichAsset(
            assetId: asset.deviceAssetId,
            deviceId: asset.deviceId,
            mediaType: asset.type == "IMAGE" ? AssetType.image : AssetType.video,
            type: "backup",
            createdDate: DateTime.parse(asset.createdAt),
            localAsset: null,
            backupAsset: asset,
          ),
        );
      }
    }

    List<ImmichAsset> distinctAsset = ultimateAsset.toSet().toList();

    distinctAsset.sortByCompare<DateTime>((element) => element.createdDate, (a, b) => b.compareTo(a));

    var groupList = distinctAsset.groupListsBy((element) => DateFormat('yMd').format(element.createdDate));

    print(groupList);

    state = distinctAsset;
  }
}

final localAssetProvider = StateNotifierProvider<LocalAssetNotifier, List<ImmichAsset>>((ref) {
  return LocalAssetNotifier();
});
