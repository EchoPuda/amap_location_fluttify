// ignore_for_file: non_constant_identifier_names
import 'package:amap_location_fluttify/src/android/android.export.g.dart';
import 'package:amap_location_fluttify/src/ios/ios.export.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'enums.dart';

extension AMapGeoFenceManagerX on AMapGeoFenceManager {
  // 由于ios端的枚举实际上是由int构成的, 所以枚举值拿来`或`, 但是dart这边枚举就是枚举, 或了之后就只能是int了
  // 这里需要加一个传递int值的相同方法
  Future<void> set_activeActionX(int activeAction) async {
    await MethodChannel('me.yohom/amap_location_fluttify').invokeMethod(
      'AMapGeoFenceManager::set_activeAction',
      {'refId': refId, "activeAction": activeAction},
    );
  }
}

extension GeoFenceStatusX on GeoFenceStatus {
  static GeoFenceStatus fromAndroid(int androidModel) {
    return GeoFenceStatus.values[androidModel];
  }

  static GeoFenceStatus fromIOS(AMapGeoFenceRegionStatus iosModel) {
    switch (iosModel) {
      case AMapGeoFenceRegionStatus.AMapGeoFenceRegionStatusUnknown:
        return GeoFenceStatus.Unknown;
      case AMapGeoFenceRegionStatus.AMapGeoFenceRegionStatusInside:
        return GeoFenceStatus.In;
      case AMapGeoFenceRegionStatus.AMapGeoFenceRegionStatusOutside:
        return GeoFenceStatus.Out;
      case AMapGeoFenceRegionStatus.AMapGeoFenceRegionStatusStayed:
        return GeoFenceStatus.Stayed;
      default:
        return GeoFenceStatus.Unknown;
    }
  }
}

extension com_amap_api_fence_GeoFenceClient_X
    on com_amap_api_fence_GeoFenceClient {
  Future<void> addCircleGeoFence(
    int activeAction,
    com_amap_api_location_DPoint center,
    double radius,
    String customId,
  ) async {
    await MethodChannel('me.yohom/amap_location_fluttify').invokeMethod(
      'com.amap.api.fence.GeoFenceClient::addCircleGeoFenceX',
      {
        'refId': refId,
        'activeAction': activeAction,
        'center': center.refId,
        'radius': radius,
        'customId': customId,
      },
    );
  }

  Future<void> addPoiGeoFence({
    @required String keyword,
    String poiType,
    String city,
    int aroundRadius,
    String customId = '',
    int activeAction,
  }) async {
    await MethodChannel('me.yohom/amap_location_fluttify').invokeMethod(
      'com.amap.api.fence.GeoFenceClient::addPoiGeoFenceX',
      {
        'refId': refId,
        'activeAction': activeAction,
        'keyword': keyword,
        'poiType': poiType,
        'city': city,
        'size': aroundRadius,
        'customId': customId,
      },
    );
  }

  Future<void> addPolygonGeoFence({
    @required List<com_amap_api_location_DPoint> polygon,
    String customId = '',
    int activeAction,
  }) async {
    await MethodChannel('me.yohom/amap_location_fluttify').invokeMethod(
      'com.amap.api.fence.GeoFenceClient::addPolygonGeoFenceX',
      {
        'refId': refId,
        'polygon': polygon.map((e) => e.refId).toList(),
        'customId': customId,
      },
    );
  }
}

extension ListX on List<GeoFenceActiveAction> {
  int getActiveAction() {
    debugPrint('激活动作: $this');
    int activeAction = 0;
    if (contains(GeoFenceActiveAction.In)) {
      activeAction |= com_amap_api_fence_GeoFenceClient.GEOFENCE_IN;
    }
    if (contains(GeoFenceActiveAction.Out)) {
      activeAction |= com_amap_api_fence_GeoFenceClient.GEOFENCE_OUT;
    }
    if (contains(GeoFenceActiveAction.Stayed)) {
      activeAction |= com_amap_api_fence_GeoFenceClient.GEOFENCE_STAYED;
    }
    debugPrint('激活动作解析结果: $activeAction');
    return activeAction;
  }
}
