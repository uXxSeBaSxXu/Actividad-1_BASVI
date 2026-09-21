class Catalogo {
  final int id;
  final String nombre;
  final double precio;
  final String imagen;
  final String descripcion;

  const Catalogo({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.descripcion,
  });
}

final vinos =[
  new Catalogo(id: 1, nombre: "Vino Tinto Rosso di", precio: 800, imagen: "wine1.png", descripcion: "descripcion"),
  new Catalogo(id: 2, nombre: "Vino Tinto Reserva", precio: 800, imagen: "wine2.png", descripcion: "descripcion"),
  new Catalogo(id: 3, nombre: "Vino Tinto Aiken Pinot Noir", precio: 800, imagen: "wine3.png", descripcion: "descripcion"),
  new Catalogo(id: 4, nombre: "Vino Blanco Pillar Box White", precio:  800, imagen: "wine4.png", descripcion: "descripcion"),
  new Catalogo(id: 5, nombre: "Vino Tinto Rawson's Retreat Shiraz Cabernet", precio: 800, imagen: "wine5.png", descripcion: "descripcion"),
  new Catalogo(id: 6, nombre: "Vino Blanco Semillón", precio: 800, imagen: "wine6.png", descripcion: "descripcion"),
];

final licores =[
  new Catalogo(id: 7, nombre: "Licor 43", precio: 800, imagen: "liqueur1.png", descripcion: "descripcion"),
  new Catalogo(id: 8, nombre: "Licor de hierbas amargo Fernet-Branca", precio: 800, imagen: "liqueur2.png", descripcion: "descripcion"),
  new Catalogo(id: 9, nombre: "Licor amargo Campari", precio: 800, imagen: "liqueur3.png", descripcion: "descripcion"),
  new Catalogo(id: 10, nombre: "licor Baileys The Original Irish Cream", precio: 800, imagen: "liqueur4.png", descripcion: "descripcion"),
];

final whisky =[
  new Catalogo(id: 11, nombre: "Whisky Johnnie Walker Red Label", precio: 800, imagen: "whisky1.png", descripcion: "descripcion"),
  new Catalogo(id: 12, nombre: "Whisky escocés Chivas Regal 18 Años Gold Signature", precio: 800, imagen: "whisky2.png", descripcion: "descripcion"),
  new Catalogo(id: 13, nombre: "Whisky escocés Ballantine's 12 Years Old", precio: 800, imagen: "whisky3.png", descripcion: "descripcion"),
];

final ron =[
  new Catalogo(id: 14, nombre: "Ron Bacardí Carta Blanca", precio: 800, imagen: "ron1.png", descripcion: "descripcion"),
  new Catalogo(id: 15, nombre: "Ron Malibú", precio: 800, imagen: "ron2.png", descripcion: "descripcion"),
  new Catalogo(id: 16, nombre: "Ron especiado Captain Morgan Original Spiced Gold", precio: 800, imagen: "ron3.png", descripcion: "descripcion"),
  new Catalogo(id: 17, nombre: "Ron especiado The Kraken", precio: 800, imagen: "ron4.png", descripcion: "descripcion"),
];