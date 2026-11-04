import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_settings.freezed.dart';
part 'config_settings.g.dart';

@freezed
abstract class ConfigSettings with _$ConfigSettings {
  factory ConfigSettings({String? baseUrl}) = _ConfigSettings;

  factory ConfigSettings.fromJson(Map<String, dynamic> json) =>
      _$ConfigSettingsFromJson(json);
}
