import 'base_env.dart';

class ProdConfig implements BaseConfig {
  @override
  String get baseUrl => "http://35.244.29.180:3333/";

  @override
  int get connectTimeout => 10000;

  @override
  int get receiveTimeout => 5000;
}
