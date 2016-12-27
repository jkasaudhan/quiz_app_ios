//
//  CategoryStatsParser.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 29/11/2014.
//
//

import Foundation

class CategoryStatsParser {
    
    class func parseJSON() -> [CategoryStats] {
        var categoryStats = [CategoryStats]()
        if let directory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
            let path = directory[0].stringByAppendingPathComponent( "categoryStats-" + GameConfiguration.sharedGameConfiguration.getLanguage() + ".json")
            //reading
            if let categoryStatsData = NSData(contentsOfFile: path) {
                categoryStats = CategoryStatsParser.categoryStatsFromJSONData(categoryStatsData)
            }
        }
        return categoryStats
    }
    
    class func categoryStatsFromJSONData(data: NSData) -> [CategoryStats] {
        var categoryStats = [CategoryStats]()
        
        var error: NSError?
        
        if let jsonArray: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        {
            if jsonArray.count == 0 {
                return []
            }
            // go through all dicts in the returned array of dicts
            for typeDict in jsonArray as [NSDictionary] {
                
                // TODO create Topic
                var categoryStat = CategoryStats(categoryID: typeDict["categoryID"] as Int, answeredCounts: typeDict["categoryID"] as Int, correctCounts: typeDict["correctCounts"] as Int)
                
                categoryStats.append(categoryStat)
            }
        }
        
        if let err = error? {
            println("Error: " + err.localizedDescription)
            println("Desc: " + err.description)
        }
        
        return categoryStats
    }
    
    class func updateCategoryStats(categoryStats: [CategoryStats]) {
        var jsonDict = [String:AnyObject]()
        var categoryStatsArray = [[String:AnyObject]]()
        
        for categoryStat in categoryStats {
            categoryStatsArray.append(["categoryID": categoryStat.categoryID,
                "answeredCounts": categoryStat.answeredCounts, "correctCounts": categoryStat.correctCounts])
        }
        
        var error:NSError?
        
        if let jsonData = NSJSONSerialization.dataWithJSONObject(categoryStatsArray, options: NSJSONWritingOptions.PrettyPrinted, error: &error) {
            // write it to documents directory
            let docDir = DataManager.sharedDataManager.getDocumentDirectory() + "/categoryStats-" + GameConfiguration.sharedGameConfiguration.getLanguage() + ".json"
            jsonData.writeToFile(docDir, atomically: true)
        }
        
        // if some error occured
        if let err = error? {
            println("Error: " + err.localizedDescription)
            println("Desc: " + err.description)
        }
    }
}