import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basvi/carrito/favoritos.dart';
import 'package:basvi/colors.dart';
import 'package:basvi/model/catalogo.dart';
import 'package:basvi/pantallaProducto.dart';

class PantallaFavoritos extends StatefulWidget {

  const PantallaFavoritos({super.key});

  @override
  State<PantallaFavoritos> createState() => _PantallaFavoritosState();

}

class _PantallaFavoritosState extends State<PantallaFavoritos> {


  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      Provider.of<Favoritos>(
        context,
        listen: false,
      ).cargarFavoritos();

    });

  }

  @override
  Widget build(BuildContext context) {

    final favoritos = Provider.of<Favoritos>(context);

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text("Favoritos",
            style: TextStyle(color: Colors.white),
          )
      ),

      body: favoritos.items.isEmpty
          ? Center(
        child: Text(
          "No tienes favoritos",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      )

          : ListView.builder(
        itemCount: favoritos.items.length,
        itemBuilder: (context, index) {

          final item = favoritos.items.values.toList()[index];
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PantallaProducto(
                      producto: Catalogo(
                        id: int.parse(item.id),
                        nombre: item.nombre,
                        precio: item.precio,
                        imagen: item.imagen,
                        descripcion: "",
                      ),
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                elevation: 3,

                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Row(
                    children: [

                      Container(
                        width: 90,
                        height: 90,

                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Image.asset(
                          "assets/img/${item.imagen}",
                          fit: BoxFit.contain,
                        ),
                      ),


                      SizedBox(width: 20),


                      Expanded(
                        child: Text(
                          item.nombre,

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                      ),


                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),

                        onPressed: () {
                          favoritos.removerFavorito(item.id);
                        },
                      ),
                    ],
                  ),
                ),
              )
          );
        },
      ),
    );
  }

}

    /*
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text("Favoritos",
            style: TextStyle(color: Colors.white),
          )
      ),

      body: favoritos.items.isEmpty
          ? Center(
        child: Text(
          "No tienes favoritos",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      )

          : ListView.builder(
        itemCount: favoritos.items.length,
        itemBuilder: (context, index) {

          final item = favoritos.items.values.toList()[index];
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PantallaProducto(
                      producto: Catalogo(
                        id: int.parse(item.id),
                        nombre: item.nombre,
                        precio: item.precio,
                        imagen: item.imagen,
                        descripcion: "",
                      ),
                    ),
                  ),
                );
              },
              child: Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            elevation: 3,

            child: Padding(
              padding: const EdgeInsets.all(12),

              child: Row(
                children: [

                  Container(
                    width: 90,
                    height: 90,

                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Image.asset(
                      "assets/img/${item.imagen}",
                      fit: BoxFit.contain,
                    ),
                  ),


                  SizedBox(width: 20),


                  Expanded(
                    child: Text(
                      item.nombre,

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),

                    ),
                  ),


                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),

                    onPressed: () {
                      favoritos.removerFavorito(item.id);
                    },
                  ),
                ],
              ),
            ),
          )
          );
        },
      ),
    );
    */
