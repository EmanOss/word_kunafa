class area {
  //data Type
  late double x1,x2, y1,y2;

  // area();
// constructor
//   area({required this.x1, required this.x2, required this.y1, required this.y2});
  area(this.x1,this.x2, this.y1, this.y2);

  bool overlaps(double x, double y){
    return (x>x1 && x<x2 && y>y1 &&y<y2);
  }
}
