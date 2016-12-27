//
//  DataManager.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 28/11/2014.
//
//

import Foundation

private let _dataManagerInstance = DataManager()

class DataManager
{
    private let serializationHelper: SerializationStrategy = JSONSerializationHelper()
    
    var topics: [Topic]?
    var categories: [Category]?
    var questions: [Question]?
    var questionStats: [QuestionStats]?
    var topicStats: [TopicStats]?
    var categoryStats: [CategoryStats]?
    var examStats: [ExamStats]?
    
    class var sharedDataManager: DataManager {
        return _dataManagerInstance
    }
    
    private init() {
        self.topics = JSONSerializationHelper().loadTopics()
        self.categories = JSONSerializationHelper().loadCategories()
        self.questions = JSONSerializationHelper().loadQuestions()
        self.questionStats = JSONSerializationHelper().loadQuestionStats()
        self.topicStats = JSONSerializationHelper().loadTopicStats()
        self.categoryStats = JSONSerializationHelper().loadCategoryStats()
        self.examStats = JSONSerializationHelper().loadExamStats()
    }
    
    class func updateExamStats(examStats: [ExamStats]) {
        JSONSerializationHelper().updateExamStats(examStats)
    }
    
    func getDocumentDirectory() -> String {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
        return urls[urls.count - 1].path!
    }
}