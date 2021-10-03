

extension IterableEx<E> on Iterable<E> {
  E maybeFirstWhere(bool test(E element)) => firstWhere(test, orElse: () => null);
}
