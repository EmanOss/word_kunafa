//this class stores the bounds of an element,
// this is used later in detecting if user swipes over it

class area {
  //data Type
  late double x1,x2, y1,y2;

  //constructor
  area(this.x1,this.x2, this.y1, this.y2);

  bool overlaps(double x, double y){
    return (x>x1 && x<x2 && y>y1 &&y<y2);
  }
}
