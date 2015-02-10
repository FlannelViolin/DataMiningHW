class Bin{
  ArrayList<Float> list;
  int index;
  int xBuffer =25;
  int yBuffer = 22;
  Bin(int i){
    list = new ArrayList();
    index = i;
  }
  
  void addNumber(float f){
     
   
    list.add(f);
 
  }
  
  int getSize(){
    return list.size();
  }
  void printBin(){
     println("size of bin and index " + list.size() + " " + index);
     for(Float f : list){
        println("   " + f); 
     }
  }
  
  void drawBin(){
    fill(0);
    rect(50+(xBuffer*index),height-(yBuffer*list.size()), xBuffer -5, (yBuffer*list.size()));
  }
}
