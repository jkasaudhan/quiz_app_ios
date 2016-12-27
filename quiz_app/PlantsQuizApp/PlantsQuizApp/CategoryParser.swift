//
//  CategoryParser.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 28/11/2014.
//
//

import Foundation

class CategoryParser {
    
    class func parseJSON() -> [Category] {
        var categoryJSONURL = NSBundle.mainBundle().URLForResource("category-" + GameConfiguration.sharedGameConfiguration.getLanguage(), withExtension: "json")
        
        var categories = [Category]()
        
        if let categoriesData = NSData(contentsOfURL: categoryJSONURL!) {
            categories = CategoryParser.categoriesFromJSONData(categoriesData)
        }
        
        return categories
    }
    
    class func categoriesFromJSONData(data: NSData) -> [Category] {
        var categories = [Category]()
        
        var error: NSError?
        
        if let jsonArray: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        {
            // go through all dicts in the returned array of dicts
            for typeDict in jsonArray as [NSDictionary] {
                
                // TODO create Category
                var category = Category(categoryID: typeDict["categoryID"] as Int, categoryName: typeDict["categoryName"] as String, topicID: typeDict["topicID"] as Int)
                
                categories.append(category)
            }
        }
        
        if let err = error? {
            println("Error: " + err.localizedDescription)
            println("Desc: " + err.description)
        }
        
        return categories
    }
}