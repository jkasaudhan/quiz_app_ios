//
//  Topic.swift
//  PlantsQuizApp
//
//  Created by Efe Bozkir on 26/11/14.
//
//

import Foundation

class Topic {
    let topicID: Int
    let topicName: String
    var categories: [Category]?
    var topicStat: TopicStats?
    
    init(topicID: Int, topicName: String) {
        self.topicID = topicID
        self.topicName = topicName
    }
}