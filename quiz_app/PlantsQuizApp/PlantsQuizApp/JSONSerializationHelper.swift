//
//  JSONSerializationHelper.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 28/11/2014.
//
//

import Foundation

class JSONSerializationHelper : SerializationStrategy {
    
    func loadTopics() -> [Topic] {
        var topics = TopicParser.parseJSON()
        return topics
    }
    
    func loadCategories() -> [Category] {
        var categories = CategoryParser.parseJSON()
        return categories
    }
    
    func loadQuestions() -> [Question] {
        var questions = QuestionParser.parseJSON()
        return questions
    }
    
    func loadQuestionStats() -> [QuestionStats] {
        var questionStats = QuestionStatsParser.parseJSON()
        return questionStats
    }
    
    func loadTopicStats() -> [TopicStats] {
        var topicStats = TopicStatsParser.parseJSON()
        return topicStats
    }
    
    func loadCategoryStats() -> [CategoryStats] {
        var categoryStats = CategoryStatsParser.parseJSON()
        return categoryStats
    }
    
    func loadExamStats() -> [ExamStats] {
        var ExamStats = ExamStatsParser.parseJSON()
        return ExamStats
    }
    
    func updateExamStats(examStatsArray: [ExamStats]) {
        ExamStatsParser.updateExamStats(examStatsArray)
    }
}