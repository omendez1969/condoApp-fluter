import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Nombres e íconos para el BottomNavigationBar
  static const List<Widget> _pages = [
    Center(child: Text('Inicio', style: TextStyle(fontSize: 28))),
    Center(child: Text('Avisos', style: TextStyle(fontSize: 28))),
    Center(child: Text('Reservas', style: TextStyle(fontSize: 28))),
    // El menú no muestra contenido, solo abre el Drawer
    Center(child: Text('Menú', style: TextStyle(fontSize: 28))),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      // Abre el Drawer al pulsar el ícono de menú
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
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Opciones', style: TextStyle(color: Colors.white, fontSize: 22)),
            ),
            ListTile(
              leading: Icon(Icons.pool),
              title: Text('Config. Amenidades'),
            ),
            ListTile(
              leading: Icon(Icons.report_problem),
              title: Text('Incidencias'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
            ),
            ListTile(
              leading: Icon(Icons.how_to_vote),
              title: Text('Votaciones'),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Pagos'),
            ),
            ListTile(
              leading: Icon(Icons.local_shipping),
              title: Text('Paquetería'),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Visitas'),
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Documentos'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ajustes'),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex == 3 ? 0 : _selectedIndex, // No resalta el menú
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
