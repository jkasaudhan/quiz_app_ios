//
//  ExamResultsScene.swift
//  PlantsQuizApp
//
//  Created by Ciprian Lucaci on 03/12/14.
//
//

import Foundation
import SpriteKit

class ExamResultsScene: SKScene {
    
    let screenBackground = SKSpriteNode(imageNamed: "CommonBackground")
    let bambooIcon = SKSpriteNode(imageNamed: "GreenBamboo")
    let homeIcon = SKSpriteNode(imageNamed: "HomeButton")
    var round : Round?
    var nodes : [SKSpriteNode] = [SKSpriteNode]()
    var parentView : GoHomeDelegate?
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        screenBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 15)
        screenBackground.size.height = self.size.height - 15
        screenBackground.zPosition = 0
        
        bambooIcon.position = CGPoint(x: self.size.width/2, y: self.size.height - 50)
        bambooIcon.size.height = 60
        bambooIcon.zPosition = 1
        
        homeIcon.position = CGPoint(x: 30, y: self.size.height - 50)
        homeIcon.zPosition = 1
        homeIcon.size.height = 45
        homeIcon.size.width = 45
        
        addChild(screenBackground)
        addChild(bambooIcon)
        addChild(homeIcon)
        
        displayResults()
    }
    
    private func displayResults(){
        //TODO: work in progress
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location);
            if(touchedNode == homeIcon) {
                //TODO:
                println("go home")
                parentView?.goHome()
            }
            
            
        }
    }
    
}