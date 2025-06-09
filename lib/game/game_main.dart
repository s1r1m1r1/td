import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

import '../game_controller/game_controller.dart';
import '../game_controller/game_event.dart';
import 'game_setting.dart';
import 'map/map_controller.dart';

class GameMain extends FlameGame with TapCallbacks {
  late MapController mapController;
  GameController gameController;

  bool loadDone = false;

  GameSetting setting = GameSetting();

  GameMain({required this.gameController});
  StreamSubscription? _weaponMenuSubscription;

  @override
  void onGameResize(Vector2 size) {
    if (!loadDone) {
      setting.setScreenSize(size);
    }
    super.onGameResize(size);
  }

  int currentTimeMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // await setting.onLoad();
    await setting.neutual.load();

    mapController = MapController(
      tileSize: setting.mapTileSize,
      mapGrid: setting.mapGrid,
    );
    /*game controller should have same range as map */
    await setting.weapons.load();

    add(mapController);
    add(gameController);
    if (kDebugMode) {
      add(FpsTextComponent(position: Vector2(0, size.y - 24)));
    }

    setting.enemies.load();

    loadDone = true;
    pauseEngine();
  }

  void start() {
    if (loadDone) {
      gameController.send(const GameEvent.enemySpawn());
    }
  }

  @override
  void onDispose() {
    _weaponMenuSubscription?.cancel();
    super.onDispose();
  }
}
