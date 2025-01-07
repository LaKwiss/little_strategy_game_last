// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lootbox_provider_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LootboxProviderState {
  LootboxProviderStatus get status => throw _privateConstructorUsedError;
  List<Loot> get lootList => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of LootboxProviderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LootboxProviderStateCopyWith<LootboxProviderState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LootboxProviderStateCopyWith<$Res> {
  factory $LootboxProviderStateCopyWith(LootboxProviderState value,
          $Res Function(LootboxProviderState) then) =
      _$LootboxProviderStateCopyWithImpl<$Res, LootboxProviderState>;
  @useResult
  $Res call({LootboxProviderStatus status, List<Loot> lootList, String? error});
}

/// @nodoc
class _$LootboxProviderStateCopyWithImpl<$Res,
        $Val extends LootboxProviderState>
    implements $LootboxProviderStateCopyWith<$Res> {
  _$LootboxProviderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LootboxProviderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? lootList = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LootboxProviderStatus,
      lootList: null == lootList
          ? _value.lootList
          : lootList // ignore: cast_nullable_to_non_nullable
              as List<Loot>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LootboxProviderStateImplCopyWith<$Res>
    implements $LootboxProviderStateCopyWith<$Res> {
  factory _$$LootboxProviderStateImplCopyWith(_$LootboxProviderStateImpl value,
          $Res Function(_$LootboxProviderStateImpl) then) =
      __$$LootboxProviderStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LootboxProviderStatus status, List<Loot> lootList, String? error});
}

/// @nodoc
class __$$LootboxProviderStateImplCopyWithImpl<$Res>
    extends _$LootboxProviderStateCopyWithImpl<$Res, _$LootboxProviderStateImpl>
    implements _$$LootboxProviderStateImplCopyWith<$Res> {
  __$$LootboxProviderStateImplCopyWithImpl(_$LootboxProviderStateImpl _value,
      $Res Function(_$LootboxProviderStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LootboxProviderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? lootList = null,
    Object? error = freezed,
  }) {
    return _then(_$LootboxProviderStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LootboxProviderStatus,
      lootList: null == lootList
          ? _value._lootList
          : lootList // ignore: cast_nullable_to_non_nullable
              as List<Loot>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LootboxProviderStateImpl implements _LootboxProviderState {
  const _$LootboxProviderStateImpl(
      {required this.status, required final List<Loot> lootList, this.error})
      : _lootList = lootList;

  @override
  final LootboxProviderStatus status;
  final List<Loot> _lootList;
  @override
  List<Loot> get lootList {
    if (_lootList is EqualUnmodifiableListView) return _lootList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lootList);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'LootboxProviderState(status: $status, lootList: $lootList, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LootboxProviderStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._lootList, _lootList) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status,
      const DeepCollectionEquality().hash(_lootList), error);

  /// Create a copy of LootboxProviderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LootboxProviderStateImplCopyWith<_$LootboxProviderStateImpl>
      get copyWith =>
          __$$LootboxProviderStateImplCopyWithImpl<_$LootboxProviderStateImpl>(
              this, _$identity);
}

abstract class _LootboxProviderState implements LootboxProviderState {
  const factory _LootboxProviderState(
      {required final LootboxProviderStatus status,
      required final List<Loot> lootList,
      final String? error}) = _$LootboxProviderStateImpl;

  @override
  LootboxProviderStatus get status;
  @override
  List<Loot> get lootList;
  @override
  String? get error;

  /// Create a copy of LootboxProviderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LootboxProviderStateImplCopyWith<_$LootboxProviderStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
