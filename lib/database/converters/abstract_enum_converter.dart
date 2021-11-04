
mixin EnumConverter<T> {
  List<T> get values;

  @override
  // ignore: override_on_non_overriding_member
  T decode(int value) {
    if (value == null || value < 0 || value >= values.length) return null;
    return values.elementAt(value);
  }


  @override
  // ignore: override_on_non_overriding_member
  int encode(T value) {
    final i = values.indexOf(value);
    return i > -1 ? i : null;
  }
}
