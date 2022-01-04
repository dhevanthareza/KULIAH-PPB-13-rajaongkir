import 'package:flutter/material.dart';
import 'package:rajaongkir/api/client.dart';
import 'package:rajaongkir/selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> provinces = [];
  List<dynamic> fromCities = [];
  List<dynamic> toCities = [];
  Map<String, dynamic>? selectedFromProvince;
  Map<String, dynamic>? selectedFromCity;
  Map<String, dynamic>? selectedToProvince;
  Map<String, dynamic>? selectedToCity;
  Map<String, dynamic>? selectedCourier;
  TextEditingController weightController = TextEditingController();
  List<dynamic> couriers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProvinces();
  }

  fetchProvinces() async {
    dynamic response = await Request.get("/province");
    setState(() {
      this.provinces = response['rajaongkir']['results'];
    });
  }

  void fetchFromCities() async {
    dynamic response = await Request.get(
        "/city?province=${selectedFromProvince!['province_id']}");
    print(response);
    setState(() {
      this.fromCities = response['rajaongkir']['results'];
    });
  }

  void fetchToCities() async {
    dynamic response = await Request.get(
        "/city?province=${selectedToProvince!['province_id']}");
    print(response);
    setState(() {
      this.toCities = response['rajaongkir']['results'];
    });
  }

  void handleProcess() async {
    var payload = {
      "origin": selectedFromCity!['city_id'],
      "destination": selectedToCity!['city_id'],
      "courier": selectedCourier!['courier'],
      "weight": int.parse(weightController.text)
    };
    print(payload);
    dynamic response = await Request.post("/cost", data: payload);
    response = response['rajaongkir'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Result Cost",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            _resultItem("Origin",
                "${response['origin_details']['city_name']} (Postal Code : ${response['origin_details']['postal_code']})"),
            const SizedBox(
              height: 15,
            ),
            _resultItem("Destination",
                "${response['destination_details']['city_name']} (Postal Code : ${response['destination_details']['postal_code']})"),
            const SizedBox(
              height: 15,
            ),
            _resultItem("Expedisi",
                "${response['results'][0]['name']} (Service : ${response['results'][0]['costs'][0]['description']})"),
            const SizedBox(
              height: 15,
            ),
            _resultItem("Cost",
                response['results'][0]['costs'][0]['cost'][0]['value'].toString()),
            const SizedBox(
              height: 15,
            ),
            _resultItem("Time (DAYS)",
                "${response['results'][0]['costs'][0]['cost'][0]['etd'].toString()} Hari"),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek Ongkir"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "From",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            Selector(
              label: "Provinsi",
              items: provinces,
              labelKey: 'province',
              onSelect: (item) {
                setState(() {
                  selectedFromProvince = item;
                });
                fetchFromCities();
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Selector(
              label: "Kota",
              items: fromCities,
              labelKey: 'city_name',
              onSelect: (city) {
                setState(() {
                  selectedFromCity = city;
                });
              },
              itemWidget: (item) {
                return Column(
                  children: [
                    ListTile(
                      title: Text("${item['type']} ${item['city_name']}"),
                    ),
                    const Divider(
                      height: 2,
                    )
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "To",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            Selector(
              label: "Provinsi",
              items: provinces,
              labelKey: 'province',
              onSelect: (item) {
                setState(() {
                  selectedToProvince = item;
                });
                fetchToCities();
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Selector(
              label: "Kota",
              items: toCities,
              labelKey: 'city_name',
              onSelect: (city) {
                setState(() {
                  selectedToCity = city;
                });
              },
              itemWidget: (item) {
                return Column(
                  children: [
                    ListTile(
                      title: Text("${item['type']} ${item['city_name']}"),
                    ),
                    const Divider(
                      height: 2,
                    )
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                label: Text("Berat (gr)"),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 5,
            ),
            Selector(
              label: "Pilih Kurir",
              items: const [
                {"courier": "pos"},
                {"courier": "tiki"},
                {"courier": "jne"},
              ],
              labelKey: 'courier',
              onSelect: (courier) {
                setState(() {
                  selectedCourier = courier;
                });
              },
            ),
            const SizedBox(
              height: 25,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              onPressed: () {
                handleProcess();
              },
              child: const Text(
                "PROSES",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  _resultItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
