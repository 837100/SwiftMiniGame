import SwiftUI
import SwiftData

struct ToDoFind: View {
    let endDate: Date
    let todo: String

    
    // SwiftData 쿼리 정의 - todoNumber와 일치하는 항목만 가져오기
   
    @Query private var foundItems: [Item]
    
    init( todo: String, endDate: Date) {

        self.todo = todo
        self.endDate = endDate
        // 초기화 시 쿼리 predicate 설정
        _foundItems = Query(filter: #Predicate<Item> { item in
            if todo == "" {
                return item.endDate <= endDate
            } else {
                return item.todo.localizedStandardContains(todo) && item.endDate <= endDate
            }
        })
    }
    
    var body: some View {
        
            VStack {
                if foundItems.isEmpty {
                    // 항목을 찾지 못한 경우
                    Text("조건에 해당하는 할 일을 찾을 수 없습니다")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // 찾은 항목 표시
                    NavigationStack {
                        List{
                            ForEach(foundItems) { item in
                                NavigationLink {
                                    DetailView(todoId: item.todoId,
                                               todo: item.todo,
                                               todoDetails: item.todoDetails,
                                               endDate: item.endDate)
                                } label: {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("할 일: \(item.todo)")
                                            .font(.headline)
                                        
                                        Text("할 일 상세: \(item.todoDetails)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        Text("마감일: \(formatDate(item.endDate))")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                        
                                        Text("todoId: \(item.todoId)")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                        
                                    }
                                }
                            }
                            
                        }
                        
                        .padding(.vertical, 4)
                    }
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
}

// 프리뷰용 코드
//#Preview {
//    ToDoFind(todoNumber: 1)
//        .modelContainer(for: Item.self, inMemory: true)
//}
