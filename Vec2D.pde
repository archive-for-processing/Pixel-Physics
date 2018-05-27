class Vec2d{
  float x,y;
  
  Vec2d(float x_ , float y_ ){
    x = x_;
    y = y_;
  }
  
  Vec2d(Vec2d v){
    x = v.x;
    y = v.y;
  }
  
  Vec2d(){
    x = 0;
    y = 0;
  }
  
}


Vec2d Vsum(Vec2d v1,Vec2d v2){
  return new Vec2d( v1.x + v2.x , v1.y + v2.y );
}

Vec2d Vsub(Vec2d v1,Vec2d v2){
  return new Vec2d( v1.x - v2.x , v1.y - v2.y );
}

float Vdot(Vec2d v1,Vec2d v2){
  return v1.x*v2.x + v1.y*v2.y;  
}

float Vcross(Vec2d v1,Vec2d v2){
  return v1.x*v2.y - v1.y*v2.x;
}

Vec2d Vcross(Vec2d v , float z){
  return new Vec2d(v.y*z , - v.x*z);
}

Vec2d Vcross(float z , Vec2d v){
  return new Vec2d(-v.y*z , v.x*z);
}

float Vmag(Vec2d v){
  return sqrt(v.x*v.x + v.y*v.y);
}

Vec2d Vdiv(Vec2d v , float d){
  return new Vec2d(v.x/d , v.y/d );
}

Vec2d Vmult(Vec2d v , float m){
  return new Vec2d(v.x*m,v.y*m);
}

Vec2d Vrotate(Vec2d v,float a){
  return new Vec2d(v.x*cos(a) - v.y*sin(a),v.x*sin(a) + v.y*cos(a));
}

Vec2d Vnormal(Vec2d v){
  return new Vec2d(v.y,-v.x); 
}

Vec2d Vunit(Vec2d v){ 
  
  if(v.x==0&&v.y==0)
    return new Vec2d(0,0);
    
  float m = Vmag(v);  
  return new Vec2d(v.x/m,v.y/m);
}

void Vprint(Vec2d v){
  println("[",v.x,",",v.y,"]");
}

float Vdist(Vec2d v1 , Vec2d v2){
  return dist(v1.x,v1.y,v2.x,v2.y);
}

void Vzero(Vec2d v){
   v.x = v.y = 0 ;
}


void Vdrawf(Vec2d v,Vec2d v2,color c){
  pushStyle();
  stroke(c);
  fill(c);
  line(v2.x, v2.y, v2.x + v.x, v2.y+v.y);
  strokeWeight(5);
  point(v2.x +v.x, v2.y+v.y);
  popStyle();
}

void Vdrawf(Vec2d v,Vec2d v2){
  pushStyle();
  stroke(0);
  fill(0);
  line(v2.x, v2.y, v2.x + v.x, v2.y+v.y);
  strokeWeight(5);
  point(v2.x +v.x, v2.y+v.y);
  popStyle();

}