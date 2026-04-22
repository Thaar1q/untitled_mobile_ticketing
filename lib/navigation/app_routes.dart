class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const tickets = '/tickets';
  static const createTicket = '/tickets/create';
  static const ticketDetail = '/tickets/:ticketId';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const adminTickets = '/admin/tickets';
  static const forbidden = '/forbidden';

  static String ticketDetailPath(String ticketId) => '/tickets/$ticketId';
}
