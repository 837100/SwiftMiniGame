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
    
    var todo: String
    var todoDetails: String?
    var todoNumber: Int?
    var makeDate: Date?
    var endDate: Date
    
    init(todo: String , endDate: Date) {
        self.todo = todo
        self.endDate = endDate
    }
}
