/// Centralized API Configuration for KKRTC
class ApiConfig {
  // Base URLs
  // Android Emulator default is 10.0.2.2 to access host machine
  static const String defaultEmulatorBaseUrl = 'http://10.0.2.2:8000/api';
  static const String defaultLocalhostBaseUrl = 'http://localhost:8000/api';

  // Configurable active base URL (can be swapped in settings or build flavors)
  static String activeBaseUrl = defaultEmulatorBaseUrl;

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Authentication Endpoints
  static const String loginEndpoint = '/auth/login/';
  static const String verifyOtpEndpoint = '/auth/verify-otp/';
  static const String tokenRefreshEndpoint = '/auth/token/refresh/';
  static const String userProfileEndpoint = '/auth/profile/';

  // Bus & Route Endpoints
  static const String searchBusesEndpoint = '/passenger/trips/search/';
  static const String popularRoutesEndpoint = '/passenger/routes/popular/';
  static const String stopsEndpoint = '/passenger/stops/';

  // Tracking Endpoints
  static const String liveLocationEndpoint = '/passenger/trips/';
  static const String passengerGpsSubmissionEndpoint = '/passenger/location/';
  static const String driverGpsSubmissionEndpoint = '/driver/location/';

  // Driver Endpoints
  static const String driverAssignedTripsEndpoint = '/driver/assigned-trips/';
  static const String driverStartTripEndpoint = '/driver/trips/start/';
  static const String driverStopTripEndpoint = '/driver/trips/stop/';
}
