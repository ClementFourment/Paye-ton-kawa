class Article {
  final int id;
  final String name;
  final String description;
  final double price;
  final String priceUnit;
  final int w;
  final int l;
  final int h;
  final double mark;
  final String urlImage;
  final String urlGLB;
  final int glbRatio;
  final Function? onTap;

  const Article(
      this.id,
      this.name,
      this.description,
      this.price,
      this.priceUnit,
      this.w,
      this.l,
      this.h,
      this.mark,
      this.urlImage,
      this.urlGLB,
      this.glbRatio,
      this.onTap);
}
