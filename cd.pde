boolean cdPointPoly(Vec2d v,Vec2d[] p){

  boolean c = false;
  
  //https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html
  for(int i = 0 , j =  1 ; i < p.length ; i++ , j++ ){

    if(j==p.length)j=0;
 
    if ( ((p[i].y>v.y) != (p[j].y>v.y)) && 
    (v.x < (p[j].x-p[i].x) * (v.y-p[i].y) / (p[j].y-p[i].y) + p[i].x) )
       c = !c;
   }
  
  return c;
}


boolean cdPointLine(Vec2d p, Vec2d l1,Vec2d l2){
  
  float d = Vdist(l1,l2);
  float d1 = Vdist(p,l1);
  float d2 = Vdist(p,l2);
  
  if(d1+d2 < d + 0.075 && d1+d2 > d - 0.075 ){
    return true;
  }
  
  return false;
}

boolean cdLineLine(Vec2d l11 ,Vec2d l12,Vec2d l21,Vec2d l22){

  //http://paulbourke.net/geometry/pointlineplane/
  float d = (l22.y - l21.y)*(l12.x - l11.x) - (l22.x-l21.x)*(l12.y - l11.y);
  float n1 = (l22.x - l21.x)*(l11.y - l21.y) - (l22.y - l21.y)*(l11.x -l21.x);
  float n2 = (l12.x - l11.x)*(l11.y - l21.y) - (l12.y - l11.y)*(l11.x - l21.x);  
  float ua = n1/d;
  float ub = n2/d;
  
  if(d!=0){
    if( ua<=1 && ua>=0 && ub<=1 && ub>=0 ) return true;
  }
  
  else{
    if(n1 == 0 && n2 == 0) return true;
  }
  
  return false;
}


boolean cdLinePoly(Vec2d l1 , Vec2d l2 ,Vec2d[] p){
  
  for(int i = 0 , j = 1 ; i < p.length ; i++ , j++){
    if(j==p.length)j=0;
    
    if(cdLineLine(l1,l2,p[i],p[j])) return true;
  }
  
  return false;
}


boolean cdPolyPoly(Vec2d p1[],Vec2d p2[]){
  
  //cheking if p1 is inside p2 or not
  if(cdPointPoly(p1[0],p2)) return true;
  
  //cheking if p2 is inside p1 or not
  if(cdPointPoly(p2[0],p1)) return true;
  
  int l = p1.length ;
  for(int i = 0 ; i < l ; i++ ){
    //for every line of p1 to polygone p2
    if(cdLinePoly(p1[i] , p1[(i+1)%l] , p2) ) return true;
  }
  return false;
}

boolean cdBodyBody(Body b1 , Body b2){
  
  // 1 . get bodies center and thita
  // 2 . get bodies shapes vertexs
  // 3 . make new vec2d array with vertexs shifted to center and rotated to thita
  // 4 . now check collsiion between new arrays
  
  Vec2d v1[] , v2[] ;
  
  v1 = new Vec2d[b1.shape.n];
  v2 = new Vec2d[b2.shape.n];
  
  for(int i = 0 ; i < b1.shape.n ; i++){
     v1[i] = b1.getVertex(i);
  }
  
  for(int i = 0 ; i < b2.shape.n ; i++){
     v2[i] = b2.getVertex(i);
  }
  
  
  return cdPolyPoly(v1,v2);
}

float distPointLine(Vec2d p ,Vec2d l1 , Vec2d l2){
  Vec2d dl = Vsub(l2,l1);
  
  float lamda = Vdot(Vsub(p,l1),dl)/sq(Vmag(dl));
  if(lamda>1 || lamda < 0 ) return -1 ;
  
  Vec2d l = Vsum(l1,Vmult(dl,lamda));
  
  return Vdist(p,l); 
  
}


/*void cdBoundry(Polygone p,int w , int h){
  float dx = 0, dy = 0 ;
  int xc = 0 , yc = 0 ;
  for(int i = 0 ; i < p.n ; i++){
    if(p.vertex[i].x>w){
      xc++;
      dx = p.vertex[i].x - w ;
    }
     if(p.vertex[i].x<0){
      dx = p.vertex[i].x ;
      xc++;
    }
    
    if(p.vertex[i].y>h){
      dy = p.vertex[i].y - h ;
      yc++;
    }
     if(p.vertex[i].y<0){
      dy = p.vertex[i].y ;
      yc++;
    }
    
  }
  
  if(xc>0){
    p.velocity.x*=-1;
    //p.velocity.x-=p.acceleration.x/sqrt(abs(dx));
    p.center.x -= dx;
    for(int i = 0 ; i < p.n ; i++){
      p.vertex[i].x-=dx;
      
    }
  }
  
  if(yc>0){
   p.center.y -=dy;
   p.velocity.y*=-1;
   //p.velocity.y-=p.acceleration.y/sqrt(abs(dy));
    for(int i = 0 ; i < p.n ; i++){
      p.vertex[i].y-=dy;
      
    }
  }
  
  if(xc>0||yc>0)p.omega*=-1;
}

float depth(Polygone p1 ,Polygone p2){
  float maxd = 0;
  
  Vec2d c12 = Vsub(p2.center,p1.center);
  c12 = Vmult(c12,(p1.rm+p2.rm)/Vmag(c12));
  Vec2d c21 = Vmult(c12,-1);
  Vec2d v[] = new Vec2d[4];
  float d[] = new float[4];
  
   //finding line of p1 that collide with line joining of two center
   for(int i = 0 ; i < p1.n ; i++){ 
   if(cdLineLine(p1.center,Vsum(p1.center,c12),p1.vertex[i],p1.vertex[(i+1)%p1.n])){
        v[0] = new Vec2d(p1.vertex[i]);
        v[1] = new Vec2d(p1.vertex[(i+1)%p1.n]);
     }
   }
   
   for(int i = 0 ; i < p2.n ; i++){ 
     if(cdLineLine(p2.center,Vsum(p2.center,c21),p2.vertex[i],p2.vertex[(i+1)%p2.n])){
        v[2] = new Vec2d(p2.vertex[i]);
        v[3] = new Vec2d(p2.vertex[(i+1)%p2.n]);  
     }
   }
   
   //for v[0] and v[1] to v[2],v[3]
   if(v[0]!=null && cdPointPoly(v[0],p2.vertex) ){
     d[0] = distPointLine(v[0],v[2],v[3]);
   }
   
   if(v[1]!= null  && cdPointPoly(v[1],p2.vertex) ){
     d[1] = distPointLine(v[1],v[2],v[3]);
   }
   
   if(v[2]!= null && cdPointPoly(v[2],p1.vertex) ){
     d[2] = distPointLine(v[2],v[0],v[1]);
   }
   
   if( v[3] != null && cdPointPoly(v[3],p1.vertex) ){
     d[3] = distPointLine(v[3],v[0],v[1]);
   }
   
   maxd = max(d);
   
   return maxd;   
}
*/
