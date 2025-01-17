//
//  ToDoFind.swift
//  ToDoApp
//
//  Created by SG on 1/17/25.
//

import SwiftUI
import SwiftData

struct ToDoFind: View {
    
    var todo: String
    var endDate: Date
    
    @Environment(\.modelContext) private var modelContext
    @State private var found: [Item] = []
    
    var body: some View {
        VStack {
            List {
                ForEach(found) { item in
                    HStack {
                        Text(item.todo)
                        Text(item.endDate.description)
                    }
                    
                }
            }
            .navigationTitle("Find ToDoList")
        }
        .task {
            let descriptor = FetchDescriptor<Item>(predicate: #Predicate<Item> { item in
                if item.todo.contains(todo) {
                    return true
                } else if item.endDate <= endDate {
                    return true
                } else {
                    return false
                }
            })
            do {
                found = try modelContext.fetch(descriptor)
            } catch {
                print("Error fetching items: \(error)")
                found = []
            }
        }
    } // end of body
} // end of ToDoFind
