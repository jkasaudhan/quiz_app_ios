//
//  AnswerScene.swift
//  PlantsQuizApp
//
//  Created by lucaci on 12/12/14.
//
//

import Foundation
import SpriteKit

enum SceneType: Int {
    case Text2Text = 1,
    Image2Image,
    Image2Text,
    Text2Image
}


class AnswerScene: SKScene {

    let screenBackground = SKSpriteNode(imageNamed: "QuestionBackground")
    let bambooIcon = SKSpriteNode(imageNamed: "GreenBamboo")
    let homeIcon = SKSpriteNode(imageNamed: "HomeButton")
    var questionLabel = SKLabelNode(fontNamed: "Chalkduster")
    var answerButtons = [SKSpriteNode]()
    var answerLabels = [SKLabelNode]()
    var leafProgressBar = [SKSpriteNode]()
    var leafNodes: [SKSpriteNode] = [SKSpriteNode]()
    var goHomeOk = SKSpriteNode(imageNamed: "HomeButton")
    var goHomeCancel = SKSpriteNode(imageNamed: "Next")
    var popupBackground = SKSpriteNode(imageNamed: "popup2")
    weak var round: Round?
    var goHomeDelegate: GoHomeDelegate?
    var goNextDelegate: GoNextDelegate?
    var statusBarHeight: CGFloat = 0
    weak var question: Question?
    var selectedAnswer: Bool = false
    var goHomePopupSelected: Bool = false
    var viewType: SceneType?
    var isExam: Bool?
    //MARK: timer elements
    var timeOfLastUpdate: CFTimeInterval = 0
    let timerMinutesLabel = SKLabelNode(text: "MIN")
    let timerSecondsLabel = SKLabelNode(text: "SEC")
    var timerLeft = -1
    
    func addBackground(){
        backgroundColor = SKColor.whiteColor()
        self.statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        screenBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - statusBarHeight)
        screenBackground.size.height = self.size.height - statusBarHeight
        screenBackground.zPosition = 0
        addChild(screenBackground)        
    }
    
    func addHomeIcon(){
        let homeIconSize = 0.1 * self.size.width
        homeIcon.position = CGPoint(x: 0.08 * self.size.width,  y: self.size.height - statusBarHeight - homeIconSize)
        homeIcon.zPosition = 1
        homeIcon.size.height = homeIconSize
        homeIcon.size.width = homeIconSize
        addChild(homeIcon)
    }
    
    func addQuestionBamboo(heightSizeFactor: Double){
        let heightPaddingFactor = CGFloat(heightSizeFactor)
        bambooIcon.position = CGPoint(x: self.size.width/2, y: heightPaddingFactor * self.size.height)
        bambooIcon.size.height = 0.14 * self.size.height
        bambooIcon.size.width = self.size.width
        bambooIcon.zPosition = 1
        addChild(bambooIcon)
        
        SpriteLayoutHelper.wrapTextOnParent(bambooIcon, text: question!.questionText, fontColor: Colors.white.rawValue)
    }
    
    func addQuestionImage(heightSizeFactor: Float){
        let heightPaddingFactor = CGFloat(heightSizeFactor)
        
        let imageQuestionBackground = SKSpriteNode(imageNamed: "QuestionImageBoard")
        imageQuestionBackground.position = CGPoint(x: self.size.width/2, y: heightPaddingFactor * self.size.height)
        imageQuestionBackground.size.height = 0.35 * self.size.height
        imageQuestionBackground.size.width = 0.95 * self.size.width
        imageQuestionBackground.zPosition = 1
        addChild(imageQuestionBackground)
        
        var imageName = question?.imagePath
        if imageName == "" || imageName == nil {
            imageName = "logo"
        }
        let imageQuestionIcon = SKSpriteNode(imageNamed: imageName!)
        imageQuestionIcon.position = CGPoint(x: 0, y: 0)
        imageQuestionIcon.size.height = 0.6 * imageQuestionBackground.size.height
        imageQuestionIcon.size.width = 0.35 * imageQuestionBackground.size.width
        imageQuestionIcon.zPosition = 1
        imageQuestionBackground.addChild(imageQuestionIcon)
    }
    
    func addTimerLabel(){
        timerLeft = round!.examTimeLeft
        let clockSize = 0.05 * self.size.width
        let clockIcon = SKSpriteNode(imageNamed: "alarm")
        clockIcon.zPosition = 1
        clockIcon.size.width = clockSize
        clockIcon.size.height = clockSize
        clockIcon.position = CGPoint(x: self.size.width/2, y: self.size.height - statusBarHeight - homeIcon.size.height)
        
        let fontSize = Int(20)
        timerMinutesLabel.fontName = "Chalkduster"
        timerMinutesLabel.zPosition = 2
        timerMinutesLabel.fontSize = CGFloat(fontSize)
        timerMinutesLabel.position = CGPoint(x: self.size.width/2 - clockSize, y: self.size.height - statusBarHeight - 1.2 * homeIcon.size.height)
        addChild(timerMinutesLabel)
        
        timerSecondsLabel.fontName = "Chalkduster"
        timerSecondsLabel.zPosition = 2
        timerSecondsLabel.fontSize = CGFloat(fontSize)
        timerSecondsLabel.position = CGPoint(x: self.size.width/2 + 1.4 * clockSize, y: self.size.height - statusBarHeight - 1.2 * homeIcon.size.height)
        addChild(timerSecondsLabel)
        
        addChild(clockIcon)
    }
    
    override func update(currentTime: CFTimeInterval) {
        let currentTimeAbsolute = CFAbsoluteTimeGetCurrent()
        var delta: CFTimeInterval = currentTime - timeOfLastUpdate
        
        if delta >= 1.0 {
            timeOfLastUpdate = currentTime
            
            updateExamTimer()
        }
    }
    
    private func updateExamTimer(){
        let minutes = Int(timerLeft / 60)
        let seconds = Int(timerLeft % 60)
        timerLeft = timerLeft - 1
        
        if timerLeft < 0 {
            //TODO: scenes are not killed properly
        }
        else if timerLeft == 0 {
            println("FINISHED EXAM")
            examFinished()
        }
        else {
            var minutesText = "\(minutes)"
            var secondsText = "\(seconds)"
            if (seconds < 10) {
                secondsText = "0\(seconds)"
            }
            if let roundInstance = round {
               roundInstance.examTimeLeft = timerLeft
            }
            
            self.timerMinutesLabel.text = minutesText
            self.timerSecondsLabel.text = secondsText
            println("Time left: \(minutes):\(seconds)")
        }
    }
    
    private func examFinished(){
        round!.answeredQuestionCount = round!.questionsList.count
        animationEnded()
    }
    
    func addLeafProgressBar(startPosition: CGFloat){
        let progressBarWidth = self.size.width - 1.5 * startPosition
        let leafSize = progressBarWidth / CGFloat(GameConfiguration.roundSize())
        let questionIndex = round!.answeredQuestionCount+1
        //start from 1 and display all except the current one
        for index in 1...questionIndex {
            var leafType = "ProgressBarRedLeaf"
            if round!.questionsList[index - 1].isCorrect == true {
                leafType = "TopBarSingleLeafSet"
            }
            if index == questionIndex {
                leafType = "YellowLeaf"
            }
            let leafIcon = SKSpriteNode(imageNamed: leafType)
            leafIcon.zPosition = 1
            leafIcon.size.width = leafSize
            leafIcon.size.height = 1.5 * leafSize
            leafIcon.position = CGPoint(x: startPosition + (CGFloat(index) * leafSize * 0.8), y: self.size.height - statusBarHeight - 1.2 * leafSize)
            
            addChild(leafIcon)
            leafNodes.append(leafIcon)
        }
       
    }
    
    func addQuestionNumberSeed(endPositionSize: CGFloat){
        let questionIndex = round!.answeredQuestionCount+1
        let questionNumberSize = (0.9 * endPositionSize)
        let questionNumberIcon = SKSpriteNode(imageNamed: "Topic")
        questionNumberIcon.zPosition = 1
        questionNumberIcon.size.width = 1.35 * questionNumberSize
        questionNumberIcon.size.height = 1 * questionNumberSize
        questionNumberIcon.position = CGPoint(x: 0.9 * self.size.width, y: self.size.height - statusBarHeight - questionNumberSize)
       
        let fontSize = Int(20)
        let questionNumberLabel = SKLabelNode(fontNamed: "Chalkduster")
        questionNumberLabel.zPosition = 1
        questionNumberLabel.text = "\(questionIndex)"
        questionNumberLabel.fontSize = CGFloat(fontSize)
        questionNumberLabel.position = CGPoint(x: 0 - questionNumberIcon.size.width/6, y: 0 - questionNumberIcon.size.height/5)
        questionNumberIcon.addChild(questionNumberLabel)
        
        let questionTotalNumberLabel = SKLabelNode(fontNamed: "Chalkduster")
        questionTotalNumberLabel.zPosition = 1
        questionTotalNumberLabel.text = "\(round!.questionsList.count)"
        questionTotalNumberLabel.fontSize = CGFloat(10)
        questionTotalNumberLabel.position = CGPoint(x: 0.2 * questionNumberIcon.size.width, y: 0 - questionNumberIcon.size.height/3)
        questionNumberIcon.addChild(questionTotalNumberLabel)
        
        addChild(questionNumberIcon)
    }
    
    func animateCorrectAnswer(node: SKNode){
        
        if self.isExam == true {
            animationEnded()
        }
        else {
            node.zPosition = 15
            let liftUp = SKAction.scaleTo(1.5, duration: 0.5)
            let dropDown = SKAction.scaleTo(1.0, duration: 0.5)
            let sequence = SKAction.sequence([liftUp,dropDown])
            node.runAction(sequence, completion: animationEnded)
        }
    }
    
    func animateWrongAnswer(node: SKNode){
        if self.isExam == true {
            animationEnded()
        }
        else {
            let rotationRight = SKAction.rotateByAngle(0.15, duration: 0.07)
            let rotationLeft = SKAction.rotateByAngle(-0.15, duration: 0.07)
            let rotationStop = SKAction.rotateByAngle(0, duration: 0.5)
            let cycle = SKAction.sequence([rotationRight, rotationLeft, rotationLeft, rotationRight])
            let sequence = SKAction.sequence([cycle,cycle,rotationStop])
            node.runAction(sequence, completion: animationEnded)
        }
    }
    
    func addGoHomeWarning(){
        popupBackground.zPosition = 2
        popupBackground.size.width = 0.9 * self.size.width
        popupBackground.size.height = 0.4 * self.size.height
        popupBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        let fontSize = Int(popupBackground.size.width / 20 + 1)
        
        let warningLabel = SKLabelNode()
        warningLabel.text = "By exiting the statistics are not saved!"
        warningLabel.zPosition = 2
        warningLabel.position = CGPoint(x: 0, y: 0.1 * popupBackground.size.height)
        FontHelper.sharedFontHelper.changeSKLabelFont(warningLabel, fontSize: fontSize, fontColor: Colors.red.rawValue)
        
        let questionWarningLabel = SKLabelNode()
        questionWarningLabel.text = "Go home or continue playing?"
        questionWarningLabel.zPosition = 2
        questionWarningLabel.position = CGPoint(x: 0, y: 0)
        FontHelper.sharedFontHelper.changeSKLabelFont(questionWarningLabel, fontSize: fontSize, fontColor: Colors.red.rawValue)
        
        goHomeOk.zPosition = 2
        goHomeOk.size.width = 0.1 * popupBackground.size.width
        goHomeOk.size.height = 0.1 * popupBackground.size.width
        goHomeOk.position = CGPoint(x: 0 - popupBackground.size.width/4, y: 0-0.1*popupBackground.size.height)
        
        goHomeCancel.zPosition = 2
        goHomeCancel.size.width = 0.2 * popupBackground.size.width
        goHomeCancel.size.height = 0.2 * popupBackground.size.height
        goHomeCancel.position = CGPoint(x: popupBackground.size.width/4, y: 0-0.1*popupBackground.size.height)
        
        popupBackground.addChild(goHomeOk)
        popupBackground.addChild(goHomeCancel)
        popupBackground.addChild(warningLabel)
        popupBackground.addChild(questionWarningLabel)
        
        goHomePopupSelected = true
        addChild(popupBackground)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location);
            if(touchedNode == homeIcon) {
                if goHomePopupSelected == false {
                    addGoHomeWarning()
                }
            }
            else if (touchedNode == goHomeOk){
                println("go home")
                goHomePopupSelected = false
                goHomeDelegate?.goHome()
            }
            else if (touchedNode == goHomeCancel){
                goHomePopupSelected = false
                popupBackground.removeAllChildren()
                popupBackground.removeFromParent()
            }
            else {
                if selectedAnswer || goHomePopupSelected {
                    continue
                }
                for var index = 0; index < answerButtons.count; ++index {
                    if (touchedNode == answerButtons[index] || touchedNode == answerLabels[index]){
                        let userAnswer = answerLabels[index].text
                        questionAnswered(userAnswer)
                        if question!.isCorrect {
                            if self.isExam != true {
                                answerLabels[index].fontColor = FontHelper.sharedFontHelper.UIColorFromRGB(UInt(Colors.lightGreen.rawValue))
                            }
                            animateCorrectAnswer(answerButtons[index])
                        }
                        else{
                            if self.isExam != true {
                                answerLabels[index].fontColor = FontHelper.sharedFontHelper.UIColorFromRGB(UInt(Colors.red.rawValue))
                            }
                            animateWrongAnswer(answerButtons[index])
                        }
                        break
                    }
                }
            }
        }
    }
    
    
    func questionAnswered(userAnswer: String){
        self.selectedAnswer = true
        question?.selectedAnswer = userAnswer
        if userAnswer == question?.correctAnswer {
            question?.isCorrect = true
            println("correct \(userAnswer)")
            if self.isExam != true {
                AudioManagerHelper.sharedAudioManagerHelper.playMusic("Correct Answer")
            }
        }
        else{
            question?.isCorrect = false
            println("incorrect \(userAnswer)")
            if self.isExam != true {
                AudioManagerHelper.sharedAudioManagerHelper.playMusic("Wrong Answer")
            }
        }
    }
    
    func animationEnded() {
        goNextDelegate?.goToNextScreen()
    }
}