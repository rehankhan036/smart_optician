import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_optician/common_function/nav_functions.dart';
import 'package:smart_optician/model/search_model.dart';
import 'package:smart_optician/ui/home_screen/component/product_view.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

String? gender;
String? brand;
bool? filteredIsRemoved;
TextEditingController _minPrice = TextEditingController();
TextEditingController _maxPrice = TextEditingController();
List<SearchModel> _filters = [];

class _SearchResultScreenState extends State<SearchResultScreen> {
  final TextEditingController _controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _filters = searchData;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "Search",
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              width: size.width * 0.89,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: _controllerSearch,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.sort,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            showCustomSheet(context);
                          },
                        ),
                      ),
                      onChanged: (string) {
                        setState(() {
                          _filters = searchData
                              .where((u) => (u.name
                                      .toLowerCase()
                                      .contains(string.toLowerCase()) ||
                                  u.name
                                      .toLowerCase()
                                      .contains(string.toLowerCase()) ||
                                  u.brand
                                      .toString()
                                      .contains(string.toLowerCase()) ||
                                  u.price
                                      .toString()
                                      .toLowerCase()
                                      .contains(string.toLowerCase())))
                              .toList();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: GridView.builder(
                    itemCount: _filters.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          screenPush(
                              context,
                              ProductViewScreen(
                                imageUrl: _filters[index].image,
                                price: _filters[index].price,
                                name: _filters[index].name,
                                gender: _filters[index].gender,
                                brandName: _filters[index].brand,
                                desc: _filters[index].desc,
                                ownerId: _filters[index].ownerId,
                                productId: _filters[index].code,
                              ));
                        },
                        child: Container(
                          width: size.width * 0.46,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: size.height * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.46,
                                height: size.height * 0.14,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: NetworkImage(_filters[index].image),
                                )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5, bottom: 2),
                                child: Text(
                                  _filters[index].name,
                                  style: GoogleFonts.cabin(
                                    color: Colors.grey.shade700,
                                    fontSize: size.width * 0.05,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 2),
                                child: Text(
                                  _filters[index].price,
                                  style: GoogleFonts.cabin(
                                    color: Colors.black,
                                    fontSize: size.width * 0.05,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  showCustomSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      builder: (context) => Container(
        width: size.width,
        height: size.height * 0.44,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Text(
              "Filter",
              style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: size.width * 0.055),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(
                      "Min ",
                      style: GoogleFonts.rubik(
                          fontSize: size.width * 0.044,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      width: size.width * 0.2,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        controller: _minPrice,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Price'),
                      ),
                    )
                  ],
                ),
                Text("To"),
                Row(
                  children: [
                    Text(
                      "Max ",
                      style: GoogleFonts.rubik(
                          fontSize: size.width * 0.044,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      width: size.width * 0.2,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        controller: _maxPrice,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Price'),
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Gender:",
                  style: GoogleFonts.rubik(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    const Text("Female:"),
                    Radio(
                        value: 'male',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value as String?;
                          });
                        }),
                  ],
                ),
                Row(
                  children: [
                    const Text("Male:"),
                    Radio(
                        value: 'female',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value as String?;
                          });
                        }),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            SizedBox(
              width: size.width * 0.8,
              child: DropdownButton<String>(
                isExpanded: true,
                value: brand,
                hint: const Text("Select brand"),
                items: <String>['rayban', 'Prada', 'Oakla'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    brand = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _filters = searchData
                          .where((u) => (u.brand
                                  .toLowerCase()
                                  .contains(brand?.toLowerCase() ?? '') ||
                              u.gender
                                  .toString()
                                  .contains(gender?.toLowerCase() ?? '') ||
                              (int.parse(u.price.toString()) >
                                      int.parse(_minPrice.text) &&
                                  int.parse(u.price.toString()) <=
                                      int.parse(_maxPrice.text))))
                          .toList();
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.05,
                    alignment: Alignment.center,
                    child: Text(
                      'Apply',
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      gender = null;
                      filteredIsRemoved = null;
                      brand = null;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.05,
                    alignment: Alignment.center,
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
