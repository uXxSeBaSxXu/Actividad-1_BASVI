class Item {
  String id;
  String nombre;
  double precio;
  String unidad;
  String imagen;
  int cantidad;

  Item({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.unidad,
    required this.imagen,
    required this.cantidad,
  });

  Item.map(dynamic o):
        id = o["id"],
        nombre = o["nombre"],
        precio = o["precio"],
        unidad = o["unidad"],
        imagen = o["imagen"],
        cantidad = o["cantidad"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "precio": precio,
      "unidad": unidad,
      "imagen": imagen,
      "cantidad": cantidad,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "precio": precio,
      "unidad": unidad,
      "imagen": imagen,
      "cantidad": cantidad,
    };
  }
}