//
//  ContentView.swift
//  ToDoApp
//
//  Created by SG on 1/17/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var todo: String = ""
    @State var todoNumber: Int = 0
    @State var makeDate: Date = Date()
    @State var endDate: Date =  {
        let calendar = Calendar.current
        return calendar.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
    } ()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Spacer()
                TextField("오늘의 할 일을 적어주세요 : 예) 빨래널기", text: $todo)
                    .border(.secondary)
                
                DatePicker(selection: $endDate) {
                    Text("기한은 언제까지인가요?")
                }
                .border(.secondary)
                
                
                HStack {
                    Button(action: {
                        todo = ""
                    }, label: {
                        Text("다시 쓰기")
                    })
                    .border(.blue)
                    NavigationLink(destination: ToDoFind(todo: todo , endDate: endDate)) {
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
                
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            Text(item.todo)
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
    
    private func addItem() {
        withAnimation {
            let newItem = Item(todo: todo, endDate: endDate)
            print(todo, endDate)
            modelContext.insert(newItem)
        }
    } // end of addItem
    
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
