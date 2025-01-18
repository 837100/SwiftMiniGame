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
    
    var todoId: UUID
    var todo: String
    var endDate: Date
    var todoDetails: String
  
    
    init(todo: String , endDate: Date, todoId: UUID, todoDetails: String) {
        self.todo = todo
        self.endDate = endDate
        self.todoId = todoId
        self.todoDetails = todoDetails
    }
}
