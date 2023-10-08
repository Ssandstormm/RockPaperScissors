// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RockPaperScissors {
    address public player1;
    address public player2;
    address public winner;

    enum Move { None, Rock, Paper, Scissors }
    mapping(address => Move) public moves;

    event GameResult(address player1, Move move1, address player2, Move move2, address winner);

    modifier onlyPlayers() {
        require(msg.sender == player1 || msg.sender == player2, "Only players can call this function");
        _;
    }

    function joinGame() public {
        require(player1 == address(0) || player2 == address(0), "Game is full");
        require(msg.sender != player1, "You cannot play against yourself");
        if (player1 == address(0)) {
            player1 = msg.sender;
        } else {
            player2 = msg.sender;
        }
    }

    function makeMove(Move move) public onlyPlayers {
        moves[msg.sender] = move;
        if (moves[player1] != Move.None && moves[player2] != Move.None) {
            determineWinner();
        }
    }

    function determineWinner() internal {
        Move move1 = moves[player1];
        Move move2 = moves[player2];
        if (move1 == move2) {
            winner = address(0);  // It's a draw
        } else if ((move1 == Move.Rock && move2 == Move.Scissors) ||
                   (move1 == Move.Paper && move2 == Move.Rock) ||
                   (move1 == Move.Scissors && move2 == Move.Paper)) {
            winner = player1;
        } else {
            winner = player2;
        }
        emit GameResult(player1, move1, player2, move2, winner);
        // Reset the game
        player1 = address(0);
        player2 = address(0);
        moves[player1] = Move.None;
        moves[player2] = Move.None;
    }
}
