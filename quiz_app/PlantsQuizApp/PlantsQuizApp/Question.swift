//
//  Question.swift
//  PlantsQuizApp
//
//  Created by Efe Bozkir on 26/11/14.
//
//

import Foundation
import UIKit

class Question: Equatable  {
    let questionID: Int
    let questionType: Int
    let questionText: String
    let correctAnswer: String
    let wrongAnswer1: String
    let wrongAnswer2: String
    let wrongAnswer3: String
    let viewType: Int
    let categoryID: Int
    let topicID: Int
    let imagePath: String
    let difficulty: Int
    var questionStat: QuestionStats?
    var isCorrect: Bool    
    var selectedAnswer: String?

    init(questionID: Int, questionType: Int, questionText: String, correctAnswer: String,
        wrongAnswer1: String, wrongAnswer2: String, wrongAnswer3: String, viewType: Int,
        categoryID: Int, topicID: Int, imagePath: String, difficulty: Int) {
            
            self.questionID = questionID
            self.questionType = questionType
            self.questionText = questionText
            self.correctAnswer = correctAnswer
            self.wrongAnswer1 = wrongAnswer1
            self.wrongAnswer2 = wrongAnswer2
            self.wrongAnswer3 = wrongAnswer3
            self.viewType = viewType
            self.categoryID = categoryID
            self.topicID = topicID
            self.imagePath = imagePath
            self.difficulty = difficulty
            self.isCorrect = false
    }
}

func ==(lhs: Question, rhs: Question) -> Bool {
    return lhs.questionID == rhs.questionID
}