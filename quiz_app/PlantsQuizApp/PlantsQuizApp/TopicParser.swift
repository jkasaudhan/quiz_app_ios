//
//  TopicParser.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 28/11/2014.
//
//

import Foundation

class TopicParser {

    class func parseJSON() -> [Topic] {
        var topicsJSONURL = NSBundle.mainBundle().URLForResource("topic-" + GameConfiguration.sharedGameConfiguration.getLanguage(), withExtension: "json")
        
        var topics = [Topic]()

        if let topicsData = NSData(contentsOfURL: topicsJSONURL!) {
            topics = TopicParser.topicsFromJSONData(topicsData)
        }
        
        return topics
    }
    
    class func topicsFromJSONData(data: NSData) -> [Topic] {
        var topics = [Topic]()
        
        var error: NSError?
        
        if let jsonArray: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        {
            // go through all dicts in the returned array of dicts
            for typeDict in jsonArray as [NSDictionary] {

                // TODO create Topic
                var topic = Topic(topicID: typeDict["topicID"] as Int, topicName: typeDict["topicName"] as String)
                
                topics.append(topic)
            }
        }
        
        if let err = error? {
            println("Error: " + err.localizedDescription)
            println("Desc: " + err.description)
        }
        
        return topics
    }
}