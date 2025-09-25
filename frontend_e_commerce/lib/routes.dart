import 'package:frontend_e_commerce/views/cart/checkout_page.dart';
import 'package:frontend_e_commerce/views/cart/shopping_cart_page.dart';
import 'package:frontend_e_commerce/views/customers/add_customer.dart';
import 'package:frontend_e_commerce/views/customers/customer_invoice.dart';
import 'package:frontend_e_commerce/views/customers/customer_list.dart';
import 'package:frontend_e_commerce/views/customers/update_customer.dart';
import 'package:frontend_e_commerce/views/home_page.dart';
import 'package:frontend_e_commerce/views/invoices/invoice_list.dart';
import 'package:frontend_e_commerce/views/invoices/update_invoice.dart';
import 'package:frontend_e_commerce/views/items/add_item.dart';
import 'package:frontend_e_commerce/views/items/item_list.dart';
import 'package:frontend_e_commerce/views/items/update_item.dart';
import 'package:frontend_e_commerce/views/not_found_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const HomePage()),

      // Items
      GoRoute(
        path: '/items',
        builder: (context, state) => ItemListPage(),
        routes: [
          GoRoute(path: '/add', builder: (context, state) => AddItemPage()),
          GoRoute(
            path: 'update/:id',
            builder: (context, state) {
              final int itemId = int.parse(state.pathParameters['id']!);
              return UpdateItemPage(itemId: itemId);
            },
          ),
        ],
      ),

      // Customers
      GoRoute(
        path: '/customers',
        builder: (context, state) => CustomerList(),
        routes: [
          GoRoute(path: 'add', builder: (_, __) => const AddCustomerPage()),
          GoRoute(
            path: 'update/:id',
            builder: (context, state) {
              final int customerId = int.parse(state.pathParameters['id']!);
              return UpdateCustomerPage(customerId: customerId);
            },
          ),
          GoRoute(
            path: 'invoices/:id',
            builder: (context, state) {
              final int id = int.parse(state.pathParameters['id']!);
              return CustomerInvoicePage(customerId: id);
            },
          ),
        ],
      ),

      // Invoices
      GoRoute(
        path: '/invoices',
        builder: (context, state) => const InvoiceListPage(),
        routes: [
          GoRoute(
            path: '/update/:id',
            builder: (context, state) {
              final int id = int.parse(state.pathParameters['id']!);
              return UpdateInvoicePage(invoiceId: id,);
            },
          ),
        ],
      ),

      // Cart & Checkout
      GoRoute(path: '/cart', builder: (_, __) => const ShoppingCartPage()),
      GoRoute(path: '/checkout', builder: (_, __) => const CheckoutPage()),
    ],

    errorBuilder: (_, __) => const NotFoundPage(),
  );
}
