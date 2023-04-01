import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lesson/deal.dart';

import 'home.dart';
import 'package:flutter/material.dart';

class AddDeal extends StatefulWidget {
  bool? invisible;
  dynamic documentFirebase;
  String? name;
  String? description;
  String? image;
  AddDeal(
      {Key? key,
      this.name,
      this.description,
      this.image,
      this.documentFirebase,
      this.invisible})
      : super(key: key);

  @override
  State<AddDeal> createState() => _AddDealState();
}

class _AddDealState extends State<AddDeal> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  var elevS = ElevatedButton.styleFrom(backgroundColor: Colors.amber);
  Deal deal = Deal();

  @override
  Widget build(BuildContext context) {
    bool imageTwest() {
      //Проверка на наличие изображения
      bool isTakedImage = false;
      if (widget.image == null) {
        isTakedImage = true;
      } else {
        isTakedImage = false;
      }
      return isTakedImage;
    }

    if (widget.image != null ||
        widget.name != null ||
        widget.description != null) {
      _nameController.text = widget.name.toString();
      _descriptionController.text = widget.description.toString();
      _imageController.text = widget.image.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name!),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Card(
                          child: TextField(
                        controller: _nameController,
                        cursorColor: Colors.white,
                        // decoration: InputDecoration(fillColor: Colors.green),
                      )),
                      Card(
                          child: TextField(
                        controller: _descriptionController,
                        cursorColor: Colors.white,
                        // decoration: InputDecoration(fillColor: Colors.white),
                      )),
                      Card(
                          child: TextField(
                        controller: _imageController,
                        cursorColor: Colors.white,
                        // decoration: InputDecoration(fillColor: Colors.green),
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: ElevatedButton(
                            // style: ButtonStyle(),
                            onPressed: () async {
                              if (widget.invisible == true) {
                                // Fluttertoast.showToast(
                                //     msg:
                                //         "Нет добавлению! Только удаление или обновление!");
                              } else {
                                deal.title = _nameController.text;
                                deal.description = _descriptionController.text;
                                deal.image = _imageController.text;
                                //Соединить и определить коллекцию
                                CollectionReference deals = FirebaseFirestore
                                    .instance
                                    .collection('deals');
                                //Через linq добавляем контакт
                                await deals.add({
                                  'name': deal.title,
                                  'description': deal.description,
                                  'image': deal.image
                                });

                                //Очищение контроллеров
                                _nameController.clear();
                                _descriptionController.clear();
                                _imageController.clear();
                                Navigator.pop(context);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Добавить"),
                                Icon(Icons.add)
                              ],
                            )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ElevatedButton(
                            style: elevS,
                            onPressed: () async {
                              //Соединить и определить коллекцию
                              CollectionReference deals = FirebaseFirestore
                                  .instance
                                  .collection('deals');
                              //Один из вариантов удаления
                              //DocumentReference documentReference = deals.doc(widget.documentFirebase.id);
                              // // Далее через linq удаляем контакт?
                              // // удалить по названию документа
                              // await contacs.doc(documentReference.id).delete();
                              await deals
                                  .doc(widget.documentFirebase.id)
                                  .delete();
                              _nameController.clear();
                              _descriptionController.clear();
                              _imageController.clear();
                            },
                            child: Text("Удалить"),
                          ))
                    ],
                  )))),
    );
  }
}
