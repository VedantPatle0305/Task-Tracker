//
//  TaskStoreVM.swift
//  Task Tracker
//
//  Created by Vedant Patle on 07/10/25.
//

import SwiftUI
import Foundation

@MainActor
class TaskStore: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet{
            saveTasks()
        }
    }
    
    private let taskKey = "taskKey"
    
    init() {
        loadTasks()
    }
    
    private func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: taskKey),
        let decoded = try? JSONDecoder().decode([Task].self, from: data) else { return }
        tasks = decoded
    }
    
    func toggleDone(for task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            withAnimation {
                tasks[index].isDone.toggle()
            }
        }
    }
    
    func delete(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            withAnimation {
                tasks.remove(at: index)
            }
        }
    }
    
//    func delete(at offsets: IndexSet) {
//        withAnimation {
//            tasks.remove(atOffsets: offsets)
//        }
//    }
    
    func update(task: Task, newTitle: String, newDueDate: Date) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }){
            tasks[index].title = newTitle
            tasks[index].dueDate = newDueDate
        }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: taskKey)
        }
    }
    
    func addTask(_ title: String, _ dueDate: Date) {
        withAnimation {
            let newTask = Task(id: UUID(), title: title, dueDate: dueDate)
            tasks.append(newTask)
        }
    }
    
}

