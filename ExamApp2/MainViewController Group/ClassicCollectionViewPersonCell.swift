//
//  ClassicCollectionViewCell.swift
//  ExamApp2
//
//  Created by Vladislav McKay on 7/22/20.
//  Copyright © 2020 Vladislav McKay. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewPersonCell: UICollectionViewCell {
    var personLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
         return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(personLabel)
        
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemTeal
        self.layer.cornerRadius = 8
        personLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        personLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        personLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        personLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func person(person: Person) {
        if self.frame.width > 200 {
        self.personLabel.text = "\(person.firstName ?? "errorName"),    \(person.age ?? -123),  \(person.gender ?? "errorGender")"
        } else {
            self.personLabel.text = "\(person.firstName ?? "errorName"),\n\(person.age ?? -123),\n\(person.gender ?? "errorGender")"
        }
    }
    
}
