part of 'inventory_bloc.dart';

enum InventoryStatus { show, hide }

class InventoryState extends Equatable {
  final List<int> weaponBaseCost;
  final List<WeaponType> listWeapons;
  final List<int> weaponCost;
  final WeaponType weapon;
  final InventoryStatus status;

  const InventoryState._({
    this.listWeapons = const <WeaponType>[],
    this.weaponBaseCost = const <int>[],
    this.weaponCost = const <int>[],
    this.weapon = WeaponType.none,
    this.status = InventoryStatus.hide,
  });

  const InventoryState.empty() : this._();
  InventoryState setParameters(
          {required List<int> weaponBaseCost,
          required List<WeaponType> listWeapons,
          required List<int> listCost}) =>
      _copyWith(
          weaponBaseCost: weaponBaseCost,
          listWeapons: listWeapons,
          weaponCost: listCost);
  InventoryState selectWeapon(WeaponType type) => _copyWith(weapon: type);
  InventoryState setCost(List<int> weaponCost) =>
      _copyWith(weaponCost: weaponCost);

  InventoryState _copyWith({
    List<WeaponType>? listWeapons,
    List<int>? weaponBaseCost,
    List<int>? weaponCost,
    WeaponType? weapon,
  }) {
    return InventoryState._(
        listWeapons: listWeapons ?? this.listWeapons,
        weaponBaseCost: weaponBaseCost ?? this.weaponBaseCost,
        weaponCost: weaponCost ?? this.weaponCost,
        weapon: weapon ?? this.weapon);
  }

  @override
  List<Object> get props => [weapon, weaponCost, listWeapons, weaponBaseCost];
}
