

Table table;
Bin[] bins;
float[] speeds; 
float totalPoints;

void setup(){
  //load in data
   table = loadTable("speeds.csv","header");
   int binSize = 2; // division
  // array size of number of rows
  speeds = new float[table.getRowCount()];
  totalPoints = table.getRowCount();
  size(500,600);
  int x = 0;
  float max = 0;
  float min = 100;
  for(TableRow row : table.rows()){
    
    float f = row.getFloat("speed");
    // get max and min 
    if(f > max){ max = f;}
    if(f < min){ min = f;}
    
    // populate array(easier to access then table data)
    speeds[x] = f;
    x++;
    
  }
  // get top and bottom thresholds
  int iMax = int(max)+1;
  int iMin = int(min);
  
  // create list of bins size of max - min / bin size
  int size = (iMax - iMin);
  bins = new Bin[size/binSize];

  //bin things
  for(int i =0; i< speeds.length; i++){
    //use int mins and maxes for this.
                        
    float distFromBeg = (speeds[i] - min);// how far from the beginning we are should be 0 - size

    int bin = ((int)distFromBeg /2 );
    
    //initialize bin
    if(bins[bin] == null){
       bins[bin] = new Bin(bin); 
    }
    // bin a number!
    bins[bin].addNumber(speeds[i]);
  }
  

  goOtsu();
  //calculateMixedVariance(0);
}

// set up the method like this so we can find above and below threshold numbers
  float calculateVariance(int binNumberStart, int binNumberEnd){
    
    // calculate mean first 
    float mean = 0;
    float topMean = 0;
    float total = binNumberEnd - binNumberStart +1;
    
    for ( int i = binNumberStart; i < binNumberEnd; i++){
      topMean += bins[i].getSize(); // aggregate top
     
    }
    mean = topMean / total; // get mean
    
    // calculate variance using mean
    float variance = 0;
    float topVariance = 0;
    
    for ( int i = binNumberStart; i < binNumberEnd; i++){
      topVariance += sq(mean - bins[i].getSize()); // ( mean - (size of bin)) squared
    }
    variance = topVariance/total; // get variance

    return variance;

  }
  
  
  float calculateFraction(int binNumber){
    int total = 0; 
    for(int i = 0; i < binNumber; i++){
      // aggregate size of bins
       total+=bins[i].getSize();
       
    }
    // return fraction
    return (total/totalPoints);
  }
  
  float calculateMixedVariance(int binNumber){
   float mixedVariance  = 0;
   float wtUnder = calculateFraction(binNumber);
   float wtOver = 1-wtUnder;
   float varUnder = calculateVariance(0,binNumber);
   float varOver = calculateVariance(binNumber+1,bins.length);
  /* println("WtUnder " + wtUnder);
   println("WtOver " + wtOver);
   println("VarUnder " + varUnder);
   println("VarOver " + varOver);*/
   
   mixedVariance = (wtUnder*varUnder)+(wtOver*varOver);
   return mixedVariance;
    
  }
  
  void goOtsu(){
    int bestThreshold = 0;
    float bestMixedVariance = 100;
    for(int i = 0; i <bins.length; i++){
      float mixedVariance = calculateMixedVariance(i); 
      if(mixedVariance < bestMixedVariance){
         bestMixedVariance = mixedVariance; 
         bestThreshold = i;
      }
    }
    
    println("BestMixedVariance: " + bestMixedVariance);
    println("BestThreshold: " + bestThreshold); 
  }
  
  
 void draw(){
   for(Bin b : bins){
     b.drawBin();
   }
   
  }

