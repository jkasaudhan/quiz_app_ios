//
//  Round.swift
//  PlantsQuizApp
//
//  Created by Efe Bozkir on 26/11/14.
//
//

import Foundation

class Round {
    let roundID: Int
    var questionsList: [Question]
    let topicID: Int
    let categoryiesID: [Int]
    let language: String
    var answeredQuestionCount: Int
    var examTimeLeft: Int
    
    init(roundID: Int, questionsList:[Question], topicID: Int, categoriesID: [Int], language: String) {
        self.roundID = roundID
        self.questionsList = questionsList
        self.topicID = topicID
        self.categoryiesID = categoriesID
        self.language = language
        self.answeredQuestionCount = 0
        self.examTimeLeft = GameConfiguration.examTimeSeconds()
    }
}