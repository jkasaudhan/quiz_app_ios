//
//  ImageAnswerScene.swift
//  PlantsQuizApp
//
//  Created by lucaci on 12/12/14.
//
//

import Foundation
import SpriteKit

class ImageAnswerScene: AnswerScene {

    override func didMoveToView(view: SKView) {
        if let roundInstance = round {
            let questionIndex = roundInstance.answeredQuestionCount
            question = roundInstance.questionsList[questionIndex]
        }
        
        addBackground()
        addHomeIcon()
        
        if isExam == false {
            let progressBarHeightPadding = CGFloat(0.12 * self.size.width)
            addLeafProgressBar(progressBarHeightPadding)
        }
        else {
            addTimerLabel()
        }
        addQuestionNumberSeed(0.12 * self.size.width)
        
        var questionBambooPadding = 0.76
        var answerButtonHeightFactor = 0.24
        if self.viewType == SceneType.Image2Image {
            questionBambooPadding = 0.50
            answerButtonHeightFactor = 0.16
            addQuestionImage(0.72)
        }
        
        addQuestionBamboo(questionBambooPadding)
        addAnswerButtons(answerButtonHeightFactor)
    }
    
    private func addAnswerButtons(heightSizeFactor: Double){
        let buttonWidth = 0.85 * self.size.width
        let buttonHeight = CGFloat(heightSizeFactor) * self.size.height
        let buttonSpaceSeparation = 0.07 * self.size.height
        let questionIndex = round!.answeredQuestionCount
        
        var answerPictures = [String]()
        answerPictures.append(question!.correctAnswer)
        answerPictures.append(question!.wrongAnswer1)
        answerPictures.append(question!.wrongAnswer2)
        answerPictures.append(question!.wrongAnswer3)
        
        let randomIndex = Int(arc4random_uniform(100))
        let answer1Button = SKSpriteNode(imageNamed: answerPictures[(randomIndex)%4])
        let answer2Button = SKSpriteNode(imageNamed: answerPictures[(randomIndex+1)%4])
        let answer3Button = SKSpriteNode(imageNamed: answerPictures[(randomIndex+2)%4])
        let answer4Button = SKSpriteNode(imageNamed: answerPictures[(randomIndex+3)%4])
        answerButtons.append(answer1Button)
        answerButtons.append(answer2Button)
        answerButtons.append(answer3Button)
        answerButtons.append(answer4Button)
        
        //use them only to identify the correct answer. do not display them
        let answer1Label = SKLabelNode(text: answerPictures[(randomIndex)%4])
        let answer2Label = SKLabelNode(text: answerPictures[(randomIndex+1)%4])
        let answer3Label = SKLabelNode(text: answerPictures[(randomIndex+2)%4])
        let answer4Label = SKLabelNode(text: answerPictures[(randomIndex+3)%4])
        answerLabels.append(answer1Label)
        answerLabels.append(answer2Label)
        answerLabels.append(answer3Label)
        answerLabels.append(answer4Label)
    
        let spaceBetweenButtons = CGFloat(0.1 * buttonHeight)
        //up-left picture
        let upLeftButton = answerButtons[0]
        let upLeftPaddingFactor = CGFloat(0.5 + Float((2+3)%4))
        upLeftButton.position = CGPoint(x: 0.05 * self.size.width + buttonWidth/4, y: upLeftPaddingFactor * buttonHeight + CGFloat((2+3)%4) * spaceBetweenButtons + buttonSpaceSeparation)
        upLeftButton.size.height = buttonHeight
        upLeftButton.size.width = buttonWidth/2
        upLeftButton.zPosition = 1
        addChild(upLeftButton)
        
        //up-right picture
        let upRightButton = answerButtons[1]
        let upRightPaddingFactor = CGFloat(0.5 + Float((2+3)%4))
        upRightButton.position = CGPoint(x: 0.95 * self.size.width - buttonWidth/4, y: upRightPaddingFactor * buttonHeight + CGFloat((2+3)%4) * spaceBetweenButtons + buttonSpaceSeparation)
        upRightButton.size.height = buttonHeight
        upRightButton.size.width = buttonWidth/2
        upRightButton.zPosition = 1
        addChild(upRightButton)
        
        //down-left picture
        let downLeftButton = answerButtons[2]
        let downLeftPaddingFactor = CGFloat(0.5 + Float((1+3)%4))
        downLeftButton.position = CGPoint(x: 0.05 * self.size.width + buttonWidth/4, y: downLeftPaddingFactor * buttonHeight + CGFloat((1+3)%4) * spaceBetweenButtons + buttonSpaceSeparation)
        downLeftButton.size.height = buttonHeight
        downLeftButton.size.width = buttonWidth/2
        downLeftButton.zPosition = 1
        addChild(downLeftButton)
        
        //down-right picture
        let downRightButton = answerButtons[3]
        let downRightPaddingFactor = CGFloat(0.5 + Float((1+3)%4))
        downRightButton.position = CGPoint(x: 0.95 * self.size.width - buttonWidth/4, y: downRightPaddingFactor * buttonHeight + CGFloat((1+3)%4) * spaceBetweenButtons + buttonSpaceSeparation)
        downRightButton.size.height = buttonHeight
        downRightButton.size.width = buttonWidth/2
        downRightButton.zPosition = 1
        addChild(downRightButton)
    }
    
}
