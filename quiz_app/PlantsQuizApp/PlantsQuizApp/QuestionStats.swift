//
//  QuestionStat.swift
//  PlantsQuizApp
//
//  Created by Efe Bozkir on 26/11/14.
//
//

import Foundation

class QuestionStats {
    let questionID: Int
    var answeredCounts: Int
    var correctCounts: Int
    
    init(questionID: Int, answeredCounts: Int, correctCounts: Int) {
        self.questionID = questionID
        self.answeredCounts = answeredCounts
        self.correctCounts = correctCounts
    }
}