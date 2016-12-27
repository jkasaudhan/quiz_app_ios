//
//  QuestionStatsParser.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 29/11/2014.
//
//

import Foundation

class QuestionStatsParser {
    
    class func parseJSON() -> [QuestionStats] {
        
        var questionStats = [QuestionStats]()
        if let directory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
            let path = directory[0].stringByAppendingPathComponent( "questionStats-" + GameConfiguration.sharedGameConfiguration.getLanguage() + ".json")
            //reading
            if let questionStatsData = NSData(contentsOfFile: path) {
                questionStats = QuestionStatsParser.questionStatsFromJSONData(questionStatsData)
            }
        }
        return questionStats
    }
    
    class func questionStatsFromJSONData(data: NSData) -> [QuestionStats] {
        var questionStats = [QuestionStats]()
        
        var error: NSError?
        
        if let jsonArray: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        {
            if jsonArray.count == 0 {
                return []
            }
            // go through all dicts in the returned array of dicts
            for typeDict in jsonArray as [NSDictionary] {
                
                // TODO create Topic
                var questionStat = QuestionStats(questionID: typeDict["questionID"] as Int, answeredCounts: typeDict["answeredCounts"] as Int, correctCounts: typeDict["correctCounts"] as Int)
                
                questionStats.append(questionStat)
            }
        }
        
        if let err = error? {
            println("Error: " + err.localizedDescription)
            println("Desc: " + err.description)
        }
        
        return questionStats
    }
    
    class func updateQuestionStats(questionStats: [QuestionStats]) {
        var jsonDict = [String:AnyObject]()
        var questionStatsArray = [[String:AnyObject]]()
        
        for questionStat in questionStats {
            questionStatsArray.append(["questionID": questionStat.questionID,
                "answeredCounts": questionStat.answeredCounts, "correctCounts": questionStat.correctCounts])
        }
        
        var error:NSError?
        
        if let jsonData = NSJSONSerialization.dataWithJSONObject(questionStatsArray, options: NSJSONWritingOptions.PrettyPrinted, error: &error) {
            // write it to documents directory
            let docDir = DataManager.sharedDataManager.getDocumentDirectory() + "/questionStats-" + GameConfiguration.sharedGameConfiguration.getLanguage() + ".json"
            jsonData.writeToFile(docDir, atomically: true)
        }
        
        // if some error occured
        if let err = error? {
            println("Error: " + err.localizedDescription)
            println("Desc: " + err.description)
        }
    }
}