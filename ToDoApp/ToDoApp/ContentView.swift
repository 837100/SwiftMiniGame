import SwiftUI
import SwiftData


struct ContentView: View {
    
    @State var todo: String = ""
    @State var endDate: Date = Date()
    @State var todoDetails: String = ""
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        
        /// 네비게이션 기능을 위한 NavigationStack
        NavigationStack {
            /// 수직 레이아웃을 위한 VStack
            VStack {
                Spacer()
                /// 사용자가 할 일을 입력할 수 있는 텍스트 필드를 생성.
                TextField("오늘의 할 일을 적어주세요 : 예) 빨래널기", text: $todo)
                    .border(.secondary)
                
                TextField("상세 설명을 적어주세요", text: $todoDetails)
                    .border(.secondary)
                
                /// 마감 기한을 선택할 수 있는 날짜 선택기를 생성
                DatePicker(selection: $endDate) {
                    Text("기한은 언제까지인가요?")
                }
                .border(.secondary)
                
                
                HStack {
                    
                    Button(action: {
                        todo = ""
                        todoDetails = ""
                    }, label: {
                        Text("다시 쓰기")
                    })
                    .border(.blue)
                    /// 검색 화면으로 이동하는 네비게이션 링크
                    
                    NavigationLink  {
                        ToDoFind(
                            todo: todo,
                            endDate: endDate)
                    } label: {
                        Text("검색")
                    }
                    .border(.blue)
                    
                    Button(action: {
                        addItem()
                    }, label: {
                        Text("할 일 추가")
                    })
                    .border(.blue)
           
                } // end of HStack
                
                
                /// 저장된 할 일 목록을 표시하는 리스트 각 항목은 네비게이션 링크로 구성되어 있고, 스와이프로 삭제가 가능함.
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            DetailView(todoId: item.todoId,
                                       todo: item.todo,
                                       todoDetails: item.todoDetails,
                                       endDate: item.endDate)
                            
                        } label: {
                            HStack {
                                Text(item.todo)
                                Spacer()
                                Text(dateFormatString(date: item.endDate))
                                Text("\(item.todoId)")
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                    
                } // end of List
                
            } // end of VStack
            .navigationTitle("할 일 리스트")
        } // end of NavigationStack

    } // end of body view
    
    
    
    /// 새로운 할 일을 생성하고 SwiftData에 저장하는 함수
    private func addItem() {
        withAnimation {
            let newItem = Item(todo: todo, endDate: endDate, todoId: UUID(), todoDetails: todoDetails)
            modelContext.insert(newItem)
        }
    } // end of addItem
    
    
    /// 선택된 할일을 삭제하는 함수
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    } // end of deleteItems
    
    func dateFormatString(date: Date?) -> String {
        guard let date = date else { return "날짜 없음"}
        let formatter = DateFormatter()
        formatter.dateFormat = "HH월 dd일 HH:mm 까지"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
   

} // end of ContentView




#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
