// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get message => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;
  int get gamesLeft => throw _privateConstructorUsedError;
  String get subscriptionStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String message,
      int userId,
      String userName,
      String accessToken,
      int gamesLeft,
      String subscriptionStatus});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? userId = null,
    Object? userName = null,
    Object? accessToken = null,
    Object? gamesLeft = null,
    Object? subscriptionStatus = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      gamesLeft: null == gamesLeft
          ? _value.gamesLeft
          : gamesLeft // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      int userId,
      String userName,
      String accessToken,
      int gamesLeft,
      String subscriptionStatus});
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$_User>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? userId = null,
    Object? userName = null,
    Object? accessToken = null,
    Object? gamesLeft = null,
    Object? subscriptionStatus = null,
  }) {
    return _then(_$_User(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      gamesLeft: null == gamesLeft
          ? _value.gamesLeft
          : gamesLeft // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_User with DiagnosticableTreeMixin implements _User {
  const _$_User(
      {required this.message,
      required this.userId,
      required this.userName,
      required this.accessToken,
      required this.gamesLeft,
      required this.subscriptionStatus});

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String message;
  @override
  final int userId;
  @override
  final String userName;
  @override
  final String accessToken;
  @override
  final int gamesLeft;
  @override
  final String subscriptionStatus;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'User(message: $message, userId: $userId, userName: $userName, accessToken: $accessToken, gamesLeft: $gamesLeft, subscriptionStatus: $subscriptionStatus)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'User'))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('userName', userName))
      ..add(DiagnosticsProperty('accessToken', accessToken))
      ..add(DiagnosticsProperty('gamesLeft', gamesLeft))
      ..add(DiagnosticsProperty('subscriptionStatus', subscriptionStatus));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.gamesLeft, gamesLeft) ||
                other.gamesLeft == gamesLeft) &&
            (identical(other.subscriptionStatus, subscriptionStatus) ||
                other.subscriptionStatus == subscriptionStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, userId, userName,
      accessToken, gamesLeft, subscriptionStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String message,
      required final int userId,
      required final String userName,
      required final String accessToken,
      required final int gamesLeft,
      required final String subscriptionStatus}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get message;
  @override
  int get userId;
  @override
  String get userName;
  @override
  String get accessToken;
  @override
  int get gamesLeft;
  @override
  String get subscriptionStatus;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}
