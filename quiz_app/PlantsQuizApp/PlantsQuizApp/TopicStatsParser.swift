//
//  TopicStatsParser.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 29/11/2014.
//
//

import Foundation

class TopicStatsParser {
    
    class func parseJSON() -> [TopicStats] {
        var topicStats = [TopicStats]()
        if let directory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
            let path = directory[0].stringByAppendingPathComponent( "topicStats-" + GameConfiguration.sharedGameConfiguration.getLanguage() + ".json")
            //reading
            if let topicStatsData = NSData(contentsOfFile: path) {
                topicStats = TopicStatsParser.topicStatsFromJSONData(topicStatsData)
            }
        }
        return topicStats
    }
    
    class func topicStatsFromJSONData(data: NSData) -> [TopicStats] {
        var topicStats = [TopicStats]()
        
        var error: NSError?
        
        if let jsonArray: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        {
            if jsonArray.count == 0 {
                return []
            }
            // go through all dicts in the returned array of dicts
            for typeDict in jsonArray as [NSDictionary] {
                
                // TODO create Topic
                var topicStat = TopicStats(topicID: typeDict["topicID"] as Int, answeredCounts: typeDict["answeredCounts"] as Int, correctCounts: typeDict["correctCounts"] as Int)
                
                topicStats.append(topicStat)
            }
        }
        
        if let err = error? {
            println("Error: " + err.localizedDescription)
            println("Desc: " + err.description)
        }
        
        return topicStats
    }
    
    class func updateTopicStats(topicStats: [TopicStats]) {
        var jsonDict = [String:AnyObject]()
        var topicStatsArray = [[String:AnyObject]]()
        
        for topicStat in topicStats {
            topicStatsArray.append(["topicID": topicStat.topicID,
                "answeredCounts": topicStat.answeredCounts, "correctCounts": topicStat.correctCounts])
        }
        
        var error:NSError?
        
        if let jsonData = NSJSONSerialization.dataWithJSONObject(topicStatsArray, options: NSJSONWritingOptions.PrettyPrinted, error: &error) {
            // write it to documents directory
            let docDir = DataManager.sharedDataManager.getDocumentDirectory() + "/topicStats-" + GameConfiguration.sharedGameConfiguration.getLanguage() + ".json"
            jsonData.writeToFile(docDir, atomically: true)
        }
        
        // if some error occured
        if let err = error? {
            println("Error: " + err.localizedDescription)
            println("Desc: " + err.description)
        }
    }
}