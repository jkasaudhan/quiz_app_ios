//
//  ExamStats.swift
//  PlantsQuizApp
//
//  Created by Efe Bozkir on 26/11/14.
//
//

import Foundation

class ExamStats {
    let examID: Int
    let topicID: Int
    var numberOfCorrectAnswers: Int
    var examDate: NSDate
    
    init(examID: Int, topicID: Int, numberOfCorrectAnswers: Int, examDate: NSDate) {
       self.examID = examID
       self.topicID = topicID
       self.numberOfCorrectAnswers = numberOfCorrectAnswers
       self.examDate = examDate
    }
}