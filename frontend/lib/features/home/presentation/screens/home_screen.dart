// Fichier : home_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../../history/presentation/screens/alert_history_screen.dart';

import '../../../auth/presentation/screens/login_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../home/presentation/screens/Services-tab-screen.dart';
// import '../../../home/presentation/screens/Alerts-tab-screen.dart';
import '../../../directory/presentation/screens/service_directory_screen.dart';
import '../../../about/presentation/screens/about_screen.dart';
import '../../../chatbot/presentation/screens/chatbot_screen.dart';
import 'home-tab-screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage _secureStorage =
      GetIt.instance<FlutterSecureStorage>();
  int _selectedIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeTabScreen(onNavigateToTab: _navigateToTab),
      // L'onglet AlertsTabScreen a été supprimé car le formulaire d'alerte est maintenant intégré dans service_detail_screen.dart
      const ServicesTabScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatbotScreen(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 53, 126, 120),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // En-tête du drawer avec hauteur personnalisée pour s'aligner avec l'AppBar
            Container(
              height: 70 + MediaQuery.of(context).padding.top, // Même hauteur que l'AppBar + padding du système
              width: double.infinity,
              color: AppColors.appBarColor, // Utiliser la même couleur que l'AppBar
              padding: EdgeInsets.only(top: 30, left: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Color.fromARGB(255, 53, 126, 120)),
              title: const Text('Numero de service'),
              onTap: () {
                Navigator.pop(context); // Ferme le drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServiceDirectoryScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Color.fromARGB(255, 53, 126, 120)),
              title: const Text('Historique des alertes'),
              onTap: () {
                Navigator.pop(context); // Ferme le drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AlertHistoryScreen(),
                  ),
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.settings, color: Color.fromARGB(255, 53, 126, 120)),
              title: Text('Paramètres'),
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Color.fromARGB(255, 53, 126, 120)),
              title: const Text('Assistant Yollë'),
              onTap: () {
                Navigator.pop(context); // Ferme le drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatbotScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Color.fromARGB(255, 53, 126, 120)),
              title: const Text('À propos'),
              onTap: () {
                Navigator.pop(context); // Ferme le drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Déconnexion'),
              onTap: () async {
                // Afficher une boîte de dialogue de confirmation
                final bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Confirmation'),
                    content: const Text('Voulez-vous vraiment vous déconnecter ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Déconnexion'),
                      ),
                    ],
                  ),
                );
                
                // Si l'utilisateur confirme la déconnexion
                if (confirm == true) {
                  if (!context.mounted) return;
                  Navigator.pop(context); // Ferme le drawer
                  
                  // Supprimer le token d'authentification
                  final storage = GetIt.instance<FlutterSecureStorage>();
                  await storage.delete(key: 'auth_token');
                  
                  // Rediriger vers l'écran de connexion
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false, // Supprime toutes les routes précédentes
                  );
                }
              },
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          color: AppColors.appBarColor, // Utilisation de la couleur du thème centralisé
          padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bouton menu (hamburger)
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),

              // Titre centré
              const Expanded(
                child: Center(
                  child: Text(
                    'Yollë',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Espace pour équilibrer l'interface
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'voir +'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // Cette méthode est utilisée par le menu de navigation
  // ignore: unused_element
  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Déconnexion'),
            content: const Text('Etes-vous sûr de vouloir vous déconnecter ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Déconnecter'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await _secureStorage.deleteAll();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
