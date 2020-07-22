//
//  FilterManager.swift
//  ExamApp2
//
//  Created by Vladislav McKay on 7/22/20.
//  Copyright © 2020 Vladislav McKay. All rights reserved.
//

import Foundation

enum FilterAgeValuesType {
    case descent
    case ascent
}

enum FilterGenderValuesType {
    case onlyMales
    case onlyFemales
    case allGenders
}

class FilterManager {
    
    func filterAgeValues(fromThese these: [Person], with: FilterAgeValuesType) -> [Person] {
        
        switch with {
        case .descent: return these.sorted(by: {$0.age! > $1.age!})
        case .ascent: return these.sorted(by: {$0.age! < $1.age!})
        }
    }
    
    func filterGender(fromThese these: [Person], with: FilterGenderValuesType) -> [Person] {
        
        switch with {
        case .onlyMales: return these.filter { $0.gender == "Male" }
        case .onlyFemales: return these.filter { $0.gender == "Female" }
        case .allGenders: return these.filter { $0.gender != "Alien" }
        }
    }
    
    
    
}


