//
//  ContentView.swift
//  OXQuizApp
//
//  Created by SEONGGYEONG NO on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    let gradientView: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.init(red: 1, green: 0, blue: 0, opacity: 0.55), Color.init(red: 1, green: 0, blue: 0, opacity: 0.65)]), startPoint: .top, endPoint: .center)
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
                .padding(.top, 40)
            
            Spacer()
            
            Text("\(number1) X \(number2) = \(resultNumber)")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.vertical,20)
                .padding(.horizontal,50)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            Spacer()
            HStack {
                Button(action: {selectAnswerButton(answer: true)}){
                    Label("맞음", systemImage: "checkmark")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(.green)
                }
                .padding(.trailing, 20)
                
                Button(action: {selectAnswerButton(answer: false)}){
                    Label("틀림", systemImage: "xmark")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(.red)
                }
            }
            Spacer()
            VStack {
                HStack {
                    Text("\(countCorrect)개 맞춤")
                        .font(.largeTitle)
                        .padding(.trailing, 20)
                    Text("\(countWrong)개 틀림")
                        .font(.largeTitle)
                }
                
                
            }
            Spacer()
            
            VStack {
                Button(action:
                        reloadGame
                ){
                    Text("카운트 초기화")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .shadow(radius: 0, x:0, y:-1)
                        .foregroundStyle(.white)
                        .padding()
                        .background( ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.white)
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(gradientView)
                            RoundedRectangle(cornerRadius: 16)
                                .trim(from: 0, to: 0.5)
                                .foregroundColor(.red)
                        })
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray, lineWidth: 4)
                            .shadow(color: .black, radius:0, x: 0, y: -1)
                        )
                    
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
        switch(Int.random(in: 1...3)) {
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
