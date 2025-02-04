//
//  TodoListModel.swift
//  TaskMVP
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation

struct Todo: Identifiable {
    let id: UUID = .init()
    let description: String
    var isCompleted: Bool = false
}

final class TodoListModel {
    
    // MARK: Property(s)
    
    var toCompleteCount: Int {
        return todos.values
            .filter { !$0.isCompleted }
            .count
    }
    
    private var todos: [Todo.ID: Todo]
    
    init() {
        var todoDictionary: [Todo.ID: Todo] = [:]
        let todoItems = [
            Todo(description: "Write Essay"),
            Todo(description: "Buy groceries"),
            Todo(description: "Workout"),
            Todo(description: "SpaceX Research"),
            Todo(description: "Prepare for scrum"),
            Todo(description: "Do laundry"),
            Todo(description: "Book a nice hotel in Tokyo")
        ]
        todoItems.forEach { todoDictionary[$0.id] = $0 }
        self.todos = todoDictionary
    }
    
    // MARK: Function(s)
    
    func item(for todoIdentifier: Todo.ID) -> Todo? {
        return todos[todoIdentifier]
    }
    
    func update(todo: Todo) {
        self.todos.updateValue(todo, forKey: todo.id)
    }
    
    func allTodoIdentifiers() -> [Todo.ID] {
        return todos.values.map { $0.id }
    }
    
    func markCompleted(_ todoIdentifier: Todo.ID) {
        if var todoToUpdate = todos[todoIdentifier] {
            todoToUpdate.isCompleted = true
            update(todo: todoToUpdate)
        }
    }
    
    func markAsTodo(_ todoIdentifier: Todo.ID) {
        if var todoToUpdate = todos[todoIdentifier] {
            todoToUpdate.isCompleted = false
            update(todo: todoToUpdate)
        }
    }
}
