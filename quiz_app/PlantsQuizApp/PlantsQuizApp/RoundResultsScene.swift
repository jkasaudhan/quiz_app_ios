//
//  RoundResultsScene.swift
//  PlantsQuizApp
//
//  Created by Ciprian Lucaci on 03/12/14.
//
//

import SpriteKit
import UIKit

class RoundResultsScene: SKScene {
    let screenBackground = SKSpriteNode(imageNamed: "CommonBackground")
    let bambooIcon = SKSpriteNode(imageNamed: "GreenBamboo")
    let homeIcon = SKSpriteNode(imageNamed: "HomeButton")
    let nextRoundButton = SKSpriteNode(imageNamed: "Next")
    var nextResultButton = SKSpriteNode(imageNamed: "Next")
    var previousResultButton = SKSpriteNode(imageNamed: "Next")
    var imageQuestionBackground = SKSpriteNode(imageNamed: "QuestionImageBoard")
    var questionBambooIcon = SKSpriteNode(imageNamed: "GreenBamboo")
    var imageQuestionIcon = SKSpriteNode()
    var leafNodes : [SKSpriteNode] = [SKSpriteNode]()
    var answerButtons = [SKSpriteNode]()
    var answerLabels = [SKLabelNode]()
    var screenNameLabel = SKLabelNode(fontNamed: "Chalkduster")
    var questionLabel = SKLabelNode(fontNamed: "Chalkduster")
    var descriptionLabel = SKLabelNode(fontNamed: "Chalkduster")
    var questionNumberLabels = [SKLabelNode]()

    var parentView : GoHomeDelegate?
    var goCategorySelect : GoNextCategorySelectDelegate?

    var questionAddedFlag: Bool = false
    var rightFlag: Bool = true
    var leftFlag: Bool = false
    var touchedFlag: Int? = 0
    var maximumHorizontalDistance: Int?
    var round : Round?
    var rightDistance: CGFloat = CGFloat(375)
    var leftDistance: CGFloat = CGFloat(0)
    let imageSize: Int = 85
    var correctImageAnswerIndicator: SKShapeNode?
    var leafScrollViewLength: CGFloat?
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        self.rightDistance = self.size.width
        
        screenBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - self.size.height * 0.02)
        screenBackground.size.height = self.size.height - self.size.height * 0.02
        screenBackground.zPosition = 0
      
        bambooIcon.position = CGPoint(x: self.size.width/2, y: self.size.height - self.size.height * 0.07)
        bambooIcon.size.height = self.size.height * 0.09
        bambooIcon.zPosition = 1
        
        screenNameLabel.text = "Results"
        screenNameLabel.fontSize = 30
        screenNameLabel.zPosition = 1
        screenNameLabel.position = CGPoint(x: self.size.width/2, y: self.size.height - self.size.height * 0.09)
        screenNameLabel.fontColor = SKColor.yellowColor()
        
        descriptionLabel.text = "Pick a question to review"
        descriptionLabel.fontSize = 20
        descriptionLabel.zPosition = 1
        descriptionLabel.position = CGPoint(x: self.size.width/2, y: self.size.height - self.size.height * 0.157)
        descriptionLabel.fontColor = SKColor.yellowColor()
        
        homeIcon.position = CGPoint(x: self.size.width * 0.08, y: self.size.height - self.size.height * 0.07)
        homeIcon.zPosition = 1
        homeIcon.size.height = self.size.height * 0.06
        homeIcon.size.width = self.size.width * 0.12
        
        nextRoundButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.045)
        nextRoundButton.size.height = self.size.height * 0.066
        nextRoundButton.size.width = self.size.width * 0.205
        nextRoundButton.zPosition = 1
        
        previousResultButton.position = CGPoint(x: self.size.width * 0.05, y: self.size.height - self.size.height * 0.32)
        previousResultButton.zPosition = 1
        previousResultButton.size.height = self.size.height * 0.045
        previousResultButton.size.width = self.size.width * 0.08
        previousResultButton.xScale = -1
        
        nextResultButton.position = CGPoint(x: self.size.width - self.size.width * 0.05, y: self.size.height - self.size.height * 0.32)
        nextResultButton.zPosition = 1
        nextResultButton.size.height = self.size.height * 0.045
        nextResultButton.size.width = self.size.width * 0.08
        
        addChild(screenBackground)
        addChild(bambooIcon)
        addChild(screenNameLabel)
        addChild(descriptionLabel)
        addChild(nextResultButton)
        addChild(previousResultButton)
        addChild(homeIcon)
        addChild(nextRoundButton)
        
        let questionsArray = round?.questionsList
        leafScrollViewLength = CGFloat(85 * (questionsArray?.count)!)
        displayResults(questionsArray!)
    }
    
    // Detects the touch events on spritekit elements
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location);
            if touchedNode == homeIcon {
                println("go home")
                parentView?.goHome()
            }
            else if touchedNode == nextRoundButton {
                goCategorySelect?.goCategorySelectionScreen()
            }
            else if touchedNode == previousResultButton {
                if leftFlag == true && leftDistance > 0 {
                    rightFlag = true
                    leftDistance = leftDistance - CGFloat(imageSize)
                    rightDistance = rightDistance - CGFloat(imageSize)
                    touchedFlag = -1
                    runAction(SKAction.runBlock(moveLeaves))
                }
            }
            else if touchedNode == nextResultButton {
                if rightFlag == true && rightDistance < leafScrollViewLength {
                    leftFlag = true
                    touchedFlag = 1
                    leftDistance = leftDistance + CGFloat(imageSize)
                    rightDistance = rightDistance + CGFloat(imageSize)
                    runAction(SKAction.runBlock(moveLeaves))
                }
            }
            else {
                for index in 0..<leafNodes.count {
                    if touchedNode == leafNodes[index] {
                        var questionArray = round!.questionsList as Array
                        
                        println("Touched question: \(questionArray[index].questionText)")
                        if questionAddedFlag == false { // First time to review the questions
                            addQuestion(questionArray[index].questionText)
                            
                            if ( questionArray[index].viewType == 2 || questionArray[index].viewType == 3 ) {
                                addQuestionImage(questionArray[index])
                            }
                            questionAddedFlag = true
                        }
                        else if questionAddedFlag == true { // After first revision of the questions
                            questionBambooIcon.removeFromParent()
                            questionLabel.removeFromParent()
                            imageQuestionIcon.removeFromParent()
                            imageQuestionBackground.removeFromParent()
                            correctImageAnswerIndicator?.removeFromParent()
                            addQuestion(questionArray[index].questionText)
                            if ( questionArray[index].viewType == 2 || questionArray[index].viewType == 3 ) {
                                addQuestionImage(questionArray[index])
                            }
                        }
                        
                        // For the questions whose answer fields are text
                        if ( questionArray[index].viewType == 1 || questionArray[index].viewType == 3 ) {
                            if answerLabels.count != 0 {
                                for visualIndex in 0...3 {
                                    answerLabels[visualIndex].removeFromParent()
                                    answerButtons[visualIndex].removeFromParent()
                                }
                            }
                            addTextAnswerButtons(questionArray, questionIndex: index)
                        }
                        // For the questions whose answer fields are image
                        if ( questionArray[index].viewType == 2 || questionArray[index].viewType == 4) {
                            if answerLabels.count != 0 {
                                for visualIndex in 0...3 {
                                    answerLabels[visualIndex].removeFromParent()
                                    answerButtons[visualIndex].removeFromParent()
                                }
                            }
                            addImageAnswerButtons(questionArray[index])
                        }
                    }
                }
            }
        }
    }
    
    // Function to display the result of the questions by leaves and their numbers
    private func displayResults(questions: [Question]){
        for index in 0..<questions.count {
            var verticalPosition: CGFloat = 0
            
            var horizontalPadding = (index * imageSize) + 65
            verticalPosition = self.size.height * 0.27
            
            let question = questions[index]
            println("adding leaf \(index) H \(horizontalPadding) V \(verticalPosition)")
            
            var imageName = "CategoryLeafGreen"
            if !question.isCorrect {
                imageName = "RedLeaf"
            }
            
            let leaf = SKSpriteNode(imageNamed: imageName)
            leaf.position = CGPoint(x: CGFloat(horizontalPadding), y: (self.size.height/2 + verticalPosition))
            leaf.zPosition = 1
            leaf.size.height = CGFloat(imageSize)
            leaf.size.width = CGFloat(imageSize)
            
            if index == questions.count - 1 {
                maximumHorizontalDistance = horizontalPadding + imageSize
            }
            
            var questionNumberLabel = SKLabelNode(fontNamed: "Chalkduster")
            questionNumberLabel.text = "\(index + 1)"
            questionNumberLabel.zPosition = 1
            questionNumberLabel.fontSize = 15
            questionNumberLabel.position = CGPoint(x: CGFloat(horizontalPadding), y: (self.size.height/2 + verticalPosition/1.4))
            questionNumberLabel.fontColor = SKColor.blackColor()
            
            questionNumberLabels.append(questionNumberLabel)
            leafNodes.append(leaf)
            addChild(leaf)
            addChild(questionNumberLabel)
        }
    }
    
    // Function to dynamically create questions on result screen
    private func addQuestion(questionText: String) {
        questionBambooIcon.removeAllChildren()

        questionBambooIcon.position = CGPoint(x: self.size.width/2, y: self.size.height/2.12)
        questionBambooIcon.size.height = 0.12 * self.size.height
        questionBambooIcon.size.width = self.size.width
        questionBambooIcon.zPosition = 1
        addChild(questionBambooIcon)
        
        SpriteLayoutHelper.wrapTextOnParent(questionBambooIcon, text: questionText, fontColor: Colors.white.rawValue)
    }
    
    // Function to add question image if needed
    private func addQuestionImage(clickedQuestion: Question?){
        let heightPaddingFactor = CGFloat(0.60)
        imageQuestionBackground.removeAllChildren()
        
        imageQuestionBackground.position = CGPoint(x: self.size.width/2, y: heightPaddingFactor * self.size.height)
        imageQuestionBackground.size.height = 0.16 * self.size.height
        imageQuestionBackground.size.width = 0.38 * self.size.width
        imageQuestionBackground.zPosition = 1
        addChild(imageQuestionBackground)
        
        var imageName = clickedQuestion?.imagePath
        if imageName == "" || imageName == nil {
            imageName = "logo"
        }
        imageQuestionIcon = SKSpriteNode(imageNamed: imageName!)
        imageQuestionIcon.position = CGPoint(x: 0, y: 0)
        imageQuestionIcon.size.height = 0.6 * imageQuestionBackground.size.height
        imageQuestionIcon.size.width = 0.35 * imageQuestionBackground.size.width
        imageQuestionIcon.zPosition = 1
        imageQuestionBackground.addChild(imageQuestionIcon)
    }
    
    // Function to add image answer fields in result screen
    private func addImageAnswerButtons(clickedQuestion: Question?){
        var correctAnswerIndex: Int?
        let buttonWidth = 0.85 * self.size.width / 1.5
        let buttonHeight = CGFloat(0.24) * self.size.height / 1.5
        let buttonSpaceSeparation = 0.01 * self.size.height
        
        answerButtons.removeAll(keepCapacity: false)
        answerLabels.removeAll(keepCapacity: false)
        
        var answerPictures = [String]()
        answerPictures.append(clickedQuestion!.correctAnswer)
        answerPictures.append(clickedQuestion!.wrongAnswer1)
        answerPictures.append(clickedQuestion!.wrongAnswer2)
        answerPictures.append(clickedQuestion!.wrongAnswer3)
        
        let randomIndex = Int(arc4random_uniform(100))
        let answer1Button = SKSpriteNode(imageNamed: answerPictures[(randomIndex)%4])
        let answer2Button = SKSpriteNode(imageNamed: answerPictures[(randomIndex+1)%4])
        let answer3Button = SKSpriteNode(imageNamed: answerPictures[(randomIndex+2)%4])
        let answer4Button = SKSpriteNode(imageNamed: answerPictures[(randomIndex+3)%4])
        answerButtons.append(answer1Button)
        answerButtons.append(answer2Button)
        answerButtons.append(answer3Button)
        answerButtons.append(answer4Button)
        
        // Use them only to identify the correct answer. do not display them
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
        let upLeftPaddingFactor = CGFloat(0.8 + Float((2+3)%4))
        upLeftButton.position = CGPoint(x: 0.1 * self.size.width + buttonWidth/4, y: upLeftPaddingFactor * buttonHeight + CGFloat((2+3)%4) * spaceBetweenButtons + buttonSpaceSeparation)
        upLeftButton.size.height = buttonHeight
        upLeftButton.size.width = buttonWidth/2
        upLeftButton.zPosition = 1
        addChild(upLeftButton)
        
        //up-right picture
        let upRightButton = answerButtons[1]
        let upRightPaddingFactor = CGFloat(0.8 + Float((2+3)%4))
        upRightButton.position = CGPoint(x: 0.90 * self.size.width - buttonWidth/4, y: upRightPaddingFactor * buttonHeight + CGFloat((2+3)%4) * spaceBetweenButtons + buttonSpaceSeparation)
        upRightButton.size.height = buttonHeight
        upRightButton.size.width = buttonWidth/2
        upRightButton.zPosition = 1
        addChild(upRightButton)
        
        //down-left picture
        let downLeftButton = answerButtons[2]
        let downLeftPaddingFactor = CGFloat(0.8 + Float((1+3)%4))
        downLeftButton.position = CGPoint(x: 0.1 * self.size.width + buttonWidth/4, y: downLeftPaddingFactor * buttonHeight + CGFloat((1+3)%4) * spaceBetweenButtons + buttonSpaceSeparation)
        downLeftButton.size.height = buttonHeight
        downLeftButton.size.width = buttonWidth/2
        downLeftButton.zPosition = 1
        addChild(downLeftButton)
        
        //down-right picture
        let downRightButton = answerButtons[3]
        let downRightPaddingFactor = CGFloat(0.8 + Float((1+3)%4))
        downRightButton.position = CGPoint(x: 0.90 * self.size.width - buttonWidth/4, y: downRightPaddingFactor * buttonHeight + CGFloat((1+3)%4) * spaceBetweenButtons + buttonSpaceSeparation)
        downRightButton.size.height = buttonHeight
        downRightButton.size.width = buttonWidth/2
        downRightButton.zPosition = 1
        addChild(downRightButton)
        
        // Create a green rectangle around the correct answer
        correctImageAnswerIndicator = SKShapeNode(rectOfSize: CGSize(width: buttonWidth/2+5, height: buttonHeight+5))
        correctImageAnswerIndicator!.name = "bar"
        correctImageAnswerIndicator!.fillColor = SKColor.greenColor()
        
        // Picking the correct question answer image for green rectangle
        if randomIndex%4 == 0 {
            correctAnswerIndex = 0
            correctImageAnswerIndicator!.position = upLeftButton.position
        }
        else if (randomIndex+1)%4 == 0 {
            correctAnswerIndex = 1
            correctImageAnswerIndicator!.position = upRightButton.position
        }
        else if (randomIndex+2)%4 == 0 {
            correctAnswerIndex = 2
            correctImageAnswerIndicator!.position = downLeftButton.position
        }
        else if (randomIndex+3)%4 == 0 {
            correctAnswerIndex = 3
            correctImageAnswerIndicator!.position = downRightButton.position
        }
        
        self.addChild(correctImageAnswerIndicator!)
    }

    // Function to add answers of the questions dynamically by user input
    private func addTextAnswerButtons(questions: [Question],questionIndex: Int){
        
        answerButtons.removeAll(keepCapacity: false)
        answerLabels.removeAll(keepCapacity: false)
        
        let buttonWidth = 0.9 * self.size.width
        let buttonHeight = 0.08 * self.size.height
        let buttonSpaceSeparation = 0.02 * self.size.height
        
        let answer1Button = SKSpriteNode(imageNamed: "OptionBar")
        let answer2Button = SKSpriteNode(imageNamed: "OptionBar")
        let answer3Button = SKSpriteNode(imageNamed: "OptionBar")
        let answer4Button = SKSpriteNode(imageNamed: "OptionBar")
        answerButtons.append(answer1Button)
        answerButtons.append(answer2Button)
        answerButtons.append(answer3Button)
        answerButtons.append(answer4Button)
        
        for index in 0...3 {
            let padding = CGFloat(1.3 + Float((index+3)%4))
            let answerButton = answerButtons[index]
            answerButton.position = CGPoint(x: self.size.width/2, y: padding * buttonHeight + buttonSpaceSeparation)
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
        
        println("Number of elements in answerLabels: \(answerLabels.count)")
        
        answerLabels[(questionIndex)%4].text = questions[questionIndex].correctAnswer
        answerLabels[(questionIndex)%4].fontColor = SKColor.greenColor()
        answerLabels[(questionIndex+1)%4].text = questions[questionIndex].wrongAnswer1
        answerLabels[(questionIndex+2)%4].text = questions[questionIndex].wrongAnswer2
        answerLabels[(questionIndex+3)%4].text = questions[questionIndex].wrongAnswer3
        
        for index in 0...3 {
            let padding = CGFloat(1.3 + Float((index+3)%4))
            let answerLabel = answerLabels[index]
            answerLabel.fontSize = 17
            answerLabel.zPosition = 1
            answerLabel.position = CGPoint(x: self.size.width/2, y: padding * buttonHeight + buttonSpaceSeparation)
            addChild(answerLabel)
        }
    }
    
    // Function to move the leaves with user input
    func moveLeaves() {
        var verticalPosition = CGFloat(180.0)
        var yPos = (self.size.height/2 + verticalPosition)
        var leafMovement: CGFloat?
        let actualDuration = 0.4
        
        if touchedFlag == 1 {
            leafMovement = CGFloat(-85.0)
        }
        else if touchedFlag == -1 {
            leafMovement = CGFloat(85.0)
        }
        
        for index in 0...9 {
            // Create the actions
            var movePointX = leafNodes[index].position
            var numberYPosition = questionNumberLabels[index].position
            movePointX.x = movePointX.x + leafMovement!
            let leafActionMove = SKAction.moveTo(CGPoint(x: movePointX.x , y: yPos), duration: NSTimeInterval(actualDuration))
            let numberActionMove = SKAction.moveTo(CGPoint(x: movePointX.x , y: numberYPosition.y), duration: NSTimeInterval(actualDuration))
            leafNodes[index].runAction(SKAction.sequence([leafActionMove]))
            questionNumberLabels[index].runAction(SKAction.sequence([numberActionMove]))
        }
    }
}