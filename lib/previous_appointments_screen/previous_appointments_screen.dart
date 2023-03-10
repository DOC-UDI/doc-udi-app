import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vinhack/palette.dart';
import 'package:vinhack/previous_appointments_screen/previous_appointment_details_screen.dart';
import 'package:vinhack/provider/dataProvider.dart';

class PreviousAppointmentsScreen extends StatefulWidget {
  static const routeName = "/history";

  @override
  State<PreviousAppointmentsScreen> createState() => _PreviousAppointmentsScreenState();
}

class _PreviousAppointmentsScreenState extends State<PreviousAppointmentsScreen> {
  late List<dynamic> data;
  List<dynamic> temp = [];
  late DateTime selectedDate;

  late var prov;

  TextEditingController searchController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();

  void searchDate() {
    List<dynamic> t = [];
    data = temp;
    // print(selectedDate.substring(0, selectedDate.length - 5));
    // print(selectedDate);
    data.forEach((element) {
      if (element["date"] == selectedDate.toString() + "Z") {
        t.add(element);
      }
    });
    data = t;
  }

  void search() {
    data = temp;
    String txt = searchController.text;
    if (txt.length == 0) {
      data = temp;
    } else {
      List<dynamic> t = [];
      data.forEach((element) {
        if (element["docName"].toString().contains(txt) || element["docName"].toString().toLowerCase().contains(txt)) {
          t.add(element);
        }
      });
      data = t;
    }
    setState(() {});
  }

  @override
  void initState() {
    prov = Provider.of<DataProvider>(context, listen: false);
    data = prov.previousAppointments;
    temp = data;
    print(data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text(
                        "Previous appointments",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (_) => search(),
                        decoration: InputDecoration.collapsed(
                            hintText: "Search by doctor's name",
                            hintStyle: TextStyle(
                              fontSize: 12,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (() async {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              Duration(days: 20),
                            ),
                          ).then((pickedDate) {
                            if (pickedDate == null) return;

                            selectedDate = pickedDate;
                            dateController.text = DateFormat("dd MMMM yyyy").format(selectedDate);
                            searchDate();
                            setState(() {});
                          });
                          ;
                        }),
                        child: TextField(
                          enabled: false,
                          controller: dateController,
                          decoration: InputDecoration.collapsed(
                              hintText: "Search by date",
                              hintStyle: TextStyle(
                                fontSize: 12,
                              )),
                        ),
                      ),
                    ),
                    Container(
                      child: Image.asset("assets/images/calendar.png"),
                    )
                  ],
                ),
              ),
              data.length == 0
                  ? SizedBox(
                      height: 20,
                    )
                  : SizedBox(),
              data.length == 0
                  ? Text(
                      "No results found :(",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        return GestureDetector(
                          onTap: () {
                            Map<String, dynamic> map = {
                              "specialisation": data[i]["specialization"],
                              "doctorName": data[i]["docName"],
                              "patientName": data[i]["patientName"],
                              "date": data[i]["date"],
                              "picture": data[i]["docPfp"],
                              "time": data[i]["time"],
                              "address": data[i]["clinicAddress"],
                              // "symptoms": data[i]["symptoms"],
                              "fee": data[i]["fees"],
                              "prescription": data[i]["prescription"],
                            };
                            prov.previousApptDetails = map;
                            Navigator.of(context).pushNamed(PreviousAppointmentDetailsScreen.routeName);
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[i]["docName"],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        data[i]["specialization"],
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset("assets/images/calendar.png"),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            DateFormat("dd MMMM, yyyy").format(DateTime.parse(data[i]["date"])).toString(),
                                            style: TextStyle(
                                              color: primaryFontColor,
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),

                                  // Text(data[i]["docPfp"]),
                                  Container(
                                    height: 70,
                                    width: 70,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(360),
                                      child: Image.network(
                                        data[i]["docPfp"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        );
                      },
                      itemCount: data.length,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
