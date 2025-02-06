//
//  TodoMarkingViewController.swift
//  TaskMVP
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import UIKit

final class TodoMarkingViewController: UIViewController {
    
    // MARK: Type(s)
    
    private typealias TodoCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UUID>
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, UUID>
    private enum Section: Int { case todos }
    
    // MARK: Property(s)
    
    private var diffableDataSource: DiffableDataSource?
    private var summaryHeaderView: SummaryHeaderView?
    
    private let presenter = TodoListPresenter()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        presenter.addDelegate(self)
        presenter.prepareToDisplay()
    }
    
    // MARK: Private Function(s)
    
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
            guard let todoItem = self.presenter.item(for: itemIdentifier) else {
                return
            }
            
            var content = cell.defaultContentConfiguration()
            content.text = todoItem.description
            cell.accessories = todoItem.isCompleted ? [.checkmark()] : []
            cell.contentConfiguration = content
        }
    }
    
    private func updateSnapShot(_ itemIdentifiers: [UUID]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapShot.appendSections([.todos])
        snapShot.appendItems(itemIdentifiers, toSection: .todos)
        diffableDataSource?.apply(snapShot)
    }
}

// MARK: UICollectionViewDelegate

extension TodoMarkingViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let todoIdentifier = diffableDataSource?.itemIdentifier(for: indexPath) {
            presenter.selectTodo(todoIdentifier)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: TooMarkingViewDelegate

extension TodoMarkingViewController: TodoMarkingViewDelegate {
    
    func displayTodoStatusMark(_ isCompleted: Bool, taskIdentifier: UUID) {
        if let cellIndex = diffableDataSource?.indexPath(for: taskIdentifier),
           let cell = collectionView.cellForItem(at: cellIndex) as? UICollectionViewListCell {
            cell.accessories = isCompleted ? [.checkmark()] : []
        }
    }
    
    func displayCompletedTodoCount(_ completedTodosCount: Int) {
        summaryHeaderView?.update(tasksCount: completedTodosCount)
    }
    
    func displayTodos(_ allTodoIdentifiers: [UUID]) {
        updateSnapShot(allTodoIdentifiers)
    }
    
    func displayTitle(_ titleString: String) {
        navigationItem.title = titleString
    }
}
