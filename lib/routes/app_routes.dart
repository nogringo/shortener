import 'package:get/get.dart';
import 'package:shortener/pages/home/home_page.dart';
import 'package:shortener/pages/resolve/resolve_page.dart';

/// Application route definitions and navigation helpers.
class AppRoutes {
  /// Home route for creating shortened URLs.
  static const String home = '/';

  /// Resolve route pattern for viewing shortened URL content.
  /// Use [resolveRoute] to build the actual route string.
  static const String resolve = '/:key/:authorPrefix';

  /// Builds the resolve route string with the given key and author prefix.
  ///
  /// Example: `AppRoutes.resolveRoute(key: 'au2k', authorPrefix: 'f01e')`
  /// returns `'/au2k/f01e'`
  static String resolveRoute({
    required String key,
    required String authorPrefix,
  }) {
    return '/$key/$authorPrefix';
  }

  /// Navigate to home page, replacing all previous routes.
  static void toHome() {
    Get.offAll(() => const HomePage());
  }

  /// Get all route pages for GetMaterialApp configuration.
  static List<GetPage> get pages => [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(
      name: resolve,
      page: () {
        final routeKey = Get.parameters['key']!;
        final authorPrefix = Get.parameters['authorPrefix']!;
        return ResolvePage(routeKey: routeKey, authorPrefix: authorPrefix);
      },
    ),
  ];
}
