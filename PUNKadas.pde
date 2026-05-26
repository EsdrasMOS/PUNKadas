float p1_speedX = 0, p1_speedY = 0, p1_posX, p1_posY;
boolean p1_attacking = false;
float p1_armX, p1_armY, p1_armSize = 20;
float p1_cooldown = 0;
float p1_dirX = 1, p1_dirY = 0;
float p1_knockbackStartX, p1_knockbackStartY;
boolean p1_kbActive = false;

PImage sprite1_p1, sprite2_p1, sprite3_p1;
PImage sprite1_p2, sprite2_p2, sprite3_p2;
PImage img;

float p2_speedX = 0, p2_speedY = 0, p2_posX, p2_posY;
boolean p2_attacking = false;
float p2_armX, p2_armY, p2_armSize = 10;
float p2_cooldown = 0;
float p2_dirX = -1, p2_dirY = 0;
float p2_knockbackStartX, p2_knockbackStartY;
boolean p2_kbActive = false;

int p1_health = 100;
int p2_health = 100;

boolean gameOver = false;

float PLAYER_WIDTH = 150;
float PLAYER_HEIGHT = 250;
float HITBOX_WIDTH = 50;
float HITBOX_HEIGHT = 80;
float GROUND_Y;
float GRAVITY = 0.5;
float JUMP_FORCE = -20;

float HITBOX_RANGE = 90;
float HIT_DAMAGE = 1;
float ARM_MAX_SIZE = 200;
float ARM_START_SIZE = 150;
float KNOCKBACK = 0.5;

import processing.sound.*;
SoundFile dano;

void setup() {
  
  size(800, 600);
  img = loadImage("BG_image.png");
  img.resize(width, height);
  size(800, 500);
  GROUND_Y = height - PLAYER_HEIGHT - 10;
  
  p1_posX = 100;
  p1_posY = GROUND_Y;
  p2_posX = width - 130;
  p2_posY = GROUND_Y;
  
  sprite1_p1 = loadImage("sprite1_player1.png");
  sprite2_p1 = loadImage("sprite2_player1.png");
  sprite3_p1 = loadImage("sprite3_player1.png");
  
  sprite1_p2 = loadImage("sprite1_player2.png");
  sprite2_p2 = loadImage("sprite2_player2.png");
  sprite3_p2 = loadImage("sprite3_player2.png");
  
  dano = new SoundFile(this, "King_games.mp3");
  dano.loop(); 
}

void draw() {
  background(255);
  
  drawGround();
  background(img);
  updatePlayer1();
  updatePlayer2();
  checkCollision();
  updateArms();
  checkArmDamage();
  drawPlayer1();
  drawPlayer2();
  drawArms();
  drawHealthBar();

}

void drawGround() {
  fill(100);
  rect(0, height - 10, width, 10);
}

void updatePlayer1() {
  if (!gameOver) {
    if (p1_speedX != 0) {
      p1_dirX = p1_speedX / abs(p1_speedX);
      p1_dirY = 0;
    }
    
    p1_speedY += GRAVITY;
    
    p1_speedX = constrain(p1_speedX, -5, 5);
    
    p1_posX += p1_speedX;
    p1_posX = constrain(p1_posX, 0, width - PLAYER_WIDTH);
    
    p1_posY += p1_speedY;
    
    if (p1_posY >= GROUND_Y) {
      p1_posY = GROUND_Y;
      p1_speedY = 0;
    }
    if (p1_kbActive) {
      float kbDist = dist(p1_posX, p1_posY, p1_knockbackStartX, p1_knockbackStartY);
      if (kbDist >= 5) {
        p1_speedX = 0;
        p1_speedY = 0;
        p1_kbActive = false;
      }
    }
    
    if (p1_cooldown > 0) p1_cooldown--;
  }
}

void updatePlayer2() {
  if (!gameOver) {
    if (p2_speedX != 0) {
      p2_dirX = p2_speedX / abs(p2_speedX);
      p2_dirY = 0;
    }
    
    p2_speedY += GRAVITY;
    
    p2_speedX = constrain(p2_speedX, -5, 5);
    
    p2_posX += p2_speedX;
    p2_posX = constrain(p2_posX, 0, width - PLAYER_WIDTH);
    
    p2_posY += p2_speedY;
    
    if (p2_posY >= GROUND_Y) {
      p2_posY = GROUND_Y;
      p2_speedY = 0;
    }
    if (p2_kbActive) {
      float kbDist = dist(p2_posX, p2_posY, p2_knockbackStartX, p2_knockbackStartY);
      if (kbDist >= 5) {
        p2_speedX = 0;
        p2_speedY = 0;
        p2_kbActive = false;
      }
    }
    if (p2_cooldown > 0) p2_cooldown--;
  }
}

void updateArms() {
  if (p1_attacking) {
    float armCenterY = p1_posY + PLAYER_HEIGHT * 0.4;
    p1_armX = p1_posX + PLAYER_WIDTH/2 + p1_dirX * 25;
    p1_armY = armCenterY;
    p1_armSize += 1.5;
    if (p1_armSize > ARM_MAX_SIZE) {
      p1_attacking = false;
      p1_cooldown = 15;
    }
  }
  
  if (p2_attacking) {
    float armCenterY = p2_posY + PLAYER_HEIGHT * 0.4;
    p2_armX = p2_posX + PLAYER_WIDTH/2 + p2_dirX * 25;
    p2_armY = armCenterY;
    p2_armSize += 1.5;
    if (p2_armSize > ARM_MAX_SIZE) {
      p2_attacking = false;
      p2_cooldown = 15;
    }
  }
}

void checkArmDamage() {
  if (!gameOver) {
    if (p1_attacking && p1_cooldown <= 0) {
      float dist1 = dist(p1_armX, p1_armY, p2_posX + PLAYER_WIDTH/2, p2_posY + PLAYER_HEIGHT/2);
      if (dist1 < HITBOX_RANGE) {
        p2_health = max(0, p2_health - int(HIT_DAMAGE));
        p2_speedX = p1_dirX * 3;
        p2_speedY = p1_dirY * 3;
        p2_knockbackStartX = p2_posX;
        p2_knockbackStartY = p2_posY;
        p2_kbActive = true;
      }
    }
    
    if (p2_attacking && p2_cooldown <= 0) {
      float dist2 = dist(p2_armX, p2_armY, p1_posX + PLAYER_WIDTH/2, p1_posY + PLAYER_HEIGHT/2);
      if (dist2 < HITBOX_RANGE) {
        p1_health = max(0, p1_health - int(HIT_DAMAGE));
        p1_speedX = p2_dirX * 3;
        p1_speedY = p2_dirY * 3;
        p1_knockbackStartX = p1_posX;
        p1_knockbackStartY = p1_posY;
        p1_kbActive = true;
      }
    }
  }
}


void checkCollision() {
  if (!gameOver) {
    float dx = p2_posX - p1_posX;
    float dy = (p2_posY + PLAYER_HEIGHT/2) - (p1_posY + PLAYER_HEIGHT/2);
    float distance = dist(p1_posX + PLAYER_WIDTH/2, p1_posY + PLAYER_HEIGHT/2, p2_posX + PLAYER_WIDTH/2, p2_posY + PLAYER_HEIGHT/2);
    float collisionDist = (HITBOX_WIDTH + HITBOX_HEIGHT) / 2;
    if (distance < collisionDist) {
      dx /= distance;
      dy /= distance;
      float overlap = collisionDist - distance;
      p1_posX -= dx * overlap * 0.5;
      p2_posX += dx * overlap * 0.5;
      if (abs(dy) < 10) {
        p1_speedX *= 0.3;
        p2_speedX *= 0.3;
      }
    }
  }
}
void drawPlayer1() {
  pushMatrix();
  translate(p1_posX + PLAYER_WIDTH/2, p1_posY + PLAYER_HEIGHT/2);
  if (p1_dirX == -1) {
    scale(-1, 1);
  }
  imageMode(CENTER);
  float spriteWidth = HITBOX_WIDTH * 6.0;
  float spriteHeight = HITBOX_HEIGHT * 6.0;
  
  if (p1_attacking) {
    image(sprite3_p1, 0, 0, spriteWidth, spriteHeight);
  } else if (abs(p1_speedX) > 0 || p1_speedY != 0) {
    image(sprite2_p1, 0, 0, spriteWidth, spriteHeight);
  } else {
    image(sprite1_p1, 0, 0, spriteWidth, spriteHeight);
  }
  
  imageMode(CORNER); 
  popMatrix();
}

void drawPlayer2() {
  pushMatrix();
  
  translate(p2_posX + PLAYER_WIDTH/2, p2_posY + PLAYER_HEIGHT/2);
  if (p2_dirX == -1) {
    scale(1, 1);
  }else{
    scale(-1,1);}
    
  imageMode(CENTER);
  
  float spriteWidth = HITBOX_WIDTH * -6.0;
  float spriteHeight = HITBOX_HEIGHT * -6.0;
  
  if (p2_attacking) {
    image(sprite3_p2, 0, 0, spriteWidth, spriteHeight);
  } else if (abs(p2_speedX) > 0 || p2_speedY != 0) {
    image(sprite2_p2, 0, 0, spriteWidth, spriteHeight);
  } else {
    image(sprite1_p2, 0, 0, spriteWidth, spriteHeight);
  }
  
  imageMode(CORNER);
  popMatrix();
}

void drawArms() {
  if (p1_attacking) {
    fill(255, 255, 0);
    stroke(255, 200, 0);
    strokeWeight(3);
    pushMatrix();
    translate(p1_armX, p1_armY);
    rotate(atan2(p1_dirY, p1_dirX));
    rect(-p1_armSize/2, -5, p1_armSize, 10);
    popMatrix();
    noStroke();
  }
  
  if (p2_attacking) {
    fill(200, 0, 255);
    stroke(150, 0, 200);
    strokeWeight(3);
    pushMatrix();
    translate(p2_armX, p2_armY);
    rotate(atan2(p2_dirY, p2_dirX));
    rect(-p2_armSize/2, -5, p2_armSize, 10);
    popMatrix();
    
    noStroke();
  }
}

void drawHealthBar() {
  fill(100);
  rect(20, 20, 250, 25);
  rect(width - 270, 20, 250, 25);
  
  float p1_hp = constrain(p1_health, 0, 100);
  float p2_hp = constrain(p2_health, 0, 100);
  
  fill(map(p1_hp, 0, 100, 0, 255), map(p1_hp, 0, 100, 255, 0), 0);
  rect(20, 20, (p1_hp/100.0)*250, 25);
  
  fill(map(p2_hp, 0, 100, 0, 255), map(p2_hp, 0, 100, 255, 0), 0);
  rect(width - 270, 20, (p2_hp/100.0)*250, 25);

  fill(255);
  textSize(16);
  text(p1_hp, 30, 39);
  text(p2_hp, width - 260, 39);
  
  if (p1_health <= 0 && !gameOver) {
    gameOver = true;
  }
  if (p2_health <= 0 && !gameOver) {
    gameOver = true;
  }
  
  if (gameOver) {
    fill(0, 0, 0, 180);
    rect(0, 0, width, height);
    
    textSize(52);
    textAlign(CENTER);
    
    if (p1_health <= 0) {
      fill(255, 0, 0);
      text("Fim de Jogo!", width/2, height/2 - 25);
      fill(255);
      textSize(28);
      text("Jogador 2 Venceu!", width/2, height/2 + 20);
    } else {
      fill(0, 0, 255);
      text("Fim de Jogo!", width/2, height/2 - 25);
      fill(255);
      textSize(28);
      text("Jogador 1 Venceu!", width/2, height/2 + 20);
    }
    
    textSize(20);
    fill(200);
    text("Pressione R para reiniciar", width/2, height/2 + 70);
    textAlign(LEFT);
  }
}

void keyPressed() {
  if (!gameOver) {
    if (key == 'a' || key == 'A') p1_speedX = -5;
    if (key == 'd' || key == 'D') p1_speedX = 5;
    if ((key == 'w' || key == 'W') && p1_speedY == 0) {
      p1_speedY = JUMP_FORCE;
    }
    if (key == ' ') {
      if (!p1_attacking && p1_cooldown <= 0) {
        p1_attacking = true;
        p1_armSize = ARM_START_SIZE;
      }
    }
    
    if (keyCode == LEFT)  p2_speedX = -5;
    if (keyCode == RIGHT) p2_speedX = 5;
    if (keyCode == UP && p2_speedY == 0) {
      p2_speedY = JUMP_FORCE;
    }
    if (keyCode == ENTER) {
      if (!p2_attacking && p2_cooldown <= 0) {
        p2_attacking = true;
        p2_armSize = ARM_START_SIZE;
      }
    }
  }
  
  if (key == 'r' || key == 'R') {
    resetGame();
  }
}

void keyReleased() {
  if (!gameOver) {
    if (key == 'a' || key == 'A' || key == 'd' || key == 'D') p1_speedX = 0;
    if (key == 'w' || key == 'W') p1_speedY = 0;
    if (keyCode == LEFT || keyCode == RIGHT) p2_speedX = 0;
    if (keyCode == UP) p2_speedY = 0;
  }
}

void resetGame() {
  gameOver = false;
  p1_health = 100;
  p2_health = 100;
  p1_posX = 100;
  p1_posY = GROUND_Y;
  p2_posX = width - 130;
  p2_posY = GROUND_Y;
  p1_speedX = 0;
  p1_speedY = 0;
  p2_speedX = 0;
  p2_speedY = 0;
  p1_attacking = false;
  p2_attacking = false;
  p1_cooldown = 0;
  p2_cooldown = 0;
  p1_dirX = 1;
  p1_dirY = 0;
  p2_dirX = -1;
  p2_dirY = 0;
  p1_kbActive = false;
  p2_kbActive = false;
}