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
    
    private var todoItems: [Todo.ID: Todo] = [:]
    
    // MARK: Function(s)
    
    func currentCompletedCount() -> Int {
        return todoItems.values.filter { !$0.isCompleted }.count
    }
    
    func allTodoIdentifiers() -> [Todo.ID] {
        return Array(todoItems.keys)
    }
    
    func item(for identifier: Todo.ID) -> Todo? {
        return todoItems[identifier]
    }
    
    func create(_ newTodoTitle: String) -> Todo.ID {
        let newTodo = Todo(description: newTodoTitle)
        update(newTodo)
        return newTodo.id
    }
    
    func update(_ updatingTodo: Todo) {
        todoItems.updateValue(updatingTodo, forKey: updatingTodo.id)
    }
    
    func remove(_ removingIdentifier: Todo.ID) {
        todoItems.removeValue(forKey: removingIdentifier)
    }
    
    func fetchTodos(_ completion: @escaping ([Todo.ID]) -> Void) {
        let exampleTodos = [
            Todo(description: "Write Essay"),
            Todo(description: "Buy groceries"),
            Todo(description: "Workout"),
            Todo(description: "SpaceX Research"),
            Todo(description: "Prepare for scrum"),
            Todo(description: "Do laundry"),
            Todo(description: "Book a nice hotel in Tokyo")
        ]
        exampleTodos.forEach { todoItems[$0.id] = $0 }
        completion(exampleTodos.map { $0.id })
    }
}
