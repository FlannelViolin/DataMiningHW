// class to hold a list of numbers and info about them 
class Bin{
  ArrayList<Float> list;
  int index;
  
  // drawing buffers
  int xBuffer =25;
  int yBuffer = 22;
  
  // i being the index in the list of bins
  Bin(int i){
    list = new ArrayList();
    index = i;
  }
  
  // takes a float and adds it into the bin
  void addNumber(float f){
    list.add(f);
 
  }
  
  // easer getter
  int getSize(){
    return list.size();
  }
  
  // print method for debugging
  void printBin(){
     println("size of bin and index " + list.size() + " " + index);
     for(Float f : list){
        println("   " + f); 
     }
  }
  
  
  // draws nice rectangles
  void drawBin(){
    rect(50+(xBuffer*index),height-(yBuffer*list.size()), xBuffer -5, (yBuffer*list.size()));    
  }
}
