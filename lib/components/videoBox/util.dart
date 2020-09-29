/// Duration => durationString => 00:01
String durationString(Duration d) {
  return d
      .toString()
      .split('.')
      .first
      .split(':')
      .where((String e) => e != '0')
      .toList()
      .join(':');
}

double map(v, start1, stop1, start2, stop2) {
  return (v - start1) / (stop1 - start1) * (stop2 - start2) + start2;
}
