
// data structure for holding the initial data
Table table;

// array of bins 
Bin[] bins;

// speeds to be pulled from the table
float[] speeds; 

// used as the denominator in calculateFraction
float totalPoints; 
//  integer min/maxes for the data (where are the bins?)
int iMax;
int iMin;

// store this data
float bestMixedVariance;
float bestThreshold;


void setup(){
  // set size of dispaly
  size(500,600);
  
  //load in data
   table = loadTable("Mystery_Data.csv","header");
  
  int binSize = 2; // division
  
  // array size of number of rows
  speeds = new float[table.getRowCount()];
  totalPoints = table.getRowCount();
  
  // temp varaibles to calculate min/max
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
  iMax = int(max)+1;
  iMin = int(min);

  // create list of bins size of max - min / bin size
  int size = (iMax - iMin);
  if(size%2 ==1){
    // create an extra bin cause odd nnumber 
    size++;
  }
  
  // initialize bin array
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
  
  // Call the program!
  goOtsu();
  
}

// set up the method like this so we can find above and below threshold numbers
  float calculateVariance(int binNumberStart, int binNumberEnd){
    
    // calculate mean first 
    float mean = 0;
    float topMean = 0;
    float total = binNumberEnd - binNumberStart +1;
    
    for ( int i = binNumberStart; i < binNumberEnd; i++){
   
      if(bins[i] == null){
       bins[i] = new Bin(i); 
       // if a bin hadn't been initialized
      }
      topMean += bins[i].getSize(); // aggregate top
      
    }
    mean = topMean / total; // get mean
    println(mean);
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
    bestThreshold = 0;
    bestMixedVariance = 100;
    for(int i = 0; i <bins.length; i++){
      // calculate mixed variance for each threshold
      float mixedVariance = calculateMixedVariance(i); 
      
      // find best one
      if(mixedVariance < bestMixedVariance){
         bestMixedVariance = mixedVariance; 
         bestThreshold = i;
      }
    }
    
    println("BestMixedVariance: " + bestMixedVariance);
    println("BestThreshold: " + (bestThreshold+iMin)); 
    
  }
  
 // drawing method 
 void draw(){
   // clear background in case I do animation (I won't)
   background(255/2);
   
   // draw each bin
   for(int i = 0; i<bins.length;i++){
     // if THE threshold draw red
     if(i == bestThreshold) { fill(255,0,0); }
     //draw black
     else {fill(0);}
     
     bins[i].drawBin();
     
   }
   stroke (1);
   // write info
   text("Best threshold: " + (bestThreshold+iMin),20,20);
   text("Best mixed variance: " + bestMixedVariance,20,40);
   
  }
  
 

