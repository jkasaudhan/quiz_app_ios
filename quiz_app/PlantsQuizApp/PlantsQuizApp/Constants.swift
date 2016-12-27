//
//  Constants.swift
//  PlantsQuizApp
//
//  Created by Shahid Aslam on 05/12/2014.
//
//

import Foundation

enum Colors: Int {
    case yellow = 0xffff00
    case green = 0x2e8b57
    case darkGreen = 0x006400
    case white = 0xFFFFFF
    case lightGreen = 0xadff2f
    case red = 0xff0000
    case lightRed = 0xFA5858
}

private let _gameConfigurationInstance = GameConfiguration()

class GameConfiguration {
    
    private var language: String = "en"
    
    class var sharedGameConfiguration: GameConfiguration {
        return _gameConfigurationInstance
    }
    
    class func roundSize() -> Int{
        return 10;
    }
    
    class func examRoundSize() -> Int{
        return 20;
    }
    
    class func examTimeSeconds() -> Int{
        return 50;
    }
    
    func getLanguage() -> String {
        return language
    }
    
    func setLanguge(language: String){
        if (language != "en" || language != "de") {
            self.language = "en"
        } else {
            self.language = language
        }
    }
}