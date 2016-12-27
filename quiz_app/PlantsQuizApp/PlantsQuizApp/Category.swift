//
//  Category.swift
//  PlantsQuizApp
//
//  Created by Efe Bozkir on 26/11/14.
//
//

import Foundation

class Category {
    let categoryID: Int
    let categoryName: String
    let topicID: Int
    var questions: [Question]?
    var categoryStat: CategoryStats?
    
    init(categoryID: Int, categoryName: String, topicID: Int) {
        self.categoryID = categoryID
        self.categoryName = categoryName
        self.topicID = topicID
    }
}