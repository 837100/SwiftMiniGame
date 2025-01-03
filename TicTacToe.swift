// 게임 보드를 표현하는 열거형
enum Piece {
    case empty
    case x
    case o
}



// 게임 상태를 표현하는 프로토콜
protocol GameState {
    var currentPlayer: Piece { get }
    var board: [[Piece]] { get }
    //[[piece]] 는 타입별칭을 만들 수 있다.
    func isValidMove(row: Int, column: Int) -> Bool
}

// 게임 로직을 담당하는 클래스
class TicTacToe: GameState {
    var board: [[Piece]]
    var currentPlayer: Piece
    
    init() {
        //        board + Array(repeating: Array(repeating: ))
        board = [[.empty, .empty, .empty],
                 [.empty, .empty, .empty],
                 [.empty, .empty, .empty]]
        currentPlayer = .x // x가 첫 번째 플레이어
        
    }
    
    
    func isValidMove(row: Int, column: Int) -> Bool {
        //TODO: isValidMove 메서드 구현 ( 그 칸이 비어있는지)
        
        if(board[row][column] == .empty){
            print("현재 지정하신 칸은 비어있습니다." )
            return true
        } else{
            print("현재 지정하신 칸은\(board[row][column]) 유저의 칸입니다." )
            return false
        }
        
    }
    
    func makeMove(row: Int, column: Int){
        //TODO: 플레이어 이동 메서드 구현
        board[row][column] = currentPlayer
        print("해당 칸을 \(currentPlayer) 유저 칸으로 변경합니다.")
        
        
    }
    func playerChange(){
        if(currentPlayer == .x){
            currentPlayer = .o
            
        } else {
            currentPlayer = .x
            
        }
    }
    
    func checkWinner(rowCheck: Bool, columCheck: Bool, diagonalCheck1: Bool , diagonalCheck2: Bool) -> Piece? {
        if(rowCheck || columCheck || diagonalCheck1 || diagonalCheck2){
            return currentPlayer
        }
        return .empty
    }
    
    func rowCheck() -> Bool {
        var winStack: Int = 0
        var checkResult: Bool = false
        firstLoop: for i in 0...2 {
            secondLoop:  for j in 0...2 {
                if(  board[i][j] == currentPlayer){
                    winStack += 1
                  
                }
            }
            if winStack==3 {
                checkResult = true
                break firstLoop
            } else {
                winStack = 0
            }
        }
//        print("rowCheck result : \(checkResult)")
        return checkResult
    }
    
    func columnCheck() -> Bool {
        var winStack: Int = 0
        var checkResult: Bool = false
        firstLoop: for i in 0...2 {
            secondLoop: for j in 0...2 {
                if(board[j][i] == currentPlayer){
                    winStack += 1
                }
            }
            if winStack==3 {
                checkResult = true
                break firstLoop
            } else {
                winStack = 0
            }
        }
//        print("columnCheck result : \(checkResult)")
        return checkResult
    }
    
    // /방향 체크
    func diagonalCheck1() -> Bool {
        var winStack: Int = 0
        var checkResult: Bool = false
        
        for i in 0...2 {
            if ( board[2-i][0+i] == currentPlayer){
                winStack += 1
                
            }
        }
        if winStack==3 {
            checkResult = true
            
        }
//        print("diagonalCheck1 result : \(checkResult)")
        return checkResult
    }
    
    // \ 방향 체크
    func diagonalCheck2() -> Bool {
        
        var winStack: Int = 0
        var checkResult: Bool = false
       
        for i in 0...2 {
            if (board[i][i] == currentPlayer) {
                winStack += 1
            }
        }
        
        if winStack == 3 {
            checkResult = true
        }
        
//        print("diagonalCheck2 result : \(checkResult)")
        return checkResult
       
    }
    
    func printBoard() {
        // 보드를 출력하는 코드
  
       
        
        print("----------")
        for i in 0...2 {
            for j in 0...2 {
                var userPrint: String
                switch board[i][j] {
                case .empty:
                    userPrint = " "
                case .x:
                    userPrint = "X"
                case .o:
                    userPrint = "O"
                }
                print(terminator:"|\(userPrint)|")
             
            }
            print()
            print("----------")
        }
     
     
    }
  
}

var game = TicTacToe()

while true {
    var round: Int = 0
    game.printBoard()
    print("\n현재 플레이어: \(game.currentPlayer)")
    
    print("행 입력 (0-2) ('q' 입력시 종료): ", terminator: "")
    let rowInput = readLine() ?? ""
    if rowInput == "q" {break}
    guard let row = Int(rowInput) else { continue }
    
    print("열 입력 (0-2) ('q' 입력시 종료): : ", terminator: "")
    let colInput = readLine() ?? ""
    if colInput == "q" {break}
    guard let column = Int(colInput) else { continue }

    
    if !game.isValidMove(row: row, column: column) {
        print("다시 시도해주세요.")
        continue
    } else {
        game.makeMove(row: row, column: column)
    }
   
   
    
//    let rowCheck: Bool = game.rowCheck()
//    let columnCheck: Bool = game.columnCheck()
//    let diagonalCheck: Bool = game.diagonalCheck()
    
    round += 1
    if let winner = game.checkWinner(rowCheck: game.rowCheck(), columCheck: game.columnCheck(), diagonalCheck1: game.diagonalCheck1(),diagonalCheck2: game.diagonalCheck2()) {
       
        
        if (winner == .empty && round >= 9) {
            print("무승부")
            break
        } else if(winner != .empty){
            print("\(winner) 승리")
            game.printBoard()
            break
        }
    }
    game.playerChange()
}
