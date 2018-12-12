class FileProcessor
{
  String fileName;
  HashMap <String,Integer> wordCountMap;
  HashMap <String,Integer> topLeast10;
  HashMap <String,String> fileMetaData;
  
  FileProcessor(String fileName)
  {
    this.fileName = fileName;
    this.wordCountMap = new HashMap <String,Integer>();
    this.topLeast10 = new HashMap <String,Integer>();
    fileMetaData = new HashMap <String,String>();
  }
  
  // counts the occurence of words in a file and add to the wordCountMap
  void getCount(Scanner input) throws IOException 
  {
      while (input.hasNext()) 
      {
        String next = input.next();
        Integer count = wordCountMap.get(next);
        if (count == null) 
          wordCountMap.put(next, 1);
        else
          wordCountMap.put(next, count + 100); //make it look bigger for the piechart
      }  
    println("there were " + wordCountMap.size() + " counted words.");
  }
  
  
  // from the count, only extracts the top 10 used words
  // or the least 10
  void topLeast10(boolean top10, Widget widget)
  {
    // only display top 10, if there were 10 or more word reads
    int max = wordCountMap.size() <= 10 ? wordCountMap.size(): 10;
    int count = 0;
    for(Entry <String, Integer> pair: wordCountMap.entrySet()){
      
      topLeast10.put(pair.getKey(),pair.getValue());
      if(count >= max) break;
      else count++;
    }
    if(top10)
      widget.trendLine(topLeast10);
    else
      widget.pieChart(200, topLeast10); //make a circle of 50 pixels
  }
  
  
  String toString()
  {
    return fileName;
  }
  
  
  
  void stegonography(String message, String password, Widget w)
  {
    // hides the messages inside the current file name and updates the 
    // widget to display the level of distortion
    // before and after
  }
  
  void decryt(String password)
  {
    //uses the password to decrypt the file containing a message
  }
}