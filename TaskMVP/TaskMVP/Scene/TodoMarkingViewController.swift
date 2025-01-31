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
    
    enum Section {
        case todos
    }
    
    // MARK: Property(s)
    
    private var diffableDataSource: DiffableDataSource?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: Override(s)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // MARK: Private Function(s)
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        configureDiffableDataSource()
        collectionView.dataSource = diffableDataSource
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureDiffableDataSource() {
        let cellRegistration = createCellRegistration()
        let dataSource = DiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        self.diffableDataSource = dataSource
    }
    
    private func createCellRegistration() -> TodoCellRegistration {
        return TodoCellRegistration {
            cell, indexPath , itemIdentifier in
            // TODO: Prepare Cell
        }
    }
}
