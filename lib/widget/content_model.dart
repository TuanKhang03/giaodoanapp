class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent({
    required this.description,
    required this.image,
    required this.title,
  });
}

List<UnboardingContent> contests = [
  UnboardingContent(
    description: 'Chọn món ăn  ',
    image: 'images/screen1.png',
    title: 'Chọn món ăn từ thực đơn tốt nhất của chúng tôi',
  ),
  UnboardingContent(
    description: 'Bạn có thể thanh toán bằng tiền mặt hoặc thẻ ',
    image: 'images/screen2.png',
    title: 'Dễ dàng thanh toán online',
  ),
  UnboardingContent(
    description: 'Giao đồ ăn tận nhà bạn ',
    image: 'images/screen3.png',
    title: 'Giao hàng nhanh chóng trước cửa nhà bạn',
  ),
];
