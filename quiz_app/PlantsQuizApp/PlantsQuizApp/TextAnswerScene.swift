//
//  TextAnswerScene.swift
//  PlantsQuizApp
//
//  Created by Ciprian Lucaci on 04/12/14.
//
//

import Foundation
import SpriteKit

class TextAnswerScene: AnswerScene {
    
    override func didMoveToView(view: SKView) {
        if let roundInstance = round {
            let questionIndex = roundInstance.answeredQuestionCount
            question = roundInstance.questionsList[questionIndex]
        }
        
        addBackground()
        addHomeIcon()
        
        if isExam == false {
            let progressBarStartPadding = CGFloat(0.12 * self.size.width)
            addLeafProgressBar(progressBarStartPadding)
        }
        else {
            addTimerLabel()
        }
        addQuestionNumberSeed(0.12 * self.size.width)
        
        var questionBambooPadding = 0.76
        var answerButtonHeightFactor = 0.12
        if self.viewType == SceneType.Image2Text {
            questionBambooPadding = 0.50
            answerButtonHeightFactor = 0.08
            addQuestionImage(0.72)
        }
        
        addQuestionBamboo(questionBambooPadding)
        addAnswerButtons(answerButtonHeightFactor)
    }
        
    private func addAnswerButtons(buttonHeightFactor: Double){
        let buttonWidth = 0.9 * self.size.width
        let buttonHeight = CGFloat(buttonHeightFactor) * self.size.height
        let buttonSpaceSeparation = 0.07 * self.size.height
        let questionIndex = round!.answeredQuestionCount
        
        let answer1Button = SKSpriteNode(imageNamed: "OptionBar")
        let answer2Button = SKSpriteNode(imageNamed: "OptionBar")
        let answer3Button = SKSpriteNode(imageNamed: "OptionBar")
        let answer4Button = SKSpriteNode(imageNamed: "OptionBar")
        answerButtons.append(answer1Button)
        answerButtons.append(answer2Button)
        answerButtons.append(answer3Button)
        answerButtons.append(answer4Button)
        
        for index in 0...3 {
             let paddingFactor = CGFloat(0.5 + Float((index+3)%4))
             let spaceBetweenButtons = CGFloat(0.1 * buttonHeight)
             let answerButton = answerButtons[index]
             answerButton.position = CGPoint(x: self.size.width/2, y: paddingFactor * buttonHeight + CGFloat((index+3)%4) * spaceBetweenButtons + buttonSpaceSeparation)
             answerButton.size.height = buttonHeight
             answerButton.size.width = buttonWidth
             answerButton.zPosition = 1
             addChild(answerButton)
        }
        
        let answer1Label = SKLabelNode(fontNamed: "Chalkduster")
        let answer2Label = SKLabelNode(fontNamed: "Chalkduster")
        let answer3Label = SKLabelNode(fontNamed: "Chalkduster")
        let answer4Label = SKLabelNode(fontNamed: "Chalkduster")
        answerLabels.append(answer1Label)
        answerLabels.append(answer2Label)
        answerLabels.append(answer3Label)
        answerLabels.append(answer4Label)
   
        //TODO: check display for long answers!!!
        let randomIndex = Int(arc4random_uniform(100))
        answerLabels[(randomIndex)%4].text = question!.correctAnswer
        answerLabels[(randomIndex+1)%4].text = question!.wrongAnswer1
        answerLabels[(randomIndex+2)%4].text = question!.wrongAnswer2
        answerLabels[(randomIndex+3)%4].text = question!.wrongAnswer3
        
        for index in 0...3 {
            let paddingFactor = CGFloat(0.5 + Float((index+3)%4))
            let spaceBetweenButtons = CGFloat(0.1 * buttonHeight)
            let answerLabel = answerLabels[index]
            answerLabel.fontSize = 20
            answerLabel.zPosition = 1
            var answerLabelPosition = CGPoint(x: 0, y: CGFloat(buttonHeight/2))
            answerLabel.convertPoint(answerLabelPosition, toNode: answerButtons[index])
            answerButtons[index].addChild(answerLabel)
        }
        
    }
    
    
    
}
