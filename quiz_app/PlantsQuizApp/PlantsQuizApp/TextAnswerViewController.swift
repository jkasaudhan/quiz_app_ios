//
//  SinglePlayerQuizViewController.swift
//  PlantsQuizApp
//
//  Created by Chetan Basuray on 26/11/14.
//
//


import UIKit
import SpriteKit
import AVFoundation

class TextAnswerViewController: UIViewController, GoHomeDelegate, GoNextDelegate {
    @IBOutlet var skView: SKView!
    weak var round: Round?
    var question: Question?
    var isExam: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayScene()
    }
    
    private func displayScene(){
        if let roundInstance = round {
            let questionIndex = roundInstance.answeredQuestionCount
            question = roundInstance.questionsList[questionIndex]
            println("selected question \(question?.questionID) \(question?.questionText)")
        
            if let viewType = SceneType(rawValue: question!.viewType) {
                var scene: AnswerScene? = nil
                switch viewType {
                case .Text2Text:
                    scene = TextAnswerScene(size: view.bounds.size)
                case .Image2Text:
                    scene = TextAnswerScene(size: view.bounds.size)
                case .Image2Image:
                    scene = ImageAnswerScene(size: view.bounds.size)
                case .Text2Image:
                    scene = ImageAnswerScene(size: view.bounds.size)
                }
                
                if let sceneInstance = scene {
                    sceneInstance.viewType = viewType
                    sceneInstance.goHomeDelegate = self
                    sceneInstance.goNextDelegate = self
                    sceneInstance.round = self.round
                    sceneInstance.isExam = self.isExam
                    self.skView.showsFPS = false
                    self.skView.showsNodeCount = false
                    sceneInstance.scaleMode = .ResizeFill
                    let reveal = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
                    self.skView.presentScene(sceneInstance, transition:reveal)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- SEGUE
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "textToRoundResultIdentifier" {
            println("textToRoundResultIdentifier \(round?.questionsList.count)")
            let destinationVC = segue.destinationViewController as SinglePlayerResultsViewController
            destinationVC.round = round
        }
    }
   
    func goHome(){
        
        
        
        AudioManagerHelper.sharedAudioManagerHelper.playBackgroundMusic("During the game 1")
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func goToNextScreen(){
       println("goToNextScreen")
       round!.answeredQuestionCount++
        if(round!.answeredQuestionCount < round!.questionsList.count){
            displayScene()
        }
        else {
            performSegueWithIdentifier("textToRoundResultIdentifier", sender: self)
        }
    }
}
