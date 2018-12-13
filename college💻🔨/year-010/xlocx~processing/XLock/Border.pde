// the following classes is an independant class
// it draws the borders and displays the name of the progam on the right hand side
// it reads its information from the the HashMap allTables see setup()
// it implements the display method in the Display Interface

class Border implements Display{
  PVector origin;
  PVector width_;
  PVector height_;
  String label = "XLocx";
 
  Border (TableRow row)
  {
    this.origin = new PVector();
    this.width_ = new PVector();
    this.height_ = new PVector();
    this.origin.x = row.getFloat("originx");
    this.origin.y = row.getFloat("originy");
    this.width_.x = row.getFloat("widthx");
    this.width_.y = row.getFloat("widthy");
    this.height_.x = row.getFloat("heightx");
    this.height_.y = row.getFloat("heighty");
  }
  
  String toString()
  {

    return 
    this.origin.x + ", " + this.origin.y + ", " +
    this.width_.x + ", " + this.width_.y + ", " +
    this.height_.x+ ", " + this.height_.y ;
  }
  
  void display()
  {
    stroke(255);
    strokeWeight(1);
    point(width/2,height/2);
    if (this.origin.x == padding && this.origin.y == padding)
      textSize(22);
      textAlign(LEFT,TOP);
      text(label,padding,padding);

    line(this.origin.x,this.origin.y,this.width_.x, this.width_.y);
    line(this.origin.x,this.origin.y,this.height_.x, this.height_.y);
    
  }
}