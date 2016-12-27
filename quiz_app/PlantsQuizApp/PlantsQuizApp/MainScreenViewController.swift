//
//  MainScreenViewController.swift
//  PlantsQuizApp
//
//  Created by Chetan Basuray on 26/11/14.
//
//

import UIKit
import AVFoundation

class MainScreenViewController: UIViewController {
    
    var topicsArray = [Topic]()
    var categoriesArray = [Category]()
    var questionsArray = [Question]()
    var categoryStatsArray = [CategoryStats]()
    var topicStatsArray = [TopicStats]()
    var questionStatsArray = [QuestionStats]()
    var examStatsArray = [ExamStats]()
    var recognition: Bool?
    var usage: Bool?
    var exam: Bool?
    var UIbuttonsArray = []

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var recognizeButton: UIButton!
    @IBOutlet weak var usageButton: UIButton!
    @IBOutlet weak var examButton: UIButton!
    @IBOutlet weak var multiplayerButton: UIButton!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var language = NSLocale.preferredLanguages()[0] as String
        GameConfiguration.sharedGameConfiguration.setLanguge(language)
        
        UIbuttonsArray = [recognizeButton, usageButton, examButton, multiplayerButton, statisticsButton]
        
        AudioManagerHelper.sharedAudioManagerHelper.playBackgroundMusic("During the game 1")
        changeLabelsColorAndFontSizes()
        self.populateApplicationData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var singlePlayerFlag = 0
        
        if segue.identifier == "recognition" {
            self.recognition = true
            self.usage = false
            self.exam = false
            singlePlayerFlag = 1
        
        }
        else if segue.identifier == "usage" {
            self.usage = true
            self.recognition = false
            self.exam = false
            singlePlayerFlag = 1
        }
        else if segue.identifier == "exam" {
            self.exam = true
            self.recognition = false
            self.usage = false
            singlePlayerFlag = 1
        }
        
        if singlePlayerFlag == 1 {
            let destinationVC = segue.destinationViewController as CategorySelectionViewController
            destinationVC.questionsArray = self.questionsArray
            destinationVC.recognition = self.recognition
            destinationVC.usage = self.usage
            destinationVC.exam = self.exam
            destinationVC.topicArray = self.topicsArray
            destinationVC.questionStatsArray = self.questionStatsArray
        }
    }
    
    func changeLabelsColorAndFontSizes() {
        for uiButton in UIbuttonsArray {
            FontHelper.sharedFontHelper.changeButtonFont(uiButton as UIButton, fontSize: 34, fontColor: Colors.green.rawValue)
        }
        
        //For app name
        FontHelper.sharedFontHelper.changeLabelFont(appNameLabel, fontSize: 48, fontColor: Colors.yellow.rawValue)
    }

    // Function to populate application data in start of app
    func populateApplicationData() {
        topicsArray = DataManager.sharedDataManager.topics!
        categoriesArray = DataManager.sharedDataManager.categories!
        questionsArray = DataManager.sharedDataManager.questions!
        
        println("topic are: \(topicsArray.count)")
        println("Category are: \(categoriesArray.count)")
        println("question are: \(questionsArray.count)")
        
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
