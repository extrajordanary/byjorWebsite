/*
 * Tic Tac Total Defeat
 * (Jordan Arnesen, 2015 February 05)
 *  ---------------------------- 
 */

// VARIABLES
boolean debug = true;
boolean debugGameState = false;

boolean autoEndTurn = true;
boolean playAgainstAI = true;

boolean isGameSetup;
float boardInset = 80;
float cellSize;
String cellLetters = "rtyfghvbn";

int[] gameState = new int[9];
boolean isGameOver;
String theWinner;

int currentPlayer;
String currentPlayerString;
int turnsTaken;
boolean isTurnTaken;

int turnDelay = 1000; // milliseconds
int turnStart;


// MAIN FUNCTIONS
//______________________________________________________
void setup() {
  size(500, 500);

  cellSize = (height - (2 * boardInset)) / 3;
  isGameSetup = false;
  isGameOver = false;
}

void draw() {
  background(255);

  if (!isGameSetup) {
    setupGame();
  }
  drawBoard();
  showGameStatus();

  // If it's the AI's turn make a move
  if (playAgainstAI && !isGameOver && currentPlayer < 0) { 
    if (millis() - turnStart > turnDelay) {
      takeTurnAI();
    }
  }
}

// DISPLAY FUNCTIONS
//______________________________________________________
void drawBoard() {
  int i = 0;
  for (int k = 0; k < 3; k++) {
    for (int j = 0; j < 3; j++) {

      // draw cell
      stroke(0);
      noFill();
      float xPos = boardInset + cellSize*j;
      float yPos = boardInset + cellSize*k;
      rect(xPos, yPos, cellSize, cellSize);

      //draw letter or player mark
      if (gameState[i] == 0) { 
        // cell not yet taken - show which key to claim it
        fill(0);
        textSize(20);
        textAlign(LEFT, TOP);
        text(cellLetters.substring(i, i+1).toUpperCase(), xPos + 5, yPos + 2);
      } else {
        // show the mark of player who claimed cell
        textSize(40);
        textAlign(CENTER, CENTER);
        if  (gameState[i] > 0) { // player X
          fill(255, 0, 0);
          text("X", xPos + cellSize/2, yPos + cellSize/2);
        } else { // player O
          fill(0, 0, 255);
          text("O", xPos + cellSize/2, yPos + cellSize/2);
        }
      }
      i++;
    }
  }
}

void showGameStatus() {
  textSize(20);
  textAlign(LEFT, TOP);

  if (isGameOver) {
    // show who won and game reset instructions
    fill(0);
    text(theWinner+ " wins! To play again, press P.", 20, 15);
  } else {
    // show whose turn it is
    if (currentPlayer > 0) {
      fill(255, 0, 0);
      currentPlayerString = "X";
    } else {
      fill(0, 0, 255);
      currentPlayerString = "O";
    }
    if (!isTurnTaken) {
      text(currentPlayerString+"'s turn", 20, 15);
    } else { // not used when using automatic end turn
      text("Press Spacebar to change players.", 20, 15);
    }
  }
}

// PLAYER INPUTS
//______________________________________________________
void keyPressed() {
  if (isGameOver) {
    // can only start new game when prev game ends
    if (key == 'p') {
      setupGame();
    }
  } else if (isTurnTaken) {
    // can only change players if move already made
    if (key == ' ') {
      endTurn();
    }
  } else {
    // player must make a move
    if (key == 'q') { // for testing only
      isGameOver = true;
    } else if (key == 'a') {
      takeTurnAI();
    } else {
      int cell = cellLetters.indexOf(key); 
      if (debug) println("Human chooses cell "+cell);

      // -1 if key pressed was not in cellLetters
      if (cell > -1) {
        placeMarkInCell(cell);
        if (autoEndTurn && isTurnTaken) endTurn();
      }
    }
  }
}

