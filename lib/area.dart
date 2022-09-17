//this class stores the bounds of an element,
// this is used later in detecting if user swipes over it

class area {
  //data Type
  late double x1,x2, y1,y2;
  late double cx,cy;
  //x1,x2,y1,y2 are the bounds, cx,cy are the center coordinates

  //constructor
  area(this.x1,this.x2, this.y1, this.y2){
    cx=(x2+x1)/2;
    cy=(y2+y1)/2;
  }

  // area.myConst(x1,x2,y1,y2): this(x1, x2, y1, y2, ((x2+x1)/2), ((y2+y1)/2));
  //   cx=(x2+x1)/2;
  //   cy=(y2+y1)/2;
  //   // print('area constructor  '+ x1.toString()+'  '+x2.toString()+'  '+ cx.toString());
  // }

  bool overlaps(double x, double y){
    return (x>x1 && x<x2 && y>y1 &&y<y2);
  }
}
