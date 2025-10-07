//
//  TaskModel.swift
//  Task Tracker
//
//  Created by Vedant Patle on 07/10/25.
//

import Foundation

struct Task: Codable, Identifiable{
    var id = UUID()
    var title: String
    var dueDate: Date
    var isDone: Bool = false
}


