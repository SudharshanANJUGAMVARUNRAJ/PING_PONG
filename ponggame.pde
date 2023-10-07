import processing.net.*;
import gohai.simpletweet.*;
SimpleTweet simpletweet;

import processing.serial.*;

Serial serialPort;

int action = 0;

Ball ball;
Paddle rq1;
Paddle rq2;


int scoreleft  = 0;
int scoreright = 0;
boolean TweetSent = false;

int stop1 = 0;
int stop2 = 0;

void setup(){
  size(800,600); 
  ball = new Ball(width/2, height/2); 
  rq1 = new Paddle(10, height/2);
  rq2 = new Paddle(width-10, height/2);
  
  simpletweet = new SimpleTweet(this);

  simpletweet.setOAuthConsumerKey("6HJPmiLFPqHPSiJ1LjBPuDiFB");                                       //Enter your API key
  simpletweet.setOAuthConsumerSecret("Y8NUoTalvPcXP9ejaV2En3hAgXfviPBEWXM7aY831lqyaYOUQ9");           //Enter your API secret key
  simpletweet.setOAuthAccessToken("1465581742589317126-lSxfLZquwJy2mpHNPaMRoUJa1oMzqu");             //Enter your API Access token key
  simpletweet.setOAuthAccessTokenSecret("jWtYST0cqlWQ0WJGrbZRPoig7qKjzxfyLZ0sTudRisMvG");            ////Enter your API Access token secret key

  
  ball.speedx = -5;
  ball.speedy = 0;
  
   
   serialPort = new Serial(this, Serial.list()[0], 9600);
   serialPort.bufferUntil ( '\n' ); 
}

void serialEvent(Serial serialPort){
  float actionSer = float(serialPort.readStringUntil('\n'));
  
    println(actionSer);
    
   if(actionSer < 400){
   
     rq1.speedy = 5;
   }
   if(actionSer > 400){
   
    rq1.speedy = -5;
   }   
  } 
 
void draw(){
  background(0);
 
  ball.display(); 
  rq1.display(); 
  rq2.display();
  
  ball.movingStep(); 
  rq1.movingStep(); 
  rq2.movingStep();
  stopping();
  


  // strict ball
  if(ball.x + 50/2 > width){
    ball.x = width/2;
    ball.y = height/2;
    scoreleft = scoreleft + 1;
  }
  if(ball.x - 50/2 < 0){
    ball.x = width/2;
    ball.y = height/2;
    scoreright = scoreright +1 ;
  }
  
  
  if(ball.y + 50/2 > height || ball.y - 50/2 < 0){
    ball.speedy = -ball.speedy;
  }
  
  //control paddle1
  if(ball.y < rq1.y + rq1.h/2){//bottom paddle
    if(ball.y > rq1.y - rq1.h/2){//top paddle
      if(ball.x-50/2 < rq1.x+rq1.w/2){
       
        ball.speedx = -ball.speedx;
        ball.speedy = map(ball.y - rq1.y, -rq1.h/2, rq1.h/2, -15, 15);
      }
    }
  }
  
  // control paddle2
  if(ball.y < rq2.y + rq2.h/2){
    if(ball.y > rq2.y - rq2.h/2){
      if(ball.x+50/2 > rq2.x-rq2.w/2){
        ball.speedx = - ball.speedx;
        ball.speedy = map(ball.y - rq2.y, -rq2.h/2, rq2.h/2, -15, 15); //speed
      }
    }
  }
  
  // text
  textSize(30);
  text(scoreright, width-50, 30);
  text(scoreleft, 30, 30);
  
  //twitter sign
  //fill(75);
  //rect(width/2-40, 10, 80, 30);
  fill(255, 0, 0);
  text("PONG GAME", width/2-60,35,30);




if (scoreleft == 10 & TweetSent == false)
{
String tweet = simpletweet.tweet(" Player 1 won against Player 2   " + scoreleft+ ":" +""+scoreright + " Completion time : " + minute()+":"+ second());
println("Posted " + tweet);
TweetSent = true;
text(" Player 1 won against Player 2  " + ""+ scoreleft +":" +""+scoreright,360,350);
stop1 = 1;
reset();
}

if (scoreright == 10 & TweetSent == false){
String tweet = simpletweet.tweet(" Player 2 won against Player 1   " + ""+ scoreright +":" +""+scoreleft + " Completion time : " + minute()+":"+ second());
println("Posted " + tweet);
TweetSent = true;
text("Player 2 won against Player 1 " + ""+ scoreright +":" +""+scoreright,360,350);
stop2 = 1;
reset();
}

}



void reset(){
scoreright = 0;
scoreleft = 0;
ball.speedx = 0;
ball.speedy = 0;

TweetSent = false;
}

void stopping() {
  if (stop1 == 1 || stop2 == 1){
  text("GAME OVER", width/2-60,height/3-40);
       if (stop1 == 1){
             text("PLAYER 1 WON THE GAME", width/2-140,height/3+40);
       }
       else {
         text("PLAYER 2 WON THE GAME", width/2-140,height/3+40);
       }
       text("!!!!TWEET POSTED!!!!",width/2-120,height/3+180);
  }
}

  
void keyPressed(){
  switch(keyCode){
    case DOWN:
      rq1.speedy = 5;
      break;
    case UP:
      rq1.speedy = -5;
      break;
  }
  
}

void keyReleased(){
  switch(keyCode){
    case DOWN:
      rq1.speedy = 0;
      break;
    case UP:
      rq1.speedy = 0;
      break;
}
}
// use mouse control paddle2
void mousePressed(){
  if(mouseButton==LEFT){
    rq2.speedy = 5;
  }
  if (mouseButton==RIGHT){
    rq2.speedy = -5;
  }
}

void mouseReleased(){
  if(mouseButton==LEFT){
    rq2.speedy = 0;
  }
  if (mouseButton==RIGHT){
    rq2.speedy = 0;
  }
}
// draw ball
class Ball{
  float x, y;
  float speedx, speedy;
  
  Ball(float startx, float starty){
    x = startx;
    y = starty;
    speedx = 0;
    speedy = 0;
  }
  
  void display(){
    fill(255,0,0); 
    circle(x, y, 50);
  }
  
  void movingStep(){
     x = x + speedx;
     y = y + speedy;
  }
}

// draw paddle
class Paddle{
  float x, y;
  float speedy;
  float w = 10;
  float h = 150;
  
  Paddle(float startx, float starty){
    x = startx;
    y = starty;
    speedy = 0;
  }
  
  void display(){
    // display paddle
    fill(0,255,0);
    rect(x-w/2, y-h/2, w, h);
  }
  
  void movingStep(){
    //strict paddle
    if(y+speedy-h/2 > 0 && y+speedy-h/2 < height-h){
     
       y = y + speedy;
    }
  }


}
