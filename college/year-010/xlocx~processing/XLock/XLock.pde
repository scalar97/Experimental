import java.util.*;
import java.util.Map.Entry;
import java.io.*;

void setup()
{
  size(1280,720);
  padding = 50;
  noStroke();
  background(23,69,103);
  border = new ArrayList<Border>();
  uiobjects = new ArrayList<uiObject>();
  allTables = new HashMap<String, String>();
  fileReceived = countedFile = top10 =false; 
  allTables.put("Border", "border.csv");
  allTables.put("Button", "button.csv");
  allTables.put("Lock"  , "start.csv" );
  allTables.put("Widget", "widget.csv");
  
  for(Entry <String, String> pair: allTables.entrySet()){
    println(pair.getKey()+ " " + pair.getValue());
    loadData(pair);
  }
  
  // extract the single widget I have
  for(uiObject ui: uiobjects)
  {
    if (ui instanceof Widget)
      widget = (Widget)ui; // cast it because if is coming straight from a uiObject ArrayList
      // this is apssing the reference of that object to the widget variable
  }
}

float padding;
ArrayList <Border> border;
ArrayList <uiObject> uiobjects;
HashMap <String, String> allTables;
String fileName;
FileProcessor fp;
Lock lock;
boolean fileReceived,countedFile,top10;
Widget widget;
String btnLabel;



void draw()
{
  background(23,69,103);
  if (!fileReceived)
    lock.display();
  else
  {
    for(int i =0; i<uiobjects.size(); i++)
    {
      uiobjects.get(i).display();
    }
  }
  for(Border b: border){
    b.display();
  }
  if (fileReceived && fileName!=null && !countedFile)
  {    
    fp = new FileProcessor(fileName);
    println ("The file to process is : "+ fp);
    // do not scan the selected file more than once, it would be highly innefiscient
    try{
      Scanner fileToScan = new Scanner(new File(fp.fileName));
      fp.getCount(fileToScan);
      fileToScan.close(); // close the file after the count has been saved in the program
    }
    catch (IOException ie){/*will not happen since a file has to exist to be selected*/};
    countedFile = true;
  }
  if(top10)
  {
     if (fp != null) // check if file exist before ploting the values
     {
       widget.label =btnLabel; // pass the button label choosen to the widget 
       switch(btnLabel)
       {
         //show the top 10
         case "Top 10 words": fp.topLeast10(true, widget); break;
         //inverse the search to show the least 10
         case "Least 10 words": fp.topLeast10(false, widget); break;
         case "Hide message":
         break;
         case "Reveal message":
         break;
       }
     }
   } 
}

void mousePressed()
{
  if(!lock.clicked && dist(mouseX,mouseY,lock.center.x,lock.center.y) <= lock.radius_w)
  {
    lock.Clicked(); // go get the file to process
    fileReceived = true;
  }
  for(int i=0; i< uiobjects.size(); i++)
  {
    uiObject obj = uiobjects.get(i);
    // if it is a button, check if it has been clicked
    if (obj instanceof Button)
    {
      if((mouseX>= obj.origin.x && mouseX <= obj.origin.x + obj.width_)&&
         (mouseY>= obj.origin.y && mouseY <= obj.origin.y + obj.height_))
         {
           obj.Clicked();
           println(obj.label);
           //send this information to the FileProcessor Object so that it can display
           // the correct Widget depending on the user's choice
           top10 = true;
           btnLabel = obj.label;
         }
    }
  }
}


// the following function loads all the files that are needed 
//by this program.
// these files are contained withing the hashMap allTables.
// it then sends all the files to their appropriate constructors 
// as well as array list.
void loadData(Entry <String, String> pair)
{
  Table table = loadTable(pair.getValue(), "header");
  for(TableRow r:table.rows()){
    switch(pair.getKey()){
      case "Border":
                    border.add(new Border(r));
                    break;
      case "Button":
                    uiobjects.add(new Button(r));
                    break;
      case "Widget":
                    uiobjects.add(new Widget(r));
                    break;
      case "Lock":
                    lock = new Lock(r);
                    break;
    }
  }
}


// function used to read the file from the computer into this program
// this file is the one chosen by the user and is the one meant to be processed
void getFileToProcess(File file)
{
  if (file != null){
     fileName=file.getAbsolutePath();
  }
}