import 'base_env.dart';

class StagingConfig implements BaseConfig {
  @override
  String get baseUrl => "http://3.108.188.179:3333/";

  @override
  int get connectTimeout => 5000;

  @override
  int get receiveTimeout => 3000;
}
