class Lock implements Display
{
  PVector center;
  float radius_w;
  private boolean clicked;// should not be cahanged outside of the class to avoid calling
  // the selectInput function twice
  String label;
  
  Lock(TableRow row)
  {
    this.clicked = false;
    this.center = new PVector(row.getFloat("centerx"), row.getFloat("centery"));
    this.radius_w = row.getFloat("radius width");
    this.label= row.getString("label");
  }
  void display()
  {
    if (!clicked)
    {
        ellipse(center.x, center.y, radius_w *2, radius_w*2);
        textAlign(CENTER);
        fill(0);
        text(label,center.x,center.y);
        fill(255);
    }
  }
  
  void destroy()
  {
    clicked = true;
  }
  void Clicked()
  {
    // the function getFileToProcecss will be run when this lock is cliked
      selectInput("Select a file to process:", "getFileToProcess");
      this.destroy(); // a file to process can only be selected once
  }
}