//
//  HelpViewController.swift
//  PlantsQuizApp
//
//  Created by Chetan Basuray on 26/11/14.
//
//


import UIKit

class ImageAnswerViewController: UIViewController {
    
    @IBOutlet weak var progressBarSingleLeafSet: UIImageView!
    @IBOutlet weak var questionText: UILabel!
    
    weak var round: Round?
    var question: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    
    @IBAction func homeButtonClicked(sender: UIButton) {
    }
    
    @IBAction func option1ButtonClicked(sender: UIButton) {
    }
    
    @IBAction func option2ButtonClicked(sender: UIButton) {
    }
    
    @IBAction func option3ButtonClicked(sender: UIButton) {
    }
    
    @IBAction func option4ButtonClicked(sender: UIButton) {
    }
}