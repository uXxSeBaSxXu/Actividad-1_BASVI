import 'package:basvi/pantallaCarrito.dart';
import 'package:basvi/pantallaFavoritos.dart';
import 'package:basvi/pantallaProducto.dart';
import 'package:basvi/pantallaUsuario.dart';
import 'package:basvi/pantallaPedidos.dart';
import 'package:basvi/model/catalogo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basvi/colors.dart';
import 'package:provider/provider.dart';
import 'package:basvi/carrito/carrito.dart';
import 'package:basvi/carrito/favoritos.dart';
import 'package:basvi/login.dart';

class PantallaCarta extends StatefulWidget {

  final int tabInicial;

  const PantallaCarta({
    super.key,
    this.tabInicial = 0,
  });

  @override
  State<PantallaCarta> createState() => _PantallaCartaState();

}

class _PantallaCartaState extends State<PantallaCarta> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Carrito>(
      builder: (context, carrito, child) {
        return DefaultTabController(
          length: 4,
          initialIndex: widget.tabInicial,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text("Catálogo", style: TextStyle(color: Colors.white)),
              elevation: 0,

              actions: [
                new Stack(
                  children:[
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext) => const PantallaCarrito(),
                          ),
                        );
                      },
                    ),
                    new Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(carrito.numeroItems.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),),
                      ),
                    )
                  ]
                )
              ],

              bottom: TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: <Widget>[
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        "VINOS",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        "LICORES",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        "WHISKY",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text("RON", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),

            drawer: MenuLateral(),
            body: TabBarView(
              children: [
                construirCatalogo(vinos),
                construirCatalogo(licores),
                construirCatalogo(whisky),
                construirCatalogo(ron),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget construirCatalogo(List<Catalogo> productos) {
    final carrito = Provider.of<Carrito>(context, listen: false);
    final favoritos = Provider.of<Favoritos>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: productos.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
          childAspectRatio: MediaQuery.of(context).size.width > 1200
              ? 1.0
              : MediaQuery.of(context).size.width > 900
              ? 0.80
              : MediaQuery.of(context).size.width > 600
              ? 0.60
              : 0.46,
          crossAxisSpacing: 10,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          final producto = productos[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PantallaProducto(
                    producto: producto,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFE6E6E6),
                    blurRadius: 10,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width > 900 ? 140 : 200,
                            child: Image.asset(
                              "assets/img/" + productos[index].imagen,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        Text(
                          producto.nombre,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "\$"+
                          "${producto.precio} MXN",
                          style: const TextStyle(fontSize: 18),
                        ),

                        const SizedBox(height: 15),

                        ElevatedButton.icon(
                          onPressed: () {
                            carrito.agregarItem(
                              producto.id.toString(),
                              producto.nombre,
                              producto.precio,
                              "1",
                              producto.imagen,
                              1,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Se agregó al carrito"),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Agregar",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () async{
                          await favoritos.agregarFavorito(
                            producto.id.toString(),
                            producto.nombre,
                            producto.precio,
                            "1",
                            producto.imagen,
                            1,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Agregado a favoritos ❤️"),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(color: AppColors.primary),
            child: Center(
              child: Text(
                "BASVI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: AppColors.primary),
                  title: Text("INICIO"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext) => const PantallaCarta(),
                      ),
                    );
                  },
                ),

                ExpansionTile(
                  leading: Icon(Icons.category, color: AppColors.primary),
                  title: Text("CATEGORIAS"),
                  children: [

                    ListTile(
                      leading: Icon(Icons.wine_bar),
                      title: Text("Vinos"),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PantallaCarta(
                              tabInicial: 0,
                            ),
                          ),
                        );
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.local_bar),
                      title: Text("Licores"),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PantallaCarta(
                              tabInicial: 1,
                            ),
                          ),
                        );
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.liquor),
                      title: Text("Whisky"),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PantallaCarta(
                              tabInicial: 2,
                            ),
                          ),
                        );
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.liquor),
                      title: Text("Ron"),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PantallaCarta(
                              tabInicial: 3,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                ListTile(
                  leading: Icon(Icons.favorite, color: AppColors.primary),
                  title: Text("FAVORITOS"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext) => const PantallaFavoritos(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.shopping_cart, color: AppColors.primary),
                  title: Text("PEDIDOS"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext) => const PantallaPedidos(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.person, color: AppColors.primary),
                  title: Text("USUARIO"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context)=> const PantallaUsuario(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          Divider(height: 1),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("CERRAR SESIÓN"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();

              Provider.of<Favoritos>(
                  context,
                  listen:false
              ).removeAll();


              Provider.of<Carrito>(
                  context,
                  listen:false
              ).removeAll();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const Login(),
                ),
              );
            },
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}
