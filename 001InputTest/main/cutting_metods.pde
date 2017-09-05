
boolean rectangleJudgment(PImage _image, int _LRPointX, int _LRPointY, int _RDPointX, int _RDPointY, color _color){
  boolean result = true;
  int _width = _RDPointX - _LRPointX;
  int _height = _RDPointY - _LRPointY;
  
  // Check rectangle color
  int selectPointX = _LRPointX;
  int selectPointY = _LRPointY;
  for(int j=0 ; j <abs(_height); j++){
    for(int i=0 ; i < abs(_width) ; i++){
      if(_image.pixels[coordinateToImageIndex(_image,selectPointX,selectPointY)]!=_color){
        //print("Image[" + selectPointX + "," + selectPointY + "]=" +_image.pixels[coordinateToImageIndex(_image,selectPointX,selectPointX)] + " _color = " + _color + " ");
        result = false;
        break;
      }
      selectPointX = _LRPointX;
      selectPointX += _width/abs(_width);
    }
    selectPointY += _height/abs(_height);
  }//end for
  
  return result;
}//end rectangleJudgment

boolean cutRegionPointJudgment(PImage _image, int _cutSize, int _cutPointX, int _cutPointY, color _color){
  int LRPointX = _cutSize*_cutPointX - _cutSize/2;
  int LRPointY = _cutSize*_cutPointY - _cutSize/2;
  int RDPointX = _cutSize*_cutPointX + _cutSize/2;
  int RDPointY = _cutSize*_cutPointY + _cutSize/2;
  
  //drawCrossLine(_image, LRPointX, LRPointY, color(255,0,0));
  //drawCrossLine(_image, RDPointX, RDPointY, color(255,0,0));
  
  return rectangleJudgment(_image, LRPointX, LRPointY, RDPointX, RDPointY, _color);
  
}//end cutRegionJudgment

boolean[] getImageGridArray(PImage _image, int _cutSize,color _color){
  int startIndexWidth = -1 * (((_image.width/2)-(_cutSize/2))/_cutSize);
  int endIndexWidth = (((_image.width/2)-(_cutSize/2))/_cutSize);
  int startIndexHeight = -1 * (((_image.height/2)-(_cutSize/2))/_cutSize);
  int endIndexHeight = (((_image.height/2)-(_cutSize/2))/_cutSize);
  
  //println("Width Index = " + startIndexWidth + " ~ " + endIndexWidth);
  //println("Height Index = " + startIndexHeight + " ~ " + endIndexHeight);
  
  int gridWidth = endIndexWidth - startIndexWidth;
  int girdHeight = endIndexHeight - startIndexHeight;
  boolean[] gridArray = new boolean[gridWidth * girdHeight];
  
  int gridIndex = 0;
  for(int j=startIndexHeight; j<endIndexHeight; j++){
    for(int i=startIndexWidth; i<endIndexWidth; i++){
      gridArray[gridIndex] = cutRegionPointJudgment(_image, _cutSize, i, j, _color);
      
      //Draw Region Color
      if(gridArray[gridIndex]){
        drawCuttingRegionPoint(_image, _cutSize, i, j, color(255,0,0));
      }
      
      gridIndex += 1;
    }
  }
  return gridArray;
}//end getImageGridArray