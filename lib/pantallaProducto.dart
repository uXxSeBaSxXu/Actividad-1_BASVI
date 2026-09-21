import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basvi/model/catalogo.dart';
import 'package:basvi/colors.dart';
import 'package:basvi/carrito/carrito.dart';
import 'package:basvi/carrito/favoritos.dart';

class PantallaProducto extends StatefulWidget {
  final Catalogo producto;

  const PantallaProducto({
    super.key,
    required this.producto,
  });

  @override
  State<PantallaProducto> createState() => _PantallaProductoState();
}

class _PantallaProductoState extends State<PantallaProducto> {
  int cantidad = 1;

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<Carrito>(context, listen: false);
    final favoritos = Provider.of<Favoritos>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.producto.nombre,
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Hero(
              tag: widget.producto.id,
              child: Image.asset(
                "assets/img/${widget.producto.imagen}",
                height: 300,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.producto.nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "\$${widget.producto.precio.toStringAsFixed(2)} MXN",
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.secundary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Descripción",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.producto.descripcion,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Cantidad",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                IconButton(
                  onPressed: () {
                    if (cantidad > 1) {
                      setState(() {
                        cantidad--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle),
                  color: AppColors.primary,
                  iconSize: 35,
                ),

                Text(
                  cantidad.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      cantidad++;
                    });
                  },
                  icon: const Icon(Icons.add_circle),
                  color: AppColors.primary,
                  iconSize: 35,
                ),

              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {

                  carrito.agregarItem(
                    widget.producto.id.toString(),
                    widget.producto.nombre,
                    widget.producto.precio,
                    "1",
                    widget.producto.imagen,
                    cantidad,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Producto agregado al carrito"),
                    ),
                  );
                },

                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),

                label: const Text(
                  "Agregar al carrito",
                  style: TextStyle(color: Colors.white),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(

                onPressed: () {

                  favoritos.agregarFavorito(
                    widget.producto.id.toString(),
                    widget.producto.nombre,
                    widget.producto.precio,
                    "1",
                    widget.producto.imagen,
                    1,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Producto agregado a favoritos ❤️"),
                    ),
                  );
                },

                icon: const Icon(Icons.favorite),

                label: const Text("Agregar a favoritos"),

              ),
            ),

          ],
        ),
      ),
    );
  }
}