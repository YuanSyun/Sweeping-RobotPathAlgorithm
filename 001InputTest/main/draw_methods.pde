
//------------------------------------------------------------------------------------------
void drawCrossLine(PImage _image, int _pointX, int _pointY, color _color){
  for(int i=0; i < _image.width; i++){
    //Vertical Line
    _image.pixels[coordinateToImageIndex(_image, _pointX, (-_image.width/2)+i)] = _color;
    //Horizontal Line
    _image.pixels[coordinateToImageIndex(_image, (-_image.height/2)+i, _pointY)] = _color;
  }
  
  _image.updatePixels();
}//end draw Point

//------------------------------------------------------------------------------------------
void drawLine(int _pointX1,int _pointY1, int _pointX2, int _pointY2){
  line(_pointX1+(IMAGE_WIDTH/2), _pointY1+(IMAGE_HEIGHT/2), _pointX2+(IMAGE_WIDTH/2), _pointY2+(IMAGE_HEIGHT/2));
}

//------------------------------------------------------------------------------------------
void drawRegion(PImage _image, int _point1X, int _point1Y, int _point2X, int _point2Y, color _color){
  int _width = _point2X - _point1X;
  int _height = _point2Y - _point1Y;
  
  int selectPointX = _point1X;
  int selectPointY = _point1Y;
  
  int indexX;
  if(_width==0){
    indexX = 1;
  }else{
    indexX = _width/abs(_width);
  }
  
  int indexY;
  if(_height==0){
    indexY = 1;
  }else{
    indexY = _height/abs(_height);
  }

  for(int j=0; j<=(abs(_height)); j++){
    for(int i=0; i<=(abs(_width)); i++){
      //print("(" + selectPointX + ", " + selectPointY + ")=" + coordinateToImageIndex(_image, selectPointX, selectPointY) + " ");
      _image.pixels[coordinateToImageIndex(_image, selectPointX, selectPointY)] = _color;
      selectPointX += indexX;
    }//end for
    selectPointX = _point1X;
    selectPointY += indexY;
  }//end for

  _image.updatePixels();
}//end drawRegion

//------------------------------------------------------------------------------------------
void drawCuttingRegionPoint(PImage _image, int _cutSize, int _cutPointX, int _cutPointY, color _color){
  int LUPointX = _cutSize*_cutPointX - _cutSize/2;
  int LUPointY = _cutSize*_cutPointY - _cutSize/2;
  int RDPointX = _cutSize*_cutPointX + _cutSize/2;
  int RDPointY = _cutSize*_cutPointY + _cutSize/2;
  //print("LUpoint = (" + LUPointX + "," + LUPointY + ") RDPoint = (" + RDPointX + "," + RDPointY + ")\n");
  
   drawRegion(_image, LUPointX, LUPointY, RDPointX, RDPointY, _color);
}//end drawCuttingPoint

//------------------------------------------------------------------------------------------
void drawCuttingRegionPointRight(PImage _image, int _cutSize, int _cutPointX, int _cutPointY, color _color){
  int RUPointX = _cutSize*_cutPointX + _cutSize/2;
  int RUPointY = _cutSize*_cutPointY - _cutSize/2;
  int RDPointX = _cutSize*_cutPointX + _cutSize/2;
  int RDPointY = _cutSize*_cutPointY + _cutSize/2;
  
  drawRegion(_image, RUPointX, RUPointY, RDPointX, RDPointY, _color);
}//end drawCuttingRegionPointRight

//------------------------------------------------------------------------------------------
void drawCuttingRegionPointDown(PImage _image, int _cutSize, int _cutPointX, int _cutPointY, color _color){
  int LDPointX = _cutSize*_cutPointX - _cutSize/2;
  int LDPointY = _cutSize*_cutPointY + _cutSize/2;
  int RDPointX = _cutSize*_cutPointX + _cutSize/2;
  int RDPointY = _cutSize*_cutPointY + _cutSize/2;
  
  drawRegion(_image, LDPointX, LDPointY, RDPointX, RDPointY, _color);
}//end drawCuttingRegionPointDown

//------------------------------------------------------------------------------------------
void drawCuttingRegionPointCenterVertical(PImage _image, int _cutSize, int _cutPointX, int _cutPointY, color _color){
  int LDPointX = _cutSize*_cutPointX;
  int LDPointY = _cutSize*_cutPointY - _cutSize/2;
  int RDPointX = _cutSize*_cutPointX;
  int RDPointY = _cutSize*_cutPointY + _cutSize/2;
  
  drawRegion(_image, LDPointX, LDPointY, RDPointX, RDPointY, _color);
}//end drawCuttingRegionPointCenterVertical

//------------------------------------------------------------------------------------------
void drawCuttingRegionPointCenterHorizontal(PImage _image, int _cutSize, int _cutPointX, int _cutPointY, color _color){
  int LDPointX = _cutSize*_cutPointX - _cutSize/2;
  int LDPointY = _cutSize*_cutPointY;
  int RDPointX = _cutSize*_cutPointX + _cutSize/2;
  int RDPointY = _cutSize*_cutPointY;
  
  drawRegion(_image, LDPointX, LDPointY, RDPointX, RDPointY, _color);
}//end drawCuttingRegionPointCenterHorizontal

//------------------------------------------------------------------------------------------
void cutGridShow(PImage _image, int _cutSize, color _color){
  int startIndexWidth = -1 * (((_image.width/2)-(_cutSize/2))/_cutSize);
  int endIndexWidth = (((_image.width/2)-(_cutSize/2))/_cutSize);
  int startIndexHeight = -1 * (((_image.height/2)-(_cutSize/2))/_cutSize);
  int endIndexHeight = (((_image.height/2)-(_cutSize/2))/_cutSize);
  
  //println("Width Index = " + startIndexWidth + " ~ " + endIndexWidth);
  //println("Height Index = " + startIndexHeight + " ~ " + endIndexHeight);
  
  int LUPointX ;
  int LUPointY ;
  int RDPointX ;
  int RDPointY;
  
  for(int j=startIndexHeight; j<=endIndexHeight; j++){
    LUPointX = _cutSize*0 - _cutSize/2;
    LUPointY = _cutSize*j - _cutSize/2;
    drawCrossLine(_image, LUPointX, LUPointY, _color);

    // Ｔhe most end.
    if(j==endIndexHeight){
      RDPointX = LUPointX + _cutSize;
      RDPointY = LUPointY + _cutSize; 
      drawCrossLine(_image, RDPointX, RDPointY, _color);
    }
  }
  for(int i=startIndexWidth; i<=endIndexWidth; i++){
    LUPointX = _cutSize*i - _cutSize/2;
    LUPointY = _cutSize*0 - _cutSize/2;
    drawCrossLine(_image, LUPointX, LUPointY, _color);

    // The most end.
    if(i==endIndexHeight){
      RDPointX = LUPointX + _cutSize;
      RDPointY = LUPointY + _cutSize; 
      drawCrossLine(_image, RDPointX, RDPointY, _color);
    }
  }
}//end cutGridShow

//------------------------------------------------------------------------------------------
void drawQuadtreeCuttingArea(PImage _image, RegionMapInformation _region, color _emityColor, color _mixColor, color _fullColor){

  color _decisionColor;

  if(_region.getRegionState() == RegionMapInformation.RegionState.EMITY_OBSTACLE){
    _decisionColor = _emityColor;
  }else if(_region.getRegionState() == RegionMapInformation.RegionState.FULL_OBSTACLE){
    _decisionColor = _fullColor;
  }else if(_region.getRegionState() == RegionMapInformation.RegionState.MIXED_OBSTACLE){
    _decisionColor = _mixColor;
  }else{
    _decisionColor = color(255,0,0);
  }
  
  /*
  print("drawCuttingRegionPoint LUPoint = (" + _region.getLUPointX() + ", " + _region.getLUPointY() + ") RDPoint = (" + _region.getRDPointX() + ", " + _region.getRDPointY() + ")\n");
  drawCuttingRegionPoint(_image, _cutSize, _region.getLUPointX(), _region.getLUPointY(), _decisionColor);
  drawCuttingRegionPoint(_image, _cutSize, _region.getRDPointX(), _region.getRDPointY(), _decisionColor);
  */
  
  int _width = _region.getRDPointX() - _region.getLUPointX();
  int _height = _region.getRDPointY() - _region.getLUPointY();

  int selectPointX = _region.getLUPointX();
  int selectPointY = _region.getLUPointY();
  
  int indexX;
  if(_width == 0){
    indexX = 1;
  }else{
    indexX = _width/abs(_width);
  }
  
  int indexY;
  if(_height == 0){
    indexY = 1;
    drawCuttingRegionPoint(_image, CUT_SIZE, selectPointX, selectPointY, _decisionColor);
  }else{
    indexY = _height/abs(_height);
  }//end if
    

  for(int j=0; j < abs(_height); j++){
    for(int i=0; i < abs(_width); i++){
      drawCuttingRegionPoint(_image, CUT_SIZE, selectPointX, selectPointY, _decisionColor);
      selectPointX += indexX;
    }
    selectPointX = _region.getLUPointX();
    selectPointY += indexY;
  }//end for
  
  //add one gird color
  if(_width == 0){
    selectPointX = _region.getLUPointX();
    selectPointY = _region.getLUPointY();
    for(int i=0;i <= abs(_height); i++){
      drawCuttingRegionPoint(_image, CUT_SIZE, selectPointX, selectPointY, _decisionColor);
      selectPointY += indexY;
    }
  }//end if
  
  //add one gird color
  if(_height == 0){
    selectPointX = _region.getLUPointX();
    selectPointY = _region.getLUPointY();
    for(int i=0;i <= abs(_width); i++){
      drawCuttingRegionPoint(_image, CUT_SIZE, selectPointX, selectPointY, _decisionColor);
      selectPointX += indexX;
    }
  }//end if
  

}//end drawIctreeCuttingArea

//------------------------------------------------------------------------------------------
void drawQuadtreeCuttingCrossLine(PImage _image, RegionMapInformation _region, color _color, float _colorRatio){
  
  if(_region!=null){
    if(_region.getRegionState() == RegionMapInformation.RegionState.MIXED_OBSTACLE){
      
      //Stop draw child
      if(_colorRatio==0) return;
      
      _color *= _colorRatio;
      if(_region.getLURegion()!=null)  drawQuadtreeCuttingCrossLine(_image, _region.getLURegion(), _color, _colorRatio);
      if(_region.getRURegion()!=null)  drawQuadtreeCuttingCrossLine(_image, _region.getRURegion(), _color, _colorRatio);
      if(_region.getLDRegion()!=null)  drawQuadtreeCuttingCrossLine(_image, _region.getLDRegion(), _color, _colorRatio);
      if(_region.getRDRegion()!=null)  drawQuadtreeCuttingCrossLine(_image, _region.getRDRegion(), _color, _colorRatio);
      
    }else{
      
      int _width = _region.getRDPointX() - _region.getLUPointX();
      int _height = _region.getRDPointY() - _region.getLUPointY();

      int selectPointX = _region.getLUPointX();
      int selectPointY = _region.getLUPointY();
      
      int indexX;
      if(_width==0){
        indexX = 1;
      }else{
        indexX = _width/abs(_width);
      }//end if
      
      int indexY;
      if(_height==0){
        indexY = 1;
      }else{
        indexY = _height/abs(_height);
      }//end if
      
      
      //Horizontal Line
      selectPointX = _region.getLUPointX();
      selectPointY = _region.getLUPointY() + _height/2;
      if(_height==0){
        
        //One grid corress line
        for(int i=0; i<=abs(_width); i++){
          drawCuttingRegionPointCenterHorizontal(_image, CUT_SIZE, selectPointX, selectPointY, _color);
          selectPointX += indexX;
        }//end for
        
      }else {
        if(abs(_height) % 2 == 1){
            
          //Odd
          for(int i=0; i<abs(_width); i++){
            drawCuttingRegionPointCenterHorizontal(_image, CUT_SIZE, selectPointX, selectPointY, _color);
            selectPointX += indexX;
          }//end for
            
        }else{
            
          //Even
          for(int i=0; i<abs(_width); i++){
            drawCuttingRegionPointDown(_image, CUT_SIZE, selectPointX, selectPointY-1, _color);
            selectPointX += indexX;
          }//end for
          
        }//end if
      }//end if
        
      //Vertical Line
      selectPointX = _region.getLUPointX() + _width/2;
      selectPointY = _region.getLUPointY();
      if(_width==0){
        
        //One grid crossline
        for(int j=0; j<=abs(_height); j++){
          drawCuttingRegionPointCenterVertical(_image, CUT_SIZE, selectPointX, selectPointY, _color);
          selectPointY += indexY;
        }//end for
        
      }else {
        if(abs(_width) % 2 == 1){
            
          //Odd
          for(int j=0; j<abs(_height); j++){
            drawCuttingRegionPointCenterVertical(_image, CUT_SIZE, selectPointX, selectPointY, _color);
            selectPointY += indexY;
          }//end for
            
        }else{
            
          //Even
          for(int j=0; j<abs(_height); j++){
            drawCuttingRegionPointRight(_image, CUT_SIZE, selectPointX-1, selectPointY, _color);
            selectPointY += indexY;
          }//end for
          
        }//end if
      }//end if
    }//end if
  }//edn if
  
}//end frawQtreeCuttinCrossLine

//------------------------------------------------------------------------------------------
void drawQuadtreeState(PImage _image, RegionMapInformation _quadtree, color _emityColor, color _mixColor, color _fullColor){
  
  if(_quadtree != null){
    
    if( (_quadtree.getRegionState() == RegionMapInformation.RegionState.EMITY_OBSTACLE) || 
        (_quadtree.getRegionState() == RegionMapInformation.RegionState.FULL_OBSTACLE) ){
          
      drawQuadtreeCuttingArea(_image, _quadtree, _emityColor, _mixColor, _fullColor); 
          
    }else if( (_quadtree.getRegionState() == RegionMapInformation.RegionState.MIXED_OBSTACLE) && _quadtree.isLeaf() ){
      
      drawQuadtreeCuttingArea(_image, _quadtree, _emityColor, _mixColor, _fullColor); 
        
    }else if( (_quadtree.getRegionState() == RegionMapInformation.RegionState.MIXED_OBSTACLE) && !_quadtree.isLeaf() ){
      // Draw child region color
      drawQuadtreeState(_image, _quadtree.getLURegion(), _emityColor, _mixColor, _fullColor);
      drawQuadtreeState(_image, _quadtree.getRURegion(), _emityColor, _mixColor, _fullColor);
      drawQuadtreeState(_image, _quadtree.getLDRegion(), _emityColor, _mixColor, _fullColor);
      drawQuadtreeState(_image, _quadtree.getRDRegion(), _emityColor, _mixColor, _fullColor); 
    }//end if
  }//end if
}//end drawQUadtreeState

//------------------------------------------------------------------------------------------
void drawConnectRegion(RegionMapInformation _region, int _state, color _selectColor, color _connectColor){
  
  if(_region == null) return;
  
  //It is not want region state.
  if(_region.getRegionState() !=_state) return;
  
  color mixColor = color(255,0,0);
  color fullColor = color(0,255,0);
  
  ConnectionInformation[] connectRegions = _region.getConnectionRegions();
  if((connectRegions != null) &&(connectRegions.length>0)){
    //print("connect regions number = "+connectRegions.length+"\n");
    for(int i=0;i<connectRegions.length;i++){
      if(connectRegions[i]!=null){
        drawQuadtreeCuttingArea(outputImage, connectRegions[i].getConnectRegion(), _connectColor, mixColor, fullColor);
      }
    }
  }//end if
  
  drawQuadtreeCuttingArea(outputImage, _region, _selectColor, mixColor, fullColor);
}

//------------------------------------------------------------------------------------------
void drawConnectRegions(RegionMapInformation[] _regions, color _selectColor, color _connectColor){
  
  if(_regions.length<=0) return;
  
  int state = _regions[0].getRegionState();
  
  print("regions = " + _regions.length+"\n");
  for(int i=0;i<_regions.length;i++){
    drawConnectRegion(_regions[i], state,_selectColor, _connectColor);
  }
}