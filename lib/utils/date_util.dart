
var monthsNames = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "July",
  "Aug",
  "Sept",
  "Oct",
  "Nov",
  "Dec"
];

String getFormattedDate(int dueDate) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(dueDate);
//  return "${monthsNames[date.month - 1]}  ${date.day}";
  return "${date.year}.${date.month}.${date.day} ${date.hour}:${date.minute}:${date.second}";
}