class Constant {
  //base URL
  static final String baseUrl = "https://rombis.vercel.app/";
  static final String baseAPIUrl = baseUrl + "api/";

  //Authentication
  static const loginApiUrl = "auth/login";
  static const registerApiUrl = "auth/register";
  static const getUser = "auth/session";
  static const checkUsername = "auth/username";
  static const resetPassword = "auth/reset";
  static const logout = "auth/logout";

  static const token = 'token';
  static const userId = 'userId';

  static final username = 'username';
  static final fullname = 'full_name';
  static final password = 'password';

  //bus
  static const buses = "bus";

  //ticket
  static const tickets = "tickets";
  static const booking = "tickets/seats";
  static const uniquePrice = "tickets/seats/uniqueprice";
  static const paymentConfirmation = "tickets/seats/edit";
  static const absen = "tickets/seats/sampai";
}
