class Shape{
  
  int n;
  Vec2d vertex[];
  Vec2d center;
  float r[] , angle[];
  float a , rmin , rmax ;
  
  float area;
  
  //shape has a only polygone for now
  //and it only related to shape no other perameters like position , rotation 
  //it center is at (0,0)
  
  Shape(int n_,float a_){
    n = n_;
    a = a_;
    
    rmax = a/(2*sin(PI/4)) ;
    rmin = sqrt(rmax*rmax - a*a/4) ;
    
    area = n*a*rmin/2;
    
    vertex = new Vec2d[n];
    angle = new float[n];
    r = new float[n];
    
    //setting angle[i] , r[i] and vertex[i] 
    for(int i = 0 ; i < n ; i++ ){
      angle[i] = 2*PI*i/n;
      r[i] = rmax;
      vertex[i] = new Vec2d(r[i]*cos(angle[i]) , r[i]*sin(angle[i]));
    }
    
      
  }
  
  void display(){
    
    //drawing shape
    beginShape();
    for(Vec2d v : vertex ){
      vertex(v.x,v.y);
    }
    endShape(CLOSE);
  }
  
}
