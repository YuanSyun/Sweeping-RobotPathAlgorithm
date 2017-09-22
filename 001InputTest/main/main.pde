PImage inputImage;
PImage outputImage;

//String IMAGE_PATH = "data/Test_Image.tif";
String IMAGE_PATH = "data/octree1x1.tif";
//String IMAGE_PATH = "data/octree1x1test.tif";
int IMAGE_WIDTH = 1024, IMAGE_HEIGHT = 1024;

// Robot Size is 30 cm. 
int CUT_SIZE = 6; 

int CENTER_INDEX = IMAGE_WIDTH * ((IMAGE_HEIGHT/2) - 1) + IMAGE_WIDTH/2;
int PATH_COLOR = color(254,254,254);

float EMITY_RATIO = 0.05;
float FULL_RATIO = 0.995;

RegionMapInformation _rootQuadtree;



void setup(){
  size(1024, 1024);
  background(0);
  
  // Open image file.
  inputImage = loadImage(IMAGE_PATH);
  println(inputImage + "\n");
  
  // Protect input image.
  outputImage = inputImage;
  //print("output image width = " + outputImage.width + " height = " + outputImage.height + "\n");
  
  // Cut grid image.
  float[] gridArray = getImageGridArray(inputImage, CUT_SIZE, PATH_COLOR);
  int cutWidth = getImageGridWidth(inputImage, CUT_SIZE);
  int cutHeight = getImageGridHeight(inputImage, CUT_SIZE);
  println("cutWidth = " + cutWidth + " cutHeight = " + cutHeight + ", arraySize = " + (cutWidth + (cutWidth * cutHeight)) + "\n");
  
  //QuadTree cutting
  _rootQuadtree = quadtreeCutting(outputImage, gridArray, 1, -cutWidth/2, -cutHeight/2, cutWidth/2, cutHeight/2, cutWidth, cutHeight);
  print("Quadtree Cutting End\n\n");
  
  //cutGridShow(outputImage, CUT_SIZE, color(25));
  
  // Draw image ranger.
  drawCrossLine(outputImage, -512, -512, color(255,0,0));
  drawCrossLine(outputImage, 0, 0, color(255,0,0));
  drawCrossLine(outputImage, 511, 511, color(255,0,0));
  
  //Draw region ranger
  drawCuttingRegionPoint(outputImage, CUT_SIZE, -84, -84, color(255,0,0));
  drawCuttingRegionPoint(outputImage, CUT_SIZE, 84, 84, color(255,0,0));
  
  color emityColor = color(10, 100, 30);
  color mixColor = color(200, 150, 20);
  color fullColor = color(128, 128, 128);
  drawQuadtreeState(outputImage, _rootQuadtree, emityColor, mixColor, fullColor);
  
  // Draw region crosss line
  color crossColor = color(50);
  drawQuadtreeCuttingCrossLine(outputImage, _rootQuadtree, crossColor, 0.9);
  
  // Find Emity Region
  RegionMapInformation[] emityRegions = new RegionMapInformation[1024];
  int emityRegionsNumber = getStateRegions(_rootQuadtree, emityRegions, RegionMapInformation.RegionState.EMITY_OBSTACLE, 0);
  println("Save Index = " + emityRegionsNumber);
  for(int i=0; i<emityRegionsNumber ; i++){
    //print("(" + i + "," + emityRegions[i].getRegionArea() + ") ");
    //drawQuadtreeCuttingArea(outputImage, emityRegions[i], emityColor, mixColor, fullColor);
    //drawQuadtreeCuttingCrossLine(outputImage, emityRegions[i], crossColor, 0.0);
  }//end for
  
  // Sort Region
  emityRegions = sortMaxAreaToMinArea(emityRegions, emityRegionsNumber);
  int maxLevel = emityRegions[0].getRegionArea();
  int areaLevel = maxLevel;
  float colorRatio = 1;
  for(int i=0; i<emityRegionsNumber ; i++){
    //print("(" + i + "," + emityRegions[i].getRegionArea() + ") ");
    if(emityRegions[i].getRegionArea() < areaLevel){
      //print("have min region\n");
      areaLevel =  emityRegions[i].getRegionArea();
      colorRatio = float(areaLevel)/maxLevel;
      //print("Color Ratio = " + colorRatio +"\n");
    }
    
    //drawQuadtreeCuttingArea(outputImage, emityRegions[i], int(emityColor*colorRatio), int(mixColor*colorRatio), int(fullColor*colorRatio));
    //drawQuadtreeCuttingCrossLine(outputImage, emityRegions[i], crossColor, 0.0);
  }//end for
  
  //outputImage.save(dataPath("quadtree_map_022.png"));
}//end setup



void draw(){
  image(outputImage, 0, 0);
}


void mousePressed(){
  
  int pointX = (mouseX - IMAGE_WIDTH/2)/CUT_SIZE;
  int pointY = (mouseY - IMAGE_HEIGHT/2)/CUT_SIZE;
  
  print("mouse point = (" + pointX + "," + pointY + ")\n");
  RegionMapInformation findIt = findRegionPoint( _rootQuadtree, pointX, pointY);
  print("find region = " + findIt + "\n");
  if(findIt != null){
    color emityColor = color(10, 100, 30);
    color mixColor = color(200, 150, 20);
    color fullColor = color(128, 128, 128);
    drawQuadtreeCuttingArea(outputImage, findIt, emityColor, mixColor, fullColor);
  }
}


RegionMapInformation findRegionPoint(RegionMapInformation _quadTree, int _pointX, int _pointY){
  if(_quadTree != null){
    
    if(inRegion(_quadTree, _pointX, _pointY)){
         
         if(_quadTree.isLeaf()){
           return _quadTree;
         }else{
           if(inRegion(_quadTree.getLURegion(), _pointX, _pointY)){
             return findRegionPoint(_quadTree.getLURegion(), _pointX, _pointY);
           }
           
           if(inRegion(_quadTree.getRURegion(), _pointX, _pointY)){
             return findRegionPoint(_quadTree.getRURegion(), _pointX, _pointY);
           }
           
           if(inRegion(_quadTree.getLDRegion(), _pointX, _pointY)){
             return findRegionPoint(_quadTree.getLDRegion(), _pointX, _pointY);
           }
           
           if(inRegion(_quadTree.getRDRegion(), _pointX, _pointY)){
             return findRegionPoint(_quadTree.getRDRegion(), _pointX, _pointY);
           }
           
           return null;
         }
    }//end if
  }//end if
  
  return null;
}//end findRegionPoint

boolean inRegion(RegionMapInformation _region, int _pointX, int _pointY){
  if(_pointX >= _region.getLUPointX() && _pointX <= _region.getRDPointX() &&
     _pointY >= _region.getLUPointY() && _pointY <= _region.getRDPointY()){
     return true;  
  }
   
  return false;
}//end inRegion