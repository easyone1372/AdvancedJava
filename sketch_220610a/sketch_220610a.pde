Fish[] fishes = new Fish[20];   // 객체 배열 생성
ArrayList<Food> foods = new ArrayList<Food>();
PImage photo;
int angle=60;

void setup(){
  size(800, 800);
  frameRate(10);
  for(int i=0; i<fishes.length; i++) fishes[i] = new Fish();   // 배열 속 객체 생성
  photo = loadImage("che.png");
}

void draw(){
  background(255);
  pushMatrix();
    rotate(radians(angle));
        if (keyPressed) {
      if (key=='r'||key == 'R') {
            angle--;
    image(photo, 0, 0);

      }
  }
  popMatrix();
  for(Fish r: fishes) r.draw();   // 물고기 그리기

  if(foods.size()>=0){
    for(int i=0; i<foods.size(); i++)  foods.get(i).draw();   // 먹이 생성. thread?
  }
}

void keyReleased() {
    angle=60;
}

// 마우스 클릭하면 먹이 생성
void mousePressed(){
  foods.add(new Food());   // 객체 생성 및 배열에 넣기
}

// 물고기 클래스****************************
class Fish{
  PVector pos;   // 물고기 위치
  
  Fish(){
    pos = new PVector(random(0, width), random(0, height));   // 랜덤 스폰
  }
  
  void draw(){
    pos.x += random(-2, 2);
    pos.y += random(-2, 2);
    //rotate(radians(random(-2, 2)));   // 회전
    
    // <먹이 추적>
    // 방향 파악, 위치 관계
    int minDistFood=0;
    float minDist=Float.MAX_VALUE;
    // 타겟 선정
    // 가까운 애들 추적
    if(foods.size()>=0){
      for(int i=0; i<foods.size(); i++){
        float dist= PVector.dist(pos, foods.get(i).fpos);
        if(dist<minDist){
          minDist = dist;
          minDistFood=i;   // 가장 가까운 먹이
        }
      }
    
      // 거리가 150 미만이면
      if(minDist<150){
        Food target = foods.get(minDistFood);   // 그 먹이를 타겟으로 설정
        
        // 속도 크기, 방향 계산
        PVector vel = PVector.sub(target.fpos, pos);
        // 속도 지정
        vel.normalize();   // 크기 1
        vel.mult(5);      // 그쪽으로
        // translate(pos.x, pos.y);   // Flocking 예제?
        //vel.heading();   // 도형 파라미터도 바꾸기
        // 속도 기반 위치 업데이트
        pos.add(vel);
        // 먹이 객체가 없어지면 그대로 가기
      }
    }
    
    // 경계조건
    if(pos.x>width) pos.x=0;
    if(pos.x<0) pos.x=width;
    if(pos.y>height) pos.y=0;
    if(pos.y<0) pos.y=height;
    
    fill(255);
    
    triangle(pos.x, pos.y, pos.x-10, pos.y-5, pos.x-10, pos.y+5);   // 꼬리
    ellipse(pos.x, pos.y, 15, 10);   // 몸통
  }
}

// 먹이 클래스****************************
class Food{
  PVector fpos; 
  
  Food(){
    fpos = new PVector(mouseX, mouseY);
  }
  
  void draw(){
    fill(57, 29, 0);   // 갈색
    circle(fpos.x, fpos.y, 10);
    
    // 중력 작용
    fpos.y+=3;
    
    if(fpos.y>height) fpos.y=height;   // 땅에 떨어짐
  }
}
