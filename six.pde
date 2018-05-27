//no complex shape
//Shape is still polygones

// + cdpolypoly improved 
// new shape and matreal are introduse
// vec2 -> vec2d :p



Matrial m;
Shape s1 , s2;
Body b1 , b2 ;

Space s;

void setup(){
  size(500,500);

  s = new Space();
  
  /*m = new Matrial();
  s1 = new Shape(5 , 50);
  s2 = new Shape(6 , 20);
  b1 = new Body(250,250,s1,m);
  b2 = new Body(100,100,s2,m);
  
  s.addBody(b1);
  s.addBody(b2);
  
  b2.velocity = new Vec2d(20,20);*/
  
    for(int i = 0 ; i < 5 ; i++){
    for(int j = 0 ; j < 5 ; j++){
       float r = random(20,40);
       Vec2d v = new Vec2d(250 - i*100 , 250 - j*100);
       v = Vunit(v);
       v = Vmult(v,random(50,100));
       s.addBody(10 + i*100, 10 + j*100 , r , (int)(120/r + 120/(r*r))).velocity = v;
    }
  }

}

void draw(){
  background(200);
  
  s.display();
  s.update();
  s.fixUpdate();
}
