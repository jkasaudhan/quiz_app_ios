//
//  TopicStats.swift
//  PlantsQuizApp
//
//  Created by Efe Bozkir on 26/11/14.
//
//

import Foundation

class TopicStats {
    let topicID: Int
    var answeredCounts: Int
    var correctCounts: Int
    
    init(topicID: Int, answeredCounts: Int, correctCounts: Int) {
        self.topicID = topicID
        self.answeredCounts = answeredCounts
        self.correctCounts = correctCounts
    }
}