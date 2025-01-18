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

    @Environment(\.modelContext) private var modelContext
   
    
    // SwiftData 쿼리 정의 - todoNumber와 일치하는 항목만 가져오기
    @Query private var foundItems: [Item]
    
    init(todoId: UUID) {
        self.todoId = todoId
        // 초기화 시 쿼리 predicate 설정
        _foundItems = Query(filter: #Predicate<Item> { item in
            item.todoId == todoId
        })
    }
    
    var body: some View {
      
        
        
        
        VStack(spacing: 20) {
            List {
//                Text("\(items.todo), \(items.todoNumber)")
                
                //                TextField("할 일", text: items.todo)
                //                    .textFieldStyle(.roundedBorder)
                //
                //
                //                TextField("할 일 상세", text: items.todoDetails  ,axis: .vertical)
                //                    .lineLimit(2...20)
                //                    .textFieldStyle(.roundedBorder)
                //                //            DatePicker("마감일", selection: item.endDate)
                //
                //
                //
                //            Spacer()
            }
            .navigationTitle("ToDo Detail")
        }
    
        .padding()
       
    
    }
}
//                                                   
//#Preview {
//    DetailView()
//}
