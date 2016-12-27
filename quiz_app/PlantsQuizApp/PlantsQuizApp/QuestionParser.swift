//
//  QuestionParser.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 28/11/2014.
//
//

import Foundation

class QuestionParser {
    
    class func parseJSON() -> [Question] {
        var questionJSONURL = NSBundle.mainBundle().URLForResource("question-" + GameConfiguration.sharedGameConfiguration.getLanguage(), withExtension: "json")
        
        var questions = [Question]()
        
        if let questionsData = NSData(contentsOfURL: questionJSONURL!) {
            questions = QuestionParser.questionsFromJSONData(questionsData)
        }
        
        return questions
    }
    
    class func questionsFromJSONData(data: NSData) -> [Question] {
        var questions = [Question]()
        
        var error: NSError?
        
        if let jsonArray: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        {
            // go through all dicts in the returned array of dicts
            for typeDict in jsonArray as [NSDictionary] {
                // TODO create Question
                var question = Question(questionID: typeDict["questionID"] as Int, questionType: typeDict["questionType"] as Int, questionText: typeDict["questionText"] as String, correctAnswer: typeDict["correctAnswer"] as String, wrongAnswer1: typeDict["wrongAnswer1"] as String, wrongAnswer2: typeDict["wrongAnswer2"] as String, wrongAnswer3: typeDict["wrongAnswer3"] as String, viewType: typeDict["viewType"] as Int, categoryID: typeDict["categoryID"] as Int, topicID: typeDict["topicID"] as Int, imagePath: typeDict["imagePath"] as String, difficulty: typeDict["difficulty"] as Int)
                
                questions.append(question)
            }
        }
        
        if let err = error? {
            println("Error: " + err.localizedDescription)
            println("Desc: " + err.description)
        }
        
        return questions
    }
}