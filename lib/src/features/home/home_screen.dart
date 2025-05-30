import 'package:flutter/material.dart';
import 'inicio_screen.dart';
import 'avisos_screen.dart';
import 'reservas_screen.dart';
import 'ajustes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Pantallas reales para cada sección:
  static final List<Widget> _pages = [
    InicioScreen(),
    AvisosScreen(),
    ReservasScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Condominio'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Opciones', style: TextStyle(color: Colors.white, fontSize: 22)),
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
            const ListTile(
              leading: Icon(Icons.group),
              title: Text('Visitas'),
            ),
            const ListTile(
              leading: Icon(Icons.folder),
              title: Text('Documentos'),
            ),
            // <--- AJUSTES NO ES CONST, porque tiene lógica --->
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ajustes'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AjustesScreen()),
                );
              },
            ),
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
            icon: Icon(Icons.calendar_today),
            label: 'Reservas',
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
