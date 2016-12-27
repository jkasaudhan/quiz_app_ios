//
//  GameSettingsViewConroller.swift
//  PlantsQuizApp
//
//  Created by Chetan Basuray on 26/11/14.
//
//

import UIKit

class GameSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let image = UIButton(named: "name") as UIButton?
        let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(100, 100, 100, 100)
        //button.setImage(forState: .Normal)
        button.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
        
        self.view.addSubview(button)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBActions:
   
    @IBAction func homeButtonClicked() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}