//
//  DataSerialization.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 28/11/2014.
//
//

import Foundation

protocol SerializationStrategy {
    
    func loadTopics()->[Topic]
    func loadCategories()->[Category]
    func loadQuestions()->[Question]
    func loadQuestionStats()->[QuestionStats]
}