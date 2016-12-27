//
//  AudioManagerHelper.swift
//  PlantsQuizApp
//
//  Created by Efe Bozkir on 05/12/14.
//
//

import Foundation
import AVFoundation

private let _audioManagerHelperInstance = AudioManagerHelper()

class AudioManagerHelper {
    
    var audioPlayer: AVAudioPlayer?
    var audioPlayerSingleInstance: AVAudioPlayer?
    
    class var sharedAudioManagerHelper: AudioManagerHelper {
        return _audioManagerHelperInstance
    }
    
    private init() {
        audioPlayer = AVAudioPlayer()
    }
    
    func playBackgroundMusic(fileName: String) {
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType:"mp3")
        let fileURL = NSURL(fileURLWithPath: path!)
        audioPlayer = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        audioPlayer?.numberOfLoops = -1
    }
    
    func playMusic(fileName: String) {
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType:"mp3")
        let fileURL = NSURL(fileURLWithPath: path!)
        audioPlayerSingleInstance = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        audioPlayerSingleInstance?.prepareToPlay()
        audioPlayerSingleInstance?.play()
    }
}
