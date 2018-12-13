class Widget extends uiObject
{
  color gridColor = color(200,0,0);
  color trendColor = color(0,200,200);
  PVector radius; //for the trendLine

  Widget(TableRow row)
  {
    super(row);
    this.radius = new PVector(width/2, height/2 -100);
  }
  
  void trendLine(HashMap<String, Integer> data)
  {
    println("trendline choosen");
    PVector curr = new PVector(origin.x,height-origin.y + height_);
    PVector prev = new PVector(origin.x,height-origin.y + height_);
    prev.x =origin.x;
    ArrayList<Integer> ratings = new ArrayList(data.values());
    float max = map(getMax(data),0,  origin.x, origin.x, height - origin.y + height_);
    
    
    
    for (int i = 1; i< ratings.size(); i++)
    {
      // make it stay within the bounds of the widget
      curr.x = map(i,0,ratings.size(), origin.x, width - origin.x + width_);
      curr.y = map(ratings.get(i), 0, max, origin.x, height - origin.y + height_);
      prev.y = map(ratings.get(i-1), 0, max, origin.x, height - origin.y + height_);
      strokeWeight(1);
      
      // drawing the actual trendline
      stroke(trendColor);
      line(curr.x, height-curr.y, prev.x, height-prev.y);
      
      // tip points joining the trendlines
      strokeWeight(4);
      stroke(255);
      point(curr.x,height-curr.y);
  
      // update the previous so that it joins to the next current
      prev.x = curr.x;
    }
  }
  

//returns the maximun. usefull for the trendline
float getMax(HashMap <String, Integer> hasM)
{
  println("get Max value");
  float max = MIN_FLOAT;
  for(Entry <String, Integer> pair: hasM.entrySet())
  {
    if (pair.getValue() > max) max = pair.getValue();
  }
  return max;
}


void pieChart(float cWidth, HashMap<String,Integer> data)
{
  noStroke();
  println("piechart choosen");
  float angle = 0; //start and end of the chart
  PVector txt = new PVector(origin.x ,origin.y);
  textSize(22);
  
  
  for (Entry <String, Integer> pair: data.entrySet())
  {
    fill(random(150), random(200),random(200));
    
    float angle2 = angle+ radians( (float) pair.getValue());
    arc(radius.x, radius.y, cWidth, cWidth, angle, angle2);
    
    text(pair.getKey(), txt.x, txt.y);
    
    angle += radians( (float) pair.getValue());
    txt.y += 50;
  }
}
}