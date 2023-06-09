String getAlphaNumeral(int index) {
  if (index < 0 || index >= 26) {
    throw Exception('Invalid index!');
  }

  final int asciiA = 'A'.codeUnitAt(0);
  return "${String.fromCharCode(asciiA + index)}.";
}

String getRomanNumeral(int index) {
  if (index < 0 || index > 3000) {
    throw Exception('Invalid index!');
  }

  final List<String> symbols = ['I', 'V', 'X', 'L', 'C', 'D', 'M'];
  final List<int> values = [1, 5, 10, 50, 100, 500, 1000];
  final StringBuffer numeral = StringBuffer();

  int i = symbols.length - 1;

  while (index > 0) {
    int div = index ~/ values[i];
    index %= values[i];

    while (div > 0) {
      numeral.write(symbols[i]);
      div--;
    }

    if (i >= 2 && index >= values[i - 2]) {
      numeral.write(symbols[i - 2]);
      numeral.write(symbols[i]);
      index -= values[i - 2];
    }

    i -= 2;
  }

  return numeral.toString();
}
