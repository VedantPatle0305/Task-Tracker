//
//  ContentView.swift
//  Task Tracker
//
//  Created by Vedant Patle on 07/10/25.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskStore()
    @State private var showAddSheet = false
    @State private var editTask: Task?
    
    
    var body: some View {
        NavigationStack {
            List{
                if viewModel.tasks.isEmpty {
                    Text("No tasks yet!")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
                
                ForEach(viewModel.tasks) { task in
                    HStack{
                        Toggle("", isOn: Binding(
                            get: {task.isDone},
                            set: {_ in viewModel.toggleDone(for: task)}))
                        .labelsHidden()
                        .padding()
                        
                        VStack(alignment: .leading){
                            Text(task.title)
                                .strikethrough(task.isDone)
                            Text((task.dueDate), style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            editTask = task
                            showAddSheet = true
                        } label: {
                            Image(systemName: "pencil")
                        }
                        .padding()
                        .buttonStyle(.borderless)
                        
                        Button {
                            viewModel.delete(task: task)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .padding()
                        .buttonStyle(.borderless)

                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            viewModel.delete(task: task)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .transition(.slide)
                }
            }
            .navigationTitle("Task Tracker")
            .toolbar {
                Button(action: { showAddSheet = true }) {
                    Label("Add Task", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddEditTaskView(viewModel: viewModel, taskToEdit: $editTask)
        }
    }
}

#Preview {
    TaskListView()
}
