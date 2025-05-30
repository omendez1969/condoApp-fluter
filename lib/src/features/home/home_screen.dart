import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../l10n/app_localizations.dart';
import 'inicio_screen.dart';
import 'avisos_screen.dart';
import 'visitas_screen.dart';
import 'reservas_screen.dart';
import 'ajustes_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoggingOut = false;

  // Pantallas reales para cada sección:
  static final List<Widget> _pages = [
    InicioScreen(),
    AvisosScreen(),
    VisitasScreen(),
    Center(child: Text('Menú', style: TextStyle(fontSize: 28))),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _showLogoutConfirmDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return showDialog(
      context: context,
      barrierDismissible: !_isLoggingOut,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => !_isLoggingOut,
          child: AlertDialog(
            icon: Icon(
              Icons.logout_rounded,
              color: colorScheme.error,
              size: 32,
            ),
            title: Text(
              l10n.logoutConfirmTitle,
              style: TextStyle(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              l10n.logoutConfirmMessage,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              TextButton(
                onPressed: _isLoggingOut 
                  ? null 
                  : () => Navigator.of(context).pop(),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    color: _isLoggingOut 
                      ? colorScheme.onSurface.withOpacity(0.38)
                      : colorScheme.primary,
                  ),
                ),
              ),
              FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.errorContainer,
                  foregroundColor: colorScheme.onErrorContainer,
                  disabledBackgroundColor: colorScheme.errorContainer.withOpacity(0.12),
                  disabledForegroundColor: colorScheme.onErrorContainer.withOpacity(0.38),
                ),
                onPressed: _isLoggingOut ? null : _handleLogout,
                child: _isLoggingOut
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onErrorContainer.withOpacity(0.38),
                        ),
                      ),
                    )
                  : Text(l10n.confirm),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Cerrar el diálogo
        final colorScheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: colorScheme.onError,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.unexpectedError,
                    style: TextStyle(color: colorScheme.onError),
                  ),
                ),
              ],
            ),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Condominio'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.primary,
              ),
              child: Text(
                'Opciones',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.pool),
              title: Text('Config. Amenidades'),
            ),
            const ListTile(
              leading: Icon(Icons.report_problem),
              title: Text('Incidencias'),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
            ),
            const ListTile(
              leading: Icon(Icons.how_to_vote),
              title: Text('Votaciones'),
            ),
            const ListTile(
              leading: Icon(Icons.payment),
              title: Text('Pagos'),
            ),
            const ListTile(
              leading: Icon(Icons.local_shipping),
              title: Text('Paquetería'),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Reservas'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReservasScreen()),
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.folder),
              title: Text('Documentos'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                'Ajustes',
                style: textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AjustesScreen()),
                );
              },
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color: colorScheme.error,
                size: 26,
              ),
              title: Text(
                l10n.logout,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                _showLogoutConfirmDialog();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex == 3 ? 0 : _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Avisos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Visitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menú',
          ),
        ],
      ),
    );
  }
}
