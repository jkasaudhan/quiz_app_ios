//
//  ViewController.swift
//  PlantsQuizApp
//
//  Created by Pranav Tomar on 08/11/14.
//
//

import UIKit

class ViewController: UIViewController {

    var topicsArray = [Topic]()
    var categoriesArray = [Category]()
    var questionsArray = [Question]()
    var categoryStatsArray = [CategoryStats]()
    var topicStatsArray = [TopicStats]()
    var questionStatsArray = [QuestionStats]()
    var examStatsArray = [ExamStats]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateApplicationData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Function to populate application data in start of app
    func populateApplicationData() {
        topicsArray = DataManager.sharedDataManager.topics!
        categoriesArray = DataManager.sharedDataManager.categories!
        questionsArray = DataManager.sharedDataManager.questions!
        
        for topic in topicsArray {
            var filteredCategories = categoriesArray.filter { $0.topicID == topic.topicID }
            topic.categories = filteredCategories
            
            var topicStat: TopicStats?
            if topicStatsArray.count != 0 {
                var filteredTopicStat = topicStatsArray.filter { $0.topicID == topic.topicID }
                if filteredTopicStat.count == 0 {
                    topicStat = TopicStats(topicID: topic.topicID, answeredCounts: 0, correctCounts: 0)
                } else {
                    var topicStatfiltererdArray = filteredTopicStat as Array
                    topicStat = topicStatfiltererdArray[0]
                }
            } else {
                topicStat = TopicStats(topicID: topic.topicID, answeredCounts: 0, correctCounts: 0)
            }
            topic.topicStat = topicStat
            
            var topicCategories = topic.categories
            
            for category in topicCategories! {
                var filteredQuestions = questionsArray.filter { $0.topicID == topic.topicID && $0.categoryID == category.categoryID }
                category.questions = filteredQuestions
                
                var categoryStat: CategoryStats?
                
                if categoryStatsArray.count != 0 {
                    var filteredCategoryStat = categoryStatsArray.filter { $0.categoryID == category.categoryID }
                    if filteredCategoryStat.count == 0 {
                        categoryStat = CategoryStats(categoryID: category.categoryID, answeredCounts: 0, correctCounts: 0)
                    } else {
                        var categoryStatfiltererdArray = filteredCategoryStat as Array
                        categoryStat = categoryStatfiltererdArray[0]
                    }
                } else {
                    categoryStat = CategoryStats(categoryID: category.categoryID, answeredCounts: 0, correctCounts: 0)
                }
                category.categoryStat = categoryStat
            }
        }
        
        categoryStatsArray = DataManager.sharedDataManager.categoryStats!
        examStatsArray = DataManager.sharedDataManager.examStats!
        topicStatsArray = DataManager.sharedDataManager.topicStats!
        questionStatsArray = DataManager.sharedDataManager.questionStats!
        
        println("Category stats are: \(categoryStatsArray.count)")
        println("question stats are: \(questionStatsArray.count)")
        println("topic stats are: \(topicStatsArray.count)")
        println("exam stats are: \(examStatsArray.count)")
        
        examStatsArray.append(ExamStats(examID: 2, topicID: 2, numberOfCorrectAnswers: 6, examDate: NSDate()))
        println("exam stats are again: \(examStatsArray.count)")
        
        DataManager.updateExamStats(examStatsArray)
    }
}

