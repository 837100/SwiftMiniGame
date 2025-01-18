//
//  Item.swift
//  ToDoApp
//
//  Created by SG on 1/17/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    
    @Attribute(.unique) var todoId: UUID
    var todo: String
    var endDate: Date
    var todoDetails: String?
  
    
    init(todo: String , endDate: Date, todoId: UUID) {
        self.todo = todo
        self.endDate = endDate
        self.todoId = todoId
    }
}
