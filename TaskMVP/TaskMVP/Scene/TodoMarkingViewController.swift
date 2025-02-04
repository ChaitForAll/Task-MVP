//
//  TodoMarkingViewController.swift
//  TaskMVP
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import UIKit

final class TodoMarkingViewController: UIViewController {
    
    // MARK: Type(s)
    
    typealias TodoCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UUID>
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, UUID>
    
    enum Section: Int {
        case todos
    }
    
    // MARK: Property(s)
    
    private var diffableDataSource: DiffableDataSource?
    private var summaryHeaderView: SummaryHeaderView?
    
    private let todoListModel = TodoListModel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationItem()
        updateSnapShot()
    }
    
    // MARK: Private Function(s)
    
    private func configureNavigationItem() {
        navigationItem.title = "My Tasks"
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        configureDiffableDataSource()
        collectionView.delegate = self
        collectionView.dataSource = diffableDataSource
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let summaryHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(1),
                heightDimension: .absolute(44)
            ),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .topLeading
        )
        
        let layout = UICollectionViewCompositionalLayout { index, environment in
            switch index {
            case Section.todos.rawValue:
                let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                let section = NSCollectionLayoutSection.list(
                    using: configuration,
                    layoutEnvironment: environment
                )
                section.contentInsets.top = 5
                section.boundarySupplementaryItems = [summaryHeader]
                return section
            default:
                return NSCollectionLayoutSection.list(
                    using: .init(appearance: .plain),
                    layoutEnvironment: environment
                )
            }
        }
        
        return layout
    }
    
    private func configureDiffableDataSource() {
        let cellRegistration = createCellRegistration()
        let summaryFooterRegistration = createSummaryFooterRegistration()
        let dataSource = DiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: summaryFooterRegistration,
                for: indexPath
            )
        }
        self.diffableDataSource = dataSource
    }
    
    private func createSummaryFooterRegistration() -> UICollectionView.SupplementaryRegistration<SummaryHeaderView> {
        return .init(elementKind: UICollectionView.elementKindSectionFooter) {
            supplementaryView, elementKind, indexPath in
            
            guard let snapShot = self.diffableDataSource?.snapshot() else {
                supplementaryView.update(tasksCount: .zero)
                return
            }
            
            supplementaryView.update(tasksCount: snapShot.itemIdentifiers.count)
            
            self.summaryHeaderView = supplementaryView
        }
    }
    
    private func createCellRegistration() -> TodoCellRegistration {
        return TodoCellRegistration { cell, indexPath , itemIdentifier in
            if let todoItem = self.todoListModel.item(for: itemIdentifier) {
                var content = cell.defaultContentConfiguration()
                content.text = todoItem.description
                cell.contentConfiguration = content
                cell.accessories = todoItem.isCompleted ? [.checkmark()] : []
            }
        }
    }
    
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapShot.appendSections([.todos])
        snapShot.appendItems(todoListModel.allTodoIdentifiers(), toSection: .todos)
        diffableDataSource?.apply(snapShot)
    }
}

// MARK: UICollectionViewDelegate

extension TodoMarkingViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewListCell,
           let itemIdentifier = diffableDataSource?.itemIdentifier(for: indexPath),
           let selectedItem = todoListModel.item(for: itemIdentifier) {
            if selectedItem.isCompleted {
                todoListModel.markAsTodo(selectedItem.id)
                cell.accessories = []
            } else {
                todoListModel.markCompleted(selectedItem.id)
                cell.accessories = [.checkmark()]
            }
            summaryHeaderView?.update(tasksCount: todoListModel.toCompleteCount)
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
