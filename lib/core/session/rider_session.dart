class RiderSession {
  RiderSession._();

  static String? phoneKey;
  static String? phone;
  static String? name;

  static bool get hasUser => phoneKey != null && phone != null;

  static void setUser({
    required String key,
    required String phoneNumber,
    required String riderName,
  }) {
    phoneKey = key;
    phone = phoneNumber;
    name = riderName;
  }
}
