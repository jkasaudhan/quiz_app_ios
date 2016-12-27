//
//  CategoryStats.swift
//  PlantsQuizApp
//
//  Created by Efe Bozkir on 26/11/14.
//
//

import Foundation

class CategoryStats {
    let categoryID: Int
    var answeredCounts: Int
    var correctCounts: Int
    
    init(categoryID: Int, answeredCounts: Int, correctCounts: Int) {
        self.categoryID = categoryID
        self.answeredCounts = answeredCounts
        self.correctCounts = correctCounts
    }
}