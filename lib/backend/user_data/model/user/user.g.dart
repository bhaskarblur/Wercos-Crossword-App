// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      message: json['message'] as String,
      userId: json['userId'] as int,
      userName: json['userName'] as String,
      accessToken: json['accessToken'] as String,
      gamesLeft: json['gamesLeft'] as int,
      subscriptionStatus: json['subscriptionStatus'] as String,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'message': instance.message,
      'userId': instance.userId,
      'userName': instance.userName,
      'accessToken': instance.accessToken,
      'gamesLeft': instance.gamesLeft,
      'subscriptionStatus': instance.subscriptionStatus,
    };
