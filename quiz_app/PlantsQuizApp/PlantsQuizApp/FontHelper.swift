//
//  FontHelper.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 05/12/2014.
//
//

import Foundation
import SpriteKit

private let _fontHelperInstance = FontHelper()

class FontHelper {
    
    class var sharedFontHelper: FontHelper {
        return _fontHelperInstance
    }
    
    private init() {}
    
    func changeLabelFont(uiLabel: UILabel, fontSize: Int, fontColor: Int) {
        uiLabel.font = UIFont(name: "Jokerman-Regular", size: CGFloat(fontSize))
        uiLabel.textColor = UIColorFromRGB(UInt(fontColor))
    }
    
    func changeButtonFont(uiButton: UIButton, fontSize: Int, fontColor: Int) {
        uiButton.titleLabel!.font = UIFont(name: "Jokerman-Regular", size: CGFloat(fontSize))
        uiButton.setTitleColor(UIColorFromRGB(UInt(fontColor)), forState: UIControlState.Normal)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func changeSKLabelFont(uiLabel: SKLabelNode, fontSize: Int, fontColor: Int) {
        uiLabel.fontColor = UIColorFromRGB(UInt(fontColor))
        uiLabel.fontName = "Jokerman-Regular"
        uiLabel.fontSize = CGFloat(fontSize)
    }
}