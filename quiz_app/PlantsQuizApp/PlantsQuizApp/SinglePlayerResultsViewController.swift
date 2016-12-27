//
//  SinglePlayerResultsViewController.swift
//  PlantsQuizApp
//
//  Created by Chetan Basuray on 26/11/14.
//
//


import UIKit
import SpriteKit

class SinglePlayerResultsViewController: UIViewController, GoHomeDelegate, GoNextCategorySelectDelegate {
    
    @IBOutlet var skView: SKView!
    var round: Round?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundResultScene()
    }
    
    private func roundResultScene(){
        let scene = RoundResultsScene(size: view.bounds.size)
        scene.parentView = self
        scene.goCategorySelect = self
        scene.round = self.round
        self.skView.showsFPS = false
        self.skView.showsNodeCount = false
        scene.scaleMode = .ResizeFill
        self.skView.presentScene(scene)
    }
    
    private func examResultScene(){
        let scene = ExamResultsScene(size: view.bounds.size)
        scene.parentView = self
        //self.skView.showsFPS = true
        //self.skView.showsNodeCount = true
        scene.scaleMode = .ResizeFill
        self.skView.presentScene(scene)
    }
    
    func goHome(){
        AudioManagerHelper.sharedAudioManagerHelper.playBackgroundMusic("During the game 1")
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func goCategorySelectionScreen() {
        //AudioManagerHelper.sharedAudioManagerHelper.playBackgroundMusic("During the game 1")
        //navigationController?.popToViewController(CategorySelectionViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}