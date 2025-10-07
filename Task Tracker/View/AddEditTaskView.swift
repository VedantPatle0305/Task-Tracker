//
//  AddEditTaskView.swift
//  Task Tracker
//
//  Created by Vedant Patle on 07/10/25.
//

import SwiftUI

struct AddEditTaskView: View {
    @ObservedObject var viewModel = TaskStore()
    @Binding var taskToEdit: Task?
    
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var dueDate = Date()
    
    var body: some View {
        VStack(spacing: 16) {
            Text(taskToEdit == nil ? "Add Task" : "Edit Task" )
                .font(.title2)
            
            TextField("Task Title", text: $title)
                .textFieldStyle(.roundedBorder)
            
            DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            
            HStack {
                Button("Cancel"){
                    dismiss()
                    taskToEdit = nil
                }
                Spacer()
                Button("Save") {
                    if let editing = taskToEdit {
                        viewModel.update(task: editing, newTitle: title, newDueDate: dueDate)
                    } else {
                        viewModel.addTask(title, dueDate)
                    }
                    taskToEdit = nil
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            
        }
        .padding()
        .frame(width: 300)
        .onAppear {
            if let editingTask = taskToEdit {
                title = editingTask.title
                dueDate = editingTask.dueDate
            }
        }
    }
}


#Preview {
    let dummyStore = TaskStore()
    let sampleTask = Task(title: "Preview Task", dueDate: Date().addingTimeInterval(86400))
    return AddEditTaskView(
        viewModel: dummyStore,
        taskToEdit: .constant(sampleTask)
    )
}


