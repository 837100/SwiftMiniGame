//
//  DetailView.swift
//  ToDoApp
//
//  Created by SG on 1/17/25.
//

import SwiftUI
import SwiftData
struct DetailView: View {
    let todoId: UUID
    @State var endDate: Date
    @State var todo: String
    @State var todoDetails: String
    
    // SwiftData 쿼리 정의 - todoNumber와 일치하는 항목만 가져오기
 
    @Environment(\.modelContext) private var modelContext
    @Query private var foundItems: [Item]
    init(todoId: UUID, todo: String, todoDetails: String , endDate: Date) {
        self.todoId = todoId
        self.todo = todo
        self.todoDetails = todoDetails
        self.endDate = endDate
        // 초기화 시 쿼리 predicate 설정
        _foundItems = Query(filter: #Predicate<Item> { item in
            item.todoId == todoId && item.todoId == todoId && item.endDate == endDate
        })
    }
    
    var body: some View {
        VStack {
            if foundItems.isEmpty {
                
                Text("할 일 \(todoId)를 찾을 수 없습니다")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                
                List(foundItems) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("\(item.todo)", text: $todo)
                            .border(.secondary)
                        
                        TextField("\(item.todoDetails)",
                                  text: $todoDetails,
                                  axis: .vertical
                        )
                            .lineLimit(1...20)
                            .border(.secondary)
                        
                        /// 마감 기한을 선택할 수 있는 날짜 선택기를 생성
                        DatePicker(selection: $endDate) {
                            Text("기한")
                        }
                        .border(.secondary)
                        
                    }
                    Button(action: {
                        updateItem()
                    }, label: {
                        Text("수정 하기")
                    })
                    .border(.blue)
                    
                    Text("\(todoId)")
                }
                .padding(.vertical, 4)
            }
        }
    }
    // 날짜 포맷팅 함수
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func updateItem() {
          guard let item = foundItems.first else { return }
          withAnimation {
              item.todo = todo
              item.todoDetails = todoDetails
              item.endDate = endDate
              
              // 변경 사항 저장
              do {
                  try modelContext.save()
              } catch {
                  print("Error saving updated item: \(error)")
              }
          }
    } // end of updateItem
    
}



//
//#Preview {
//    DetailView()
//}
