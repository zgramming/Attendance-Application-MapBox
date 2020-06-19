class AppConfig {
  final String urlApk = '';

  final Map<String, String> headersApi = {'Content-Type': 'application/x-www-form-urlencoded'};

  final String baseImageApiUrl = 'http://www.zimprov.id/absensi_online/images';
  final String baseApiUrl = 'http://www.zimprov.id/absensi_online/api';

  final String indonesiaLocale = 'id_ID';

  final String userController = 'User_controller';
  final String absensiController = 'Absensi_controller';
  final String destinasiController = 'Absensi_controller';

  static const defaultImageNetwork = 'https://flutter.io/images/catalog-widget-placeholder.png';
  static const imageLogoAsset = 'assets/images/logo.png';
  static const emptyDestination = 'assets/images/empty_destination.png';
}

final appConfig = AppConfig();
