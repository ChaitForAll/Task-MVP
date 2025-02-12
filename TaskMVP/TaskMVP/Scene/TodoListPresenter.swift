//
//  TodoListPresenter.swift
//  TaskMVP
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

enum TodoListDisplayStyle {
    case incomplete
    case allCompleted
}

protocol TodoMarkingViewDelegate: AnyObject {
    func displayTitle(_ titleString: String)
    func displayTodos(_ allTodoIdentifiers: [UUID])
    func displayNewTodo(_ newTodoIdentifier: UUID)
    func displayTodoMark(_ shouldMark: Bool, taskIdentifier: UUID)
    func displayTodoListStatus(_ text: String, _ displayStyle: TodoListDisplayStyle)
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
            viewDelegate?.displayTodoMark(selectedTodo.isCompleted, taskIdentifier: selectedTodo.id)
            updateCompletedCount()
        }
    }
    
    func newTodo(_ newTodoTitle: String) {
        let createdTodoIdentifier = todoListModel.create(newTodoTitle)
        viewDelegate?.displayNewTodo(createdTodoIdentifier)
    }
    
    func updateCompletedCount() {
        let displayStyle: TodoListDisplayStyle  = todoListModel.currentCompletedCount() > 0 ? .incomplete : .allCompleted
        let displayText = displayStyle == .allCompleted ? "👏" : String(todoListModel.currentCompletedCount())
        viewDelegate?.displayTodoListStatus(displayText, displayStyle)
    }
}
