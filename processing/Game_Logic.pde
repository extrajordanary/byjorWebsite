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

