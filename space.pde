class Space{
  
  ArrayList<Body> body ;
  IntList cid;
  float delta ;
  
  Space(){
    body = new ArrayList<Body>();
    cid = new IntList();
  }
  
  
  void run(){
    update();
    fixUpdate();
    display();   
  }
  
  void update(){
    
    delta = 1/frameRate;
    
    int l = body.size();
    
    for(int i = 0 ; i < l ; i++){
      body.get(i).update(delta);
    }
    
    cid.clear();
  
  }
  
  void display(){
    
    int l = body.size();
    
    for(int i = 0 ; i< l ; i++ ){
      
      body.get(i).display();
    
    }
  }
  
  
  void addBody(Body b){
    body.add(b);
  }
  
  Body addBody(float x,float y,float a,int n){
    Matrial m = new Matrial();
    Shape s = new Shape(n,a);
    Body b = new Body(x,y,s,m);
    body.add(b);
    
    return b;
  }
  
  
  void fixUpdate(){
    
    //chech which bodies are collided and separate them
   
    int l = body.size();
    for(int i = 0 ; i < l ; i++ ){

      Body bi = body.get(i);
      
      for(int j = i+1 ; j < l ; j++ ){
        Body bj = body.get(j);
        

         if(cdBodyBody(bi,bj)){ 
           
           //separate body by moving them back if they are collided
           while(cdBodyBody(bi,bj)){
             bi.update(-delta/100);
             bj.update(-delta/100);
           }


           //store them to apply physics
           cid.append(bi.id);
           cid.append(bj.id);
         }      
       }  
     }
     
     //Applying physics to collided bodies
     int cl = cid.size();
     
     for(int i = 0 ; i < cl ; i += 2 ){
       
       Body bi = body.get(cid.get(i));
       Body bj = body.get(cid.get(i+1));
       
       Vec2d c12 = Vsub(bi.position,bj.position);
       float maxDist = Vmag(c12) , d[] = new float[4] ;
       Vec2d v[] = new Vec2d[4];
       
       //finding line of bi that collide with line joining of two center
       for(int k = 0 ; k < bi.shape.n ; k++){
         
         if(cdLineLine(bi.position , bj.position , bi.getVertex(k) , bi.getVertex((k+1)%bi.shape.n) )){
           v[0] = new Vec2d(bi.getVertex(k));
           v[1] = new Vec2d(bi.getVertex( (k+1)%bi.shape.n ));
           break;
         }
       }
       
       //finding line of bj that collide with line joining of two center
       for(int k = 0 ; k < bj.shape.n ; k++){
         
         if(cdLineLine(bi.position , bj.position , bj.getVertex(k) , bj.getVertex((k+1)%bj.shape.n) )){
           v[2] = new Vec2d(bj.getVertex(k));
           v[3] = new Vec2d(bj.getVertex( (k+1)%bj.shape.n ));
           break;
         }
       }
       
       //
       if(v[0]==null || v[2]==null) continue ;
       
      //for v[0] to v[3],v[2]
      Vec2d dl = Vsub(v[3], v[2]);
      float lamda = Vdot(Vsub(v[0], v[2]), dl)/sq(Vmag(dl));
      
      if (lamda<1 && lamda > 0 ) {
        Vec2d point = Vsum(v[2], Vmult(dl, lamda));
        d[0] = Vdist(v[0], point);
      } 
      else {
        d[0] = maxDist;
      }

      //for v[1] to v[2],v[3];
      lamda = Vdot(Vsub(v[1], v[2]), dl)/sq(Vmag(dl));
      if (lamda<1 && lamda > 0 ) {
        Vec2d point = Vsum(v[2], Vmult(dl, lamda));
        d[1] = Vdist(v[1], point);
      } 
      else {
        d[1] = maxDist;
      }

      //for v[2] to v[1],v[0]
      dl = Vsub(v[1], v[0]);
      lamda = Vdot(Vsub(v[2], v[0]), dl)/sq(Vmag(dl));
      if (lamda<1 && lamda > 0 ) {
        Vec2d point = Vsum(v[0], Vmult(dl, lamda));
        d[2] = Vdist(v[2], point);
      } 
      else {
        d[2] = maxDist;
      }

      //for v[3] to v[1],v[0]
      lamda = Vdot(Vsub(v[3], v[0]), dl)/sq(Vmag(dl));
      if (lamda<1 && lamda > 0 ) {
        Vec2d point = Vsum(v[0], Vmult(dl, lamda));
        d[3] = Vdist(v[3], point);
      } 
      else {
        d[3] = maxDist;
      }
      
      float minDist = min(d);
      Body bodyA , bodyB;
      
      int temp = 0 ;
      
      for(int k = 0 ; k < 4 && temp < 2 ; k++){
        
        if( abs(minDist - d[k]) < 0.001 ){
          //v[k] is contact point
          temp++;
          
          //finding noraml to collision edge
          Vec2d n;
          if(k<2){
            //bi has contact point make it BodyA
            n = Vnormal(Vsub(v[3],v[2]));
            bodyA = bi;
            bodyB = bj;
          }
          else{
            //bj has contact point make it BodyA
            n = Vnormal(Vsub(v[1],v[0]));
            bodyA = bj;
            bodyB = bi;
          }
          
          //now BodyA has contact point and BodyB has edge
          
          //find ra , rb 
          Vec2d ra = Vsub(v[k],bodyA.position);
          Vec2d rb = Vsub(v[k],bodyB.position);
          
          //find velocity of points
          Vec2d va = Vsum(bodyA.velocity,Vcross(bodyA.omega,ra));
          Vec2d vb = Vsum(bodyB.velocity,Vcross(bodyB.omega,rb));
          
          //relative velocity
          Vec2d vab = Vsub(va,vb);
          
          float vn = Vdot(vab,n);
          
          if(vn>=0)continue;
          
          float e = sqrt( bodyA.matrial.e * bodyB.matrial.e );
          
          float J = -(1+e)*vn/( sq(Vmag(n))*(bodyA.mass_i + bodyB.mass_i) + sq(Vcross(ra,n))*bodyA.inertia_i + sq(Vcross(rb,n))*bodyB.inertia_i);
          Vec2d jn = Vmult(n,J);
          
          bodyA.applyImpulse(jn,ra);
          bodyB.applyImpulse(Vmult(jn,-1),rb);
                    
        }
        
      }

     }
  } 
}
