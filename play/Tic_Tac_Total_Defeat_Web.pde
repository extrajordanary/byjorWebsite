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
  size(500, 500, OPENGL);

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

// START OR RESET GAME
//______________________________________________________
void setupGame() {   
  // set up array to store game state
  for (int i = 0; i < 9; i++) {
    gameState[i] = 0;
  }
  currentPlayer = 1;
  isTurnTaken = false;
  turnsTaken = 0;
  isGameSetup = true;
  isGameOver = false;
  theWinner = "Tie - no one"; // default end game message fragment
  turnStart = millis();
}

// GAME LOGIC
//______________________________________________________
boolean placeMarkInCell(int cell) {
  if (debug) println("Placing...");
  if (cell > -1 && cell < 9) { 
    // check for valid cell number
    if (gameState[cell] == 0) { 
      // cell not yet taken
      gameState[cell] = currentPlayer;
      isTurnTaken = true;
      turnsTaken++;
    }
  }

  if (debugGameState) {
    printArray(gameState);
  }
  return isTurnTaken;
}

void endTurn() {
  if (turnsTaken > 4) { 
    // no possible win unless player 1 has taken at least 3 turns
    gameOverCheck();
  }
  if (!isGameOver) {
    currentPlayer = currentPlayer * -1;
    isTurnTaken = false;
    turnStart = millis();
  }
}

void gameOverCheck() {
  if (madeWinningMove(gameState, currentPlayer)) {
    theWinner = currentPlayerString;
    isGameOver = true;
  } else if (turnsTaken > 8 ) { 
    // board full, tie game
    isGameOver = true;
  }
}

boolean madeWinningMove(int[] theGameState, int player) {
  // check all possible winning combos
  if (theGameState[4]*player == 1) { 
    if ((theGameState[0]*player == 1 && theGameState[8]*player == 1) ||
      (theGameState[1]*player == 1 && theGameState[7]*player == 1) ||
      (theGameState[2]*player == 1 && theGameState[6]*player == 1) ||
      (theGameState[3]*player == 1 && theGameState[5]*player == 1)) {
      return true;
    }
  } 
  if (theGameState[0]*player == 1) {
    if ((theGameState[1]*player == 1 && theGameState[2]*player == 1) ||
      (theGameState[3]*player == 1 && theGameState[6]*player == 1)) {
      return true;
    }
  } 
  if (theGameState[8]*player == 1) {
    if ((theGameState[2]*player == 1 && theGameState[5]*player == 1) ||
      (theGameState[6]*player == 1 && theGameState[7]*player == 1)) {
      return true;
    }
  }
  return false;
}

// AI LOGIC
//______________________________________________________
void takeTurnAI() {
  if (!isTurnTaken) {
    int cell = chooseBestCell(gameState, currentPlayer);
    if (debug) println("AI chooses cell "+cell);
  
    boolean success = placeMarkInCell(cell);
  
    if (success) {
      if (autoEndTurn) endTurn();
    } else { 
      // logic error resulting in failed cell placement
      println("Error: AI logic fail.");
    }
  }
}

int chooseBestCell(int[] theGameState, int player) {
  // returns index of best cell's position in gameState array
  int bestCell;
  // see which cells are still available
  IntList openCells = getOpenCells(theGameState);
  if (openCells.size() > 8) {
    // choose randomly if making very first move
     return int(random(9));
  }
  // get best outcomes for each available cell
  IntList bestOutcomes = getBestOutcomesArray(theGameState, player, 0);
  if (debug) printArray(bestOutcomes);
  
  // get the best of the outcomes from the IntList
  int bestOutcome = bestOutcomeInArray(bestOutcomes, player);
  
  // get index of cell with best outcome
  bestCell = openCells.get(0);
  for (int i = 0; i < bestOutcomes.size(); i ++) {
    if (bestOutcomes.get(i) == bestOutcome) {
      bestCell = openCells.get(i);
    }
  }

  return bestCell;
}

int getBestOutcome(int[] theGameState, int player, int depth) {
  // return value representing best game outcome for the player
  int bestOutcome;

  // see which cells are still available
  IntList openCells = getOpenCells(theGameState);
  
  if (openCells.size() < 1) {
    // no moves to make, so must be a tie
    if (debug) println("getBestOutcome called on gameState with no open cells");
    bestOutcome = 0;
    
  } else if (openCells.size() == 1) {
    // if only one option, return value for win or tie
    int testCell = openCells.get(0);
    int[] newGameState = getPossibleGameState(theGameState, testCell, player);

    if (madeWinningMove(newGameState, player)) {
      bestOutcome = (10 * player) - (depth * player);
    } else {
      bestOutcome = 0;
    }
    
  } else {
    // else, get best outcome for each possible move
    IntList bestOutcomes = getBestOutcomesArray(theGameState, player, depth);
    
    // return the best of the outcomes
    bestOutcome = bestOutcomeInArray(bestOutcomes, player);
  }
  return bestOutcome;
}

IntList getBestOutcomesArray(int[] theGameState, int player, int depth) {
  IntList bestOutcomes = new IntList();
  IntList openCells = getOpenCells(theGameState);
  
  for (int i = 0; i < openCells.size(); i++) {
      // for each possible move, create newGameState
      int testCell = openCells.get(i);
      int[] newGameState = getPossibleGameState(theGameState, testCell, player);

      // check if newGameState is win condition
      int best;
      if (madeWinningMove(newGameState, player)) {
        // if win, set outcome value to add to array
        best = (10 * player) - (depth * player);
      } else {
        // recursive call, passed to next player
        int nextPlayer = player * -1;
        best = getBestOutcome(newGameState, nextPlayer, depth - 1);
      }
      bestOutcomes.append(best);
    }
  if (debug) println(depth);
  if (debug) printArray(bestOutcomes);
  return bestOutcomes;
}

int bestOutcomeInArray(IntList array, int player) {
  // return the best of the outcomes from the IntList
  if (player > 0) { // player X
    return array.max();
  } else {
    return array.min();
  }
}

IntList getOpenCells(int[] theGameState) {
  IntList openCells = new IntList();
  for (int i = 0; i < theGameState.length; i++) {
    if (theGameState[i] == 0) {
      openCells.append(i);
    }
  }
  if (debug) {
    println("Open cells: " + openCells.size());
  }
  return openCells;
}

int[] getPossibleGameState(int[] theGameState, int cell, int player) {
 // returns newGameState for player claiming cell
  int[] possGameState = new int[9];
  arrayCopy(theGameState, possGameState);
  possGameState[cell] = player;
  
  return possGameState;
}
