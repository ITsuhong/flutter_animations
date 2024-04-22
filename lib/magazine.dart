class Magazine {
  const Magazine({
    required this.id,
    required this.assetImage,
  });

  final String id;
  final String assetImage;

  static final List<Magazine> fakeMagazinesValues = List.generate(
      13,
      (index) => Magazine(
          id: '$index', assetImage: 'assets/img/vice/vice${index + 1}.png'));
}
