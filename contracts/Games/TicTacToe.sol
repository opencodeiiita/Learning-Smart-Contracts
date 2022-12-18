// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract TicTacToe {

    address player1;
    address player2;

    enum squareState {empty, X ,O}
    squareState[3][3] board;  // 2d array which will be filled with empty/X/O squares
    uint8 cur_move=0;

    constructor(address _player2) public {
        require(player2!=address(0x0));
        player1=msg.sender;
        player2=_player2;
    }

    // returns the current state of the whole board in form of a string
    function stateToString() public view returns(string memory){
        return string(abi.encodePacked("\n",
        rowToString(0),"\n",
        rowToString(1),"\n",
        rowToString(2),"\n"));
    }

    // returns the current state of a row in form of a string
    function rowToString(uint8 y) public view returns (string memory){
        return string(abi.encodePacked(squareToString(0,y),"|",squareToString(1,y),"|",squareToString(2,y)));
    }

    // checks whether the block is valid
    function positionValid(uint8 x,uint8 y) public pure returns (bool){
        return (x>=0 && x<3 && y>=0 && y<3);
    }

    function squareToString(uint8 x,uint8 y) public view returns(string memory) {
        require(positionValid(x,y));
        if(board[x][y]==squareState.empty) return " ";
        if(board[x][y]==squareState.X) return "X";
        if(board[x][y]==squareState.O) return "O";
    }

    // whenver a move is to be made by a player this func is triggered
    function move(uint8 x,uint8 y) public {
        // pre-requisites
        require(msg.sender==player1 || msg.sender==player2);
        require(!gameOver());
        require(positionValid(x,y));
        require(msg.sender==currentPlayer());
        require(board[x][y]==squareState.empty);

        if(currentPlayer()==player1)
            board[x][y]=squareState.X;
        else
            board[x][y]=squareState.O;
        cur_move++;
    }

    // returns true if the game is over else false
    function gameOver() public view returns (bool){
        return (winningPlayer()!=squareState.empty || cur_move>8);
    }

    function currentPlayer() public view returns (address) {
        if(cur_move%2==0)
            return player1;
        else
            return player2;
    }

    // contains the logic of three continous O or X across columns,rows and diagonals
    function winningPlayer() public view returns(squareState){
        if(board[0][0]!=squareState.empty && board[0][0]==board[1][0] && board[0][0]==board[2][0])
            {return board[0][0];}
        if(board[0][1]!=squareState.empty && board[0][1]==board[1][1] && board[0][1]==board[2][1])
            {return board[0][1];}
        if(board[0][2]!=squareState.empty && board[0][2]==board[1][2] && board[0][2]==board[2][2])
            {return board[0][2];}

        if(board[0][0]!=squareState.empty && board[0][0]==board[0][1] && board[0][0]==board[0][2])
            {return board[0][0];}
        if(board[1][0]!=squareState.empty && board[1][0]==board[1][1] && board[1][0]==board[1][2])
            {return board[1][0];}
        if(board[2][0]!=squareState.empty && board[2][0]==board[2][1] && board[2][0]==board[2][2])
            {return board[2][0];}

        if(board[0][0]!=squareState.empty && board[0][0]==board[1][1] && board[0][0]==board[2][2])
            {return board[0][0];}
        if(board[0][2]!=squareState.empty && board[0][2]==board[1][1] && board[0][2]==board[2][0])
            {return board[0][2];}
    }

    // returns the address of the winner if there is any otherwise 0 address
    function winner() public view returns (address) {
        if(winningPlayer()==squareState.X) return player1;
        if(winningPlayer()==squareState.O) return player2;
        return address(0x0);
    }
}
