// the following classes inherits from the uiObject class.
// it controls the button behavious from which information is recieved from a file
// specied in setup under the HashMap allTables
// if checks if the user has clicked a button, and opens the FileProsessor
// object fp to sisplay the appropriate representation of the file content.
// these buttons simply send information

class Button extends uiObject implements Display 
{
  Button (TableRow row)
  {
    super(row);
    println(this);
  }
  void display()
  {
    noStroke();
    point(width/2,height/2);
    textAlign(LEFT);
    text(label,origin.x+5,origin.y+30);
    fill(255,255,255,100); // 75% opacity fade them when they are not selected
    if (!clicked)
    {
      fill(255);
      fill(255,255,255,100);
    }
      
      
    rect(origin.x,origin.y,width_,height_); //width and height of each button
    fill(255);   
  }
  
  String toString()
  {
    return 
    this.label  + ", "+ this.origin.x + ", " + this.origin.y + ", " +
    this.width_ + ", "+ this.height_;
  }
}