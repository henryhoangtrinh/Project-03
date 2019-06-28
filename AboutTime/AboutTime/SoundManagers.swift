//
//  SoundManagers.swift
//  AboutTime
//
//  Created by Henry Trinh on 6/27/19.
//  Copyright © 2019 HR-Soft. All rights reserved.
//

import AudioToolbox

struct SoundManager {
    
    var gameSound: SystemSoundID = 0
    
    
    mutating func loadCorrectSound() {
        let correctSound = Bundle.main.path(forResource: "CorrectDing", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: correctSound!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    mutating func loadIncorrectSound() {
        let incorrectSound = Bundle.main.path(forResource: "IncorrectBuzz", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: incorrectSound!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    mutating func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    func playGameSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
}
