//
//  ContentView.swift
//  ToDoApp
//
//  Created by SG on 1/17/25.
//

/// 기본적인 SwiftUI 프레임워크와 데이터 지속성을 위한 SwfitData 프레임 워크를 불러옴.
import SwiftUI
import SwiftData

/// SwiftUI의 기본 View 프로토콜을 따르는 ContentView 구조체를 선언
struct ContentView: View {
    
    /// 할 일 텍스트를 저장하는 상태 변수
    @State var todo: String = ""
    /// 할 일의 고유번호를 저장하는 상태변수
    @State var todoId: UUID = UUID()
    /// 현재 날짜를 저장하는 상태변수
    @State var makeDate: Date = Date()
    /// 마감 날짜를 저장하는 상태 변수로, 초기값은 현재시간으로 부터 30분 후로 설정
    @State var endDate: Date =  {
        let calendar = Calendar.current
        return calendar.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
    } ()
 
    @State var todoDetails: String = ""
    
    /// SwiftData의 모델 컨텍스트를 환경 변수로 가져옴. 데이터를 저장하고 관리하는데 사용됨.
    @Environment(\.modelContext) private var modelContext
    /// SwfitData 에서 Item 모델의 모든 데이터를 가져오는 쿼리.
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
                
                /// 마감 기한을 선택할 수 있는 날짜 선택기를 생성
                DatePicker(selection: $endDate) {
                    Text("기한은 언제까지인가요?")
                }
                .border(.secondary)
                
                
                HStack {
                    
                    /// 입력된 할 일을 초기화 하는 버튼
                    Button(action: {
                        todo = ""
                    }, label: {
                        Text("다시 쓰기")
                    })
                    .border(.blue)
                    /// 검색 화면으로 이동하는 네비게이션 링크
                    NavigationLink(destination:
                                    ToDoFind(todoId: todoId)) {
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
                
                
                /// 저장된 할 일 목록을 표시하는 리스트 각 항목은 네비게시연 링크로 구성되어 있고, 스와이프로 삭제가 가능함.
                List {
                    ForEach(items) { item in
                        NavigationLink {
//                            DetailView(todoNumber: todoNumber)
                            
                        } label: {
                            HStack {
                                Text(item.todo)
                                Spacer()
                                Text(dateFormatString(date: item.endDate))
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                    
                } // end of List
                
            } // end of VStack
        } // end of NavigationStack
    } // end of body view
    
    
    
    /// 새로운 할 일을 생성하고 SwiftData에 저장하는 함수
    private func addItem() {
        withAnimation {
            let newItem = Item(todo: todo, endDate: endDate, todoId: todoId)
            print(todo, endDate)
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
        .modelContainer(for: Item.self, inMemory: false)
}
