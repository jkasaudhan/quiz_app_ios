//
//  ExamStatsParser.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 29/11/2014.
//
//

import Foundation

class ExamStatsParser {
    
    class func parseJSON() -> [ExamStats] {
        var examStats = [ExamStats]()
        if let directory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
            let path = directory[0].stringByAppendingPathComponent( "examStats-" + GameConfiguration.sharedGameConfiguration.getLanguage() + ".json")
            //reading
            if let examStatsData = NSData(contentsOfFile: path) {
                examStats = ExamStatsParser.examStatsFromJSONData(examStatsData)
            }
        }
        return examStats
    }
    
    class func examStatsFromJSONData(data: NSData) -> [ExamStats] {
        var examStats = [ExamStats]()
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        
        var error: NSError?
        
        if let jsonArray: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        {
            //If there are no exams, return empty array
            if jsonArray.count == 0 {
                return []
            }
            // go through all dicts in the returned array of dicts
            for typeDict in jsonArray as [NSDictionary] {
                
                // TODO create Topic
                var examStat = ExamStats(examID: typeDict["examID"] as Int, topicID: typeDict["topicID"] as Int, numberOfCorrectAnswers: typeDict["numberOfCorrectAnswers"] as Int, examDate: dateFormatter.dateFromString(typeDict["examDate"] as String)!)
                
                examStats.append(examStat)
            }
        }
        
        if let err = error? {
            println("Error: " + err.localizedDescription)
            println("Desc: " + err.description)
        }
        
        return examStats
    }
    
    class func updateExamStats(examStats: [ExamStats]) {
        var jsonDict = [String:AnyObject]()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        
        // add exam stats
        var examStatsArray = [[String:AnyObject]]()
        for examStat in examStats {
            examStatsArray.append(["examID": examStat.examID,
                "topicID": examStat.topicID, "numberOfCorrectAnswers": examStat.numberOfCorrectAnswers,
                "examDate": dateFormatter.stringFromDate(examStat.examDate)])
        }
        
        var error:NSError?
        
        if let jsonData = NSJSONSerialization.dataWithJSONObject(examStatsArray, options: NSJSONWritingOptions.PrettyPrinted, error: &error) {
            // write it to documents directory
            let docDir = DataManager.sharedDataManager.getDocumentDirectory() + "/examStats-" + GameConfiguration.sharedGameConfiguration.getLanguage() + ".json"
            jsonData.writeToFile(docDir, atomically: true)
        }
        
        // if some error occured
        if let err = error? {
            println("Error: " + err.localizedDescription)
            println("Desc: " + err.description)
        }
    }
}