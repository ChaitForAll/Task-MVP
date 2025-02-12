//
//  SummaryHeaderView.swift
//  TaskMVP
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class SummaryHeaderView: UICollectionReusableView {
    
    // MARK: Property(s)
    
    private var tasksCount: Int = 0
    
    private let labelStackView: UIStackView = .init()
    private let completedLabel: UILabel = .init()
    private let resultLabel: UILabel = .init()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
    
    func update(text: String, statusStyle: TodoListDisplayStyle) {
        resultLabel.text = text
        switch statusStyle {
        case .incomplete: resultLabel.backgroundColor = .systemRed.withAlphaComponent(0.43)
        case .allCompleted: resultLabel.backgroundColor = .systemGreen.withAlphaComponent(0.43)
        }
    }
    
    // MARK: Private Function(s)
    
    private func configureLayout() {
        addSubview(labelStackView)
        labelStackView.alignment = .center
        labelStackView.spacing = 5
        labelStackView.addArrangedSubview(completedLabel)
        labelStackView.addArrangedSubview(resultLabel)
        labelStackView.isLayoutMarginsRelativeArrangement = true
        labelStackView.layoutMargins = .init(top: 5, left: 5, bottom: 5, right: 5)
        
        completedLabel.text = "Todo"
        completedLabel.font = .boldSystemFont(ofSize: 17)
        
        resultLabel.backgroundColor = .systemRed.withAlphaComponent(0.43)
        resultLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        resultLabel.textAlignment = .center
        
        resultLabel.layer.borderColor = UIColor.secondaryLabel.cgColor
        resultLabel.layer.masksToBounds = true
        resultLabel.layer.borderWidth = 0.33
        resultLabel.layer.cornerRadius = 8
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            resultLabel.heightAnchor.constraint(equalTo: labelStackView.layoutMarginsGuide.heightAnchor, multiplier: 0.9),
            resultLabel.widthAnchor.constraint(equalTo: resultLabel.heightAnchor),
        ])
    }
}
