//
//  TodoListPresenter.swift
//  TaskMVP
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

protocol TodoMarkingViewDelegate: AnyObject {
    func displayTitle(_ titleString: String)
    func displayTodos(_ allTodoIdentifiers: [UUID])
    func displayTodoStatusMark(_ isCompleted: Bool, taskIdentifier: UUID)
    func displayCompletedTodoCount(_ completedTodosCount: Int)
}

final class TodoListPresenter {
    
    // MARK: Property(s)
    
    private weak var viewDelegate: TodoMarkingViewDelegate?
    private var todoItems: [Todo.ID: Todo] = [:]
    
    private var toCompleteCount: Int {
        return todoItems.values.filter { !$0.isCompleted }.count
    }
    
    private var allTodoIdentifiers: [Todo.ID] {
        return todoItems.values.map { $0.id }
    }
    
    // MARK: Function(s)
    
    func addDelegate(_ viewDelegate: TodoMarkingViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func prepareToDisplay() {
        viewDelegate?.displayTitle("My Todos")
        fetchTodos()
    }
    
    func selectTodo(_ selectedIdentifier: Todo.ID) {
        isCompleted(selectedIdentifier) ? markAsTodo(selectedIdentifier) : markCompleted(selectedIdentifier)
        
        viewDelegate?.displayTodoStatusMark(
            isCompleted(selectedIdentifier),
            taskIdentifier: selectedIdentifier
        )
        viewDelegate?.displayCompletedTodoCount(toCompleteCount)
    }
    
    func item(for identifier: Todo.ID) -> Todo? {
        return todoItems[identifier]
    }
    
    // MARK: Private Function(s)
    
    private func fetchTodos() {
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
        viewDelegate?.displayTodos(allTodoIdentifiers)
    }
    
    private func isCompleted(_ todoIdentifier: Todo.ID) -> Bool {
        guard let todo = todoItems[todoIdentifier] else {
            return false
        }
        
        return todo.isCompleted
    }
    
    private func update(todo: Todo) {
        self.todoItems.updateValue(todo, forKey: todo.id)
    }
    
    private func markCompleted(_ todoIdentifier: Todo.ID) {
        if var todoToUpdate = todoItems[todoIdentifier] {
            todoToUpdate.isCompleted = true
            update(todo: todoToUpdate)
        }
    }
    
    private func markAsTodo(_ todoIdentifier: Todo.ID) {
        if var todoToUpdate = todoItems[todoIdentifier] {
            todoToUpdate.isCompleted = false
            update(todo: todoToUpdate)
        }
    }
}
