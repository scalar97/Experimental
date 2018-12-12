class uiObject implements Display
{
  String label;
  float width_, height_;
  PVector origin;
  boolean clicked;
  
  uiObject (TableRow row)
  {
    this.origin =new PVector(row.getFloat("originx"),
                             row.getFloat("originy"));                
    this.label = row.getString("label");
    this.width_ = row.getFloat("width_");
    this.height_ = row.getFloat("height_");
    this.clicked = false;
  }
  void display(){}
  
  String toString()
  {
    return 
    this.label +", "+ this.origin.x + ", " + this.origin.y + ", " +
    this.width_ + ", "+ this.height_;
  }
  
  void Clicked()
  {
    this.clicked = true;
  }
}