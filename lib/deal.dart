class Deal {
  int? id;
  String? title;
  String? description;
  String? image;
  Deal({this.id, this.title, this.description, this.image});
}

List<Deal> dealList = [
  Deal(
    id: 1,
    title: 'Сходить в магазин',
    description: 'Купить молоко,хлеб,сыр',
  ),
  Deal(
    id: 2,
    title: 'Flutter',
    description: 'Прописать Flutter upgrade',
  ),
  Deal(
    id: 3,
    title: 'Поиграть Dota 2',
    description: 'Выиграть в турнире',
  ),
  Deal(
    id: 4,
    title: "Сходить за посылкой",
    description: "Сходить за посылкой на почту",
  ),
];
