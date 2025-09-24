class PagedResponse<T> {
  final List<T> objects;
  final int totalPages;
  final int currentPage;

  PagedResponse({
    required this.objects,
    required this.totalPages,
    required this.currentPage,
  });
}
