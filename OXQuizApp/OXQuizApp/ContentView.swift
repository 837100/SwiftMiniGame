//
//  ContentView.swift
//  OXQuizApp
//
//  Created by SEONGGYEONG NO on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    @State var number1: Int = 4
    @State var number2: Int = 2
    @State var resultNumber: Int = 9
    @State var inputAnswer: Bool = false
    
    @State var countCorrect: Int = 0
    @State var countWrong: Int = 0
    
    var body: some View {
        // UI 구성 및 로직 작성 부분
        
        VStack {
        Text("다음 수식은 맞을까요?")
            .font(.largeTitle)
            .fontWeight(.heavy)
       
        
            Text("\(number1) X \(number2) = \(resultNumber)")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            HStack {
                Button(action: {selectAnswerButton(answer: true)}){
                    Text("맞음")
                }
                
                    Button(action: {selectAnswerButton(answer: false)}){
                        Text("틀림")
                    
                }
            }
            VStack {
                HStack {
                    Text("\(countCorrect)개 맞춤")
                    Text("\(countWrong)개 틀림")
                }
                
                
            }
            
            VStack {
                Button(action: reloadGame) {
                    Text("카운트 초기화")
                }
            }
        }
    }
    func reloadGame() -> Void{
        // 게임 재시작 로직
        print("reloadGame")
        countCorrect = 0
        countWrong = 0
        reloadQuiz()
    }
    
    func reloadQuiz() {
        number1 = Int.random(in: 1...19)
        number2 = Int.random(in: 1...19)
        var resultRandom: Int = Int.random(in: 1...3)
        switch(resultRandom) {
        case 1:
            resultNumber = number1 * number2
        case 2:
            resultNumber = number1 * number2 + Int.random(in: 1...2)
        case 3:
            resultNumber = number1 * number2 - Int.random(in: 1...2)
        default:
            print("error")
        }
       
    }
    func selectCorrect() {
        // 정답 선택 시 로직
        countCorrect += 1
        reloadQuiz()
        print("정답 카운트 \(countCorrect)")
    }
    
    func selectWrong() {
        // 오답 선택 시 로직
        countWrong += 1
        reloadQuiz()
        print("오답 카운트 \(countWrong)")
    }
    
    func selectAnswerButton(answer: Bool) {
        var correctAnswer: Bool = false
        correctAnswer = number1 * number2 == resultNumber
        //        print("answer = \(answer)")
        if (answer == correctAnswer) {
            selectCorrect()
        } else {
            selectWrong()
        }
    }
    
} // end of ContentView()

#Preview {
    ContentView()
}
