//
//  SpriteLayoutHelper.swift
//  PlantsQuizApp
//
//  Created by lucaci on 12/12/14.
//
//

import Foundation
import SpriteKit

class SpriteLayoutHelper {

    class func wrapTextOnParent(parent: SKSpriteNode, text: String, fontColor: Int){
        let parentHeight = parent.size.height
        let parentWidth = parent.size.width
        let parentZPosition = parent.zPosition
        
        let words = text.componentsSeparatedByString(" ")
        var lines = [String]()
        lines.append("")
        
        let maxLineCharacters = 35
        let fontSize = Int(parentWidth / 20 + 1)
        println("parent \(parentWidth) font \(fontSize)")
        
        var lineIndex = 0
        for word in words {
            var line = lines[lineIndex]
            let lineLength = countElements(line)
            let wordLength = countElements(word)
            if lineLength + wordLength < maxLineCharacters {
                line += " " + word
                lines[lineIndex] = line
            }
            else {
                lines.append("")
                lineIndex++
                line = lines[lineIndex]
                line += " " + word
                lines[lineIndex] = line
            }
        }
        
        for index in 0..<lines.count {
            let questionLine = SKLabelNode(text: lines[index])
            let rowHeight = parentHeight/CGFloat(lines.count+2+index)
            var lineHeight = parentHeight/2 - ( CGFloat(index+1) * (1.5 * rowHeight) )
            let questionPosition = CGPoint(x: 0, y: lineHeight)
            questionLine.zPosition = parentZPosition
            FontHelper.sharedFontHelper.changeSKLabelFont(questionLine, fontSize: fontSize, fontColor: fontColor)
            questionLine.position = questionPosition
            parent.addChild(questionLine)
        }
    }
    
    

}