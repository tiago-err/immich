import 'package:immich_mobile/shared/models/backup_asset.model.dart';
import 'package:photo_manager/photo_manager.dart';

class ImmichAsset {
  String assetId;
  String deviceId;
  String type;
  AssetType mediaType;
  DateTime createdDate;
  AssetEntity? localAsset;
  BackupAsset? backupAsset;
  bool isBackup;

  ImmichAsset({
    required this.assetId,
    required this.deviceId,
    required this.type,
    required this.mediaType,
    required this.createdDate,
    required this.isBackup,
    this.localAsset,
    this.backupAsset,
  });

  ImmichAsset copyWith(
      {String? assetId,
      String? deviceId,
      String? type,
      AssetType? mediaType,
      AssetEntity? localAsset,
      BackupAsset? backupAsset,
      DateTime? createdDate,
      bool? isBackup}) {
    return ImmichAsset(
      assetId: assetId ?? this.assetId,
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      createdDate: createdDate ?? this.createdDate,
      mediaType: mediaType ?? this.mediaType,
      localAsset: localAsset ?? this.localAsset,
      backupAsset: backupAsset ?? this.backupAsset,
      isBackup: isBackup ?? this.isBackup,
    );
  }

  @override
  String toString() {
    return 'UltimateAsset(assetId: $assetId, deviceId: $deviceId, type: $type, mediaType: $mediaType, localAsset: $localAsset, backupAsset: $backupAsset, isBackup: $isBackup)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImmichAsset && other.assetId == assetId && other.deviceId == deviceId;
  }

  @override
  int get hashCode {
    return assetId.hashCode ^ deviceId.hashCode;
  }
}
