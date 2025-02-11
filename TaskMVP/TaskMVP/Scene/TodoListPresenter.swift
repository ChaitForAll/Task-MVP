//
//  TodoListPresenter.swift
//  TaskMVP
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

protocol TodoMarkingViewDelegate: AnyObject {
    func displayTitle(_ titleString: String)
    func displayTodos(_ allTodoIdentifiers: [UUID])
    func displayNewTodo(_ newTodoIdentifier: UUID)
    func displayTodoStatusMark(_ isCompleted: Bool, taskIdentifier: UUID)
    func displayCompletedTodoCount(_ completedTodosCount: Int)
}

final class TodoListPresenter {
    
    // MARK: Property(s)
    
    private var viewDelegate: TodoMarkingViewDelegate?
    private let todoListModel: TodoListModel
    
    init(todoListModel: TodoListModel) {
        self.todoListModel = todoListModel
    }
    
    // MARK: Function(s)
    
    func item(for identifier: UUID) -> Todo? {
        return todoListModel.item(for: identifier)
    }
    
    func addDelegate(_ delegateTarget: TodoMarkingViewDelegate) {
        self.viewDelegate = delegateTarget
    }
    
    func viewDidLoad() {
        viewDelegate?.displayTitle("My List")
        todoListModel.fetchTodos { [weak self] fetchedIdentifiers in
            self?.viewDelegate?.displayTodos(fetchedIdentifiers)
        }
    }
    
    func select(_ itemIdentifier: UUID) {
        if var selectedTodo = todoListModel.item(for: itemIdentifier) {
            selectedTodo.isCompleted = selectedTodo.isCompleted ? false : true
            todoListModel.update(selectedTodo)
            viewDelegate?.displayTodoStatusMark(selectedTodo.isCompleted, taskIdentifier: selectedTodo.id)
            viewDelegate?.displayCompletedTodoCount(todoListModel.currentCompletedCount())
        }
    }
    
    func newTodo(_ newTodoTitle: String) {
        let createdTodoIdentifier = todoListModel.create(newTodoTitle)
        viewDelegate?.displayNewTodo(createdTodoIdentifier)
    }
}
