import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/services/asset.service.dart';
import 'package:immich_mobile/shared/models/backup_asset.model.dart';
import 'package:immich_mobile/shared/models/immich_asset.model.dart';
import 'package:immich_mobile/shared/services/device_info.service.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetNotifier extends StateNotifier<List<ImmichAsset>> {
  final AssetService _assetService = AssetService();
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  bool isFetching = false;

  AssetNotifier() : super([]);

  getAllAsset() async {
    List<ImmichAsset> allAssets = [];

    var deviceInfo = await _deviceInfoService.getDeviceInfo();
    var deviceId = deviceInfo["deviceId"];

    List<AssetEntity>? localAssets = await _assetService.getLocalAsset();

    if (localAssets != null) {
      for (var asset in localAssets) {
        allAssets.add(
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
        allAssets.add(
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

    List<ImmichAsset> distinctAsset = allAssets.toSet().toList();

    distinctAsset.sortByCompare<DateTime>((element) => element.createdDate, (a, b) => b.compareTo(a));

    // var groupList = distinctAsset.groupListsBy((element) => DateFormat('yMd').format(element.createdDate));

    state = distinctAsset;
  }

  clearAllAsset() {
    state = [];
  }
}

final assetProvider = StateNotifierProvider<AssetNotifier, List<ImmichAsset>>((ref) {
  return AssetNotifier();
});

final assetGroupByDateTimeProvider = StateProvider((ref) {
  var assetGroup = ref.watch(assetProvider);

  return assetGroup.groupListsBy((element) => DateFormat('y-MM-dd').format(element.createdDate));
});
