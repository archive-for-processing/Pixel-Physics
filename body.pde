int pID = 0;

class Body{
  
  Vec2d position ;
  float thita;
  
  Shape shape ;
  
  Vec2d velocity, acceleration , del_vel;
  
  float omega , alpha , del_omega;
  
  float mass , mass_i ,inertia_i , inertia ;
  
  Matrial matrial;
  
  int id;
  
  
  Body(float x_ , float y_ , Shape s , Matrial m){
    
    position = new Vec2d(x_,y_);

    shape = s;
    
    matrial = m;
    
    mass = m.dencity*s.area ;
    inertia = mass*(s.a*s.a + 12*s.rmin*s.rmin)/24;
    
    mass_i = 1/mass ;
    inertia_i = 1/inertia ;
        
    velocity = new Vec2d();
    acceleration = new Vec2d();
    del_vel = new Vec2d();
    
    id = pID++;
  }
  
  void update(float delta){
      
      velocity = Vsum(velocity,Vmult(acceleration,delta) );
      velocity = Vsum(velocity , del_vel);
      
      position = Vsum(position , Vmult(velocity , delta ) );
      
      omega += alpha*delta + del_omega ;

      thita += omega*delta;
       
      //set to zero for next frame calculation
      del_vel = new Vec2d();
      del_omega = 0 ;
  }
  
  void display(){
        
    pushMatrix();
    
    translate(position.x,position.y);
    rotate(thita);
    
    shape.display();
    
    popMatrix();
    
  }
  
  void applyForce(Vec2d v){
    //acceleration = Vsum(acceleration,Vmult(v,mass_i));
    del_vel = Vsum(del_vel,Vmult(v,mass_i));
  }
  
  void applyTourq(float z){
    //alpha += z*inertia_i;
    del_omega += z*inertia_i;
  }
  
  
  void applyImpulse(Vec2d j , Vec2d r ){
    //Force
    del_vel = Vsum(del_vel , Vmult(j,mass_i));
    
    //Tourq
    del_omega += Vcross(r,j)*inertia_i ;
  }
  
  Vec2d getVertex(int i){
    //get rotation and pos
    //get vertex i from shape
    //sum up things
    //return vec
    Vec2d v = Vrotate(shape.vertex[i],thita);
    v = Vsum(v,position);
    return v;
  }
  
}
