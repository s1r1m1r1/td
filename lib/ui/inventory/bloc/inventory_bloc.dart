import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import '../../../settings/weapon_settings.dart';
import '../../../weapon/weapon_component.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc() : super(const InventoryState.empty()) {
    on<InvWeaponSelected>(_onSelected);
    on<InvInit>(_onInit);
    on<InvSetCost>(_onSetCost);
    on<InvAddCost>(_onAddCost);
    on<InvSubstractCost>(_onSubstractCost);
    on<InvShow>(_onShow);
    on<InvHide>(_onHide);

    on<InvReset>(_onReset);
  }

  Future<void> _onInit(InvInit event, Emitter<InventoryState> emit) async {




    emit(
      state.setParameters(
        weaponBaseCost: WeaponSettings.list.map((i) => i.cost).toList(),
        listWeapons: WeaponSettings.list.map((i) => i.type).toList(),
        listCost: WeaponSettings.list.map((i) => i.cost).toList(),
        weaponPath: WeaponSettings.list.map((i) => i.barrelImg0).toList(),
      ),
    );
  }

  void _onSelected(InvWeaponSelected event, Emitter<InventoryState> emit) {
    emit(state.selectWeapon(event.type));
  }

  void _onSetCost(InvSetCost event, Emitter<InventoryState> emit) {
    final newWeaponCost = List.of(state.weaponCost)..[event.index] = event.cost;
    emit(state.setCost(newWeaponCost));
  }

  void _onAddCost(InvAddCost event, Emitter<InventoryState> emit) {
    final cost = (state.weaponBaseCost[event.index] * 0.2).toInt() +
        state.weaponCost[event.index];
    final newWeaponCost = List.of(state.weaponCost)..[event.index] = cost;
    emit(state.setCost(newWeaponCost));
  }

  void _onSubstractCost(InvSubstractCost event, Emitter<InventoryState> emit) {
    final cost = state.weaponCost[event.index] -
        (state.weaponBaseCost[event.index] * 0.2).toInt();
    final newWeaponCost = List.of(state.weaponCost)..[event.index] = cost;
    emit(state.setCost(newWeaponCost));
  }

  void _onShow(InvShow event, Emitter<InventoryState> emit) {}
  void _onHide(InvHide event, Emitter<InventoryState> emit) {}

  void _onReset(InvReset event, Emitter<InventoryState> emit) {
    emit(const InventoryState.empty());
  }
}
