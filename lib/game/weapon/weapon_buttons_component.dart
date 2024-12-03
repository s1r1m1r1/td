import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/layout.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../../game_controller/domain/game_repository.dart';
import '../../game_controller/game_event.dart';
import '../game_main.dart';
import '../util/priority.dart';

enum ButtonState { unpressed, pressed }

mixin MixinWeaponButtons on HasGameRef<GameMain> {
  PositionComponent? cancelButton;
  PositionComponent? destroyButton;
  PositionComponent? emptyButton;
  StreamSubscription? _subscription;
  bool showed = false;

  void showMenu(
      GameRepository repository, Vector2 parentSize, Vector2 globalPos) {
    if (showed) {
      return;
    }
    showed = true;
    EffectController duration(double x) => EffectController(duration: x);
    final paddingX = (parentSize.x - 50) / 2;
    final paddingY = (parentSize.y - 50) / 2;
    final startPos = Vector2(globalPos.x + paddingX, globalPos.y + paddingY);

    /// T0D0 add in other overlay
    final cancelButton = CancelButtonComponent(
      position: startPos,
      size: Vector2(50, 50),
      priority: Priority.overlay,
      anchor: Anchor.topLeft,
    );
    final destroyButton = DestroyButtonComponent(
      position: startPos,
      size: Vector2(50, 50),
      priority: Priority.overlay,
      anchor: Anchor.topLeft,
    );
    final emptyButton = EmptyButtonComponent(
      position: startPos,
      size: Vector2(50, 50),
      priority: Priority.overlay,
      anchor: Anchor.topLeft,
    );

    cancelButton
      ..add(
        MoveEffect.to(Vector2(startPos.x - 70, startPos.y - 60), duration(0.5)),
      )
      ..add(RotateEffect.to(-0.1, duration(0.3)));
    emptyButton.add(SequenceEffect([
      MoveEffect.to(Vector2(startPos.x, startPos.y - 70), duration(0.5)),
    ]));
    destroyButton
      ..add(
        MoveEffect.to(Vector2(startPos.x + 70, startPos.y - 65), duration(0.5)),
      )
      ..add(RotateEffect.to(0.1, duration(0.3)));

    gameRef.add(cancelButton);
    gameRef.add(emptyButton);
    gameRef.add(destroyButton);

    _subscription?.cancel();
    _subscription = repository.selectedWeaponSubject.stream.listen((selected) {
      if (selected == null) {
        showed = false;
        destroyButton
          ..add(MoveEffect.to(startPos, duration(0.3)))
          ..add(RotateEffect.to(0.0, duration(0.3)))
          ..add(ScaleEffect.to(Vector2.all(0.8), duration(0.2)))
          ..add(RemoveEffect(delay: 0.5));

        cancelButton
          ..add(MoveEffect.to(startPos, duration(0.3)))
          ..add(ScaleEffect.to(Vector2.all(0.8), duration(0.2)))
          ..add(RemoveEffect(delay: 0.5));

        emptyButton
          ..add(MoveEffect.to(startPos, duration(0.3)))
          ..add(RotateEffect.to(0.0, duration(0.3)))
          ..add(ScaleEffect.to(Vector2.all(0.8), duration(0.2)))
          ..add(RemoveEffect(delay: 0.5));
      }
    });
  }

  @override
  void onRemove() {
    _subscription?.cancel();
    super.onRemove();
  }
}

class DestroyButtonComponent extends SpriteGroupComponent<ButtonState>
    with HasGameRef<GameMain>, TapCallbacks {
  DestroyButtonComponent(
      {super.size, super.position, super.priority, super.anchor});

  @override
  Future<void> onLoad() async {
    final pressedSprite = await game.loadSprite(
      'buttons.png',
      srcPosition: Vector2(0, 0),
      srcSize: Vector2(60, 20),
    );
    final unpressedSprite = await game.loadSprite(
      'buttons.png',
      srcSize: Vector2(60, 20),
    );

    sprites = {
      ButtonState.pressed: pressedSprite,
      ButtonState.unpressed: unpressedSprite,
    };

    current = ButtonState.unpressed;
    add(
      RectangleComponent(
        paint: Paint()..color = Colors.transparent,
        size: size,
        children: [
          AlignComponent(
            alignment: const Anchor(.3, .3),
            child: TextComponent(text: 'Destroy', textRenderer: _buttonText),
          )
        ],
      ),
    );
  }

  @override
  void onTapDown(event) {
    current = ButtonState.pressed;
    gameRef.gameController.send(const GameEvent.weaponDestroyed());
  }

  @override
  void onTapUp(event) {
    current = ButtonState.unpressed;
  }

  @override
  void onTapCancel(event) {
    current = ButtonState.unpressed;
  }
}

class CancelButtonComponent extends SpriteGroupComponent<ButtonState>
    with HasGameRef<GameMain>, TapCallbacks {
  CancelButtonComponent(
      {super.size, super.position, super.priority, super.anchor});

  @override
  Future<void> onLoad() async {
    final pressedSprite = await game.loadSprite(
      'buttons.png',
      srcPosition: Vector2(0, 20),
      srcSize: Vector2(60, 20),
    );
    final unpressedSprite = await game.loadSprite(
      'buttons.png',
      srcSize: Vector2(60, 20),
    );

    sprites = {
      ButtonState.pressed: pressedSprite,
      ButtonState.unpressed: unpressedSprite,
    };

    current = ButtonState.unpressed;
    add(
      RectangleComponent(
        paint: Paint()..color = Colors.transparent,
        size: size,
        children: [
          AlignComponent(
            alignment: const Anchor(.3, .3),
            child: TextComponent(text: 'Cancel', textRenderer: _buttonText),
          )
        ],
      ),
    );
  }

  @override
  void onTapDown(event) {
    current = ButtonState.pressed;
    gameRef.gameController.send(const GameEvent.weaponUnSelected());
  }

  @override
  void onTapUp(event) {
    current = ButtonState.unpressed;
  }

  @override
  void onTapCancel(event) {
    current = ButtonState.unpressed;
  }
}

class EmptyButtonComponent extends SpriteGroupComponent<ButtonState>
    with HasGameRef<GameMain>, TapCallbacks {
  EmptyButtonComponent(
      {super.size, super.position, super.priority, super.anchor});

  @override
  Future<void> onLoad() async {
    final pressedSprite = await game.loadSprite(
      'buttons.png',
      srcPosition: Vector2(0, 20),
      srcSize: Vector2(60, 20),
    );
    final unpressedSprite = await game.loadSprite(
      'buttons.png',
      srcSize: Vector2(60, 20),
    );

    sprites = {
      ButtonState.pressed: pressedSprite,
      ButtonState.unpressed: unpressedSprite,
    };

    current = ButtonState.unpressed;
    add(
      RectangleComponent(
        paint: Paint()..color = Colors.transparent,
        size: size,
        children: [
          AlignComponent(
            alignment: const Anchor(.3, .3),
            child: TextComponent(text: 'Empty', textRenderer: _buttonText),
          )
        ],
      ),
    );
  }

  @override
  void onTapDown(event) {
    current = ButtonState.pressed;
  }

  @override
  void onTapUp(event) {
    current = ButtonState.unpressed;
  }

  @override
  void onTapCancel(event) {
    current = ButtonState.unpressed;
  }
}

final _buttonText = TextPaint(
    style: TextStyle(
  fontSize: 14,
  color: BasicPalette.black.color,
));
