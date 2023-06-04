class Word {
  String word;
  Word(this.word);

  factory Word.empty() => Word("");

  bool isEmpty() => word.isEmpty;
}