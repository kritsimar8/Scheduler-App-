import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_/core/constants/utils.dart';
import 'package:intl/intl.dart';

class Dateselector extends StatefulWidget {
   final DateTime selectedDate;
   final Function(DateTime) onTap;
   const Dateselector({super.key, required this.selectedDate,required this.onTap});

  @override
  State<Dateselector> createState() => _DateselectorState();
}

class _DateselectorState extends State<Dateselector> {
  int weekOffset = 0;
  
  @override
  Widget build(BuildContext context) {
    final weekDates = generateWeekDates(weekOffset);
    String monthName = DateFormat("MMMM").format(weekDates.first);

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      weekOffset--;
                    });
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              Text(
                monthName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      weekOffset++;
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_ios))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 80,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weekDates.length,
                itemBuilder: (context, index) {
                  final date = weekDates[index];
                  bool isSelected = DateFormat('d').format(widget.selectedDate) ==
                          DateFormat('d').format(date) &&
                      widget.selectedDate.month == date.month &&
                      widget.selectedDate.year == date.year;
                  return GestureDetector(
                    onTap: ()=> widget.onTap(date),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 70,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepOrangeAccent:null,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat("d").format(date),
                            style:  TextStyle(
                              color: isSelected? Colors.white: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                           Text(
                           DateFormat("E").format(date),
                            style: TextStyle(
                               color: isSelected? Colors.white: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }
}
