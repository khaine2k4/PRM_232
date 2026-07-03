import "package:go_router/go_router.dart";

import "models/product.dart";
import "providers/auth_provider.dart";
import "screens/cart_screen.dart";
import "screens/login_screen.dart";
import "screens/product_detail_screen.dart";
import "screens/product_form_screen.dart";
import "screens/product_list_screen.dart";
import "screens/register_screen.dart";
import "screens/revenue_screen.dart";

/// Builds the app router. Redirects unauthenticated users to /login and
/// keeps logged-in users out of the auth screens.
GoRouter buildRouter(AuthProvider auth) {
  return GoRouter(
    initialLocation: "/products",
    refreshListenable: auth,
    redirect: (context, state) {
      final loggedIn = auth.isLoggedIn;
      final path = state.matchedLocation;
      final onAuthPage = path == "/login" || path == "/register";
      if (!loggedIn && !onAuthPage) return "/login";
      if (loggedIn && onAuthPage) return "/products";
      // Admin-only areas: product create/edit and revenue.
      final adminOnly = path == "/revenue" ||
          path == "/products/new" ||
          path.endsWith("/edit");
      if (loggedIn && adminOnly && !auth.isAdmin) return "/products";
      return null;
    },
    routes: [
      GoRoute(
        path: "/login",
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: "/register",
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: "/products",
        builder: (context, state) => const ProductListScreen(),
        routes: [
          GoRoute(
            path: "new",
            builder: (context, state) => const ProductFormScreen(),
          ),
          GoRoute(
            path: ":id",
            builder: (context, state) {
              final product = state.extra as Product;
              return ProductDetailScreen(product: product);
            },
            routes: [
              GoRoute(
                path: "edit",
                builder: (context, state) {
                  final product = state.extra as Product;
                  return ProductFormScreen(product: product);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: "/cart",
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: "/revenue",
        builder: (context, state) => const RevenueScreen(),
      ),
    ],
  );
}
