Future<void> fetchUserOrder() {
  return Future.delayed(const Duration(seconds: 2), () => print("Large latte"));
}

void main() {
  fetchUserOrder();
  print("Fetch User Order ...");
}
