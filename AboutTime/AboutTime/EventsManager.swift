//
//  EventsManager.swift
//  AboutTime
//
//  Created by Henry Trinh on 6/26/19.
//  Copyright © 2019 HR-Soft. All rights reserved.
//

import Foundation
import UIKit
import GameKit


class EventsManager : Events {
    
    var questionsAsked = 0
    var questionsPerRound : Int = 4 //4
    var NumberOfRound : Int  = 0 //6
    var NumberOfTotalRound : Int = 6
    var secondsPerRound: Int  = 60 //60s
    var correctedAnswer: Int = 0
    var randomNumberGenerated = [Int]()
    
    var events: [EventDetails : QuestionObject]
    
    init(events : [EventDetails : QuestionObject]) {
        self.events = events
        
        
    }
    
    func selectEvent(forSelect select: EventDetails) -> QuestionObject? {
        return events[select]
    }
    
    func generateUnquieNumber()-> Int {
         var shuffleQuestions = 0
        if randomNumberGenerated.count >= self.events.count {
            randomNumberGenerated.removeAll()
        }
        
        shuffleQuestions = GKRandomSource.sharedRandom().nextInt(upperBound: self.events.count)
        while randomNumberGenerated.contains(shuffleQuestions) {
            shuffleQuestions = GKRandomSource.sharedRandom().nextInt(upperBound: self.events.count)
        }
        
        return shuffleQuestions
    }
    
    func randomEvents () -> [QuestionObject] {
        var currentQuestion : [QuestionObject] = []
        for _ in 0..<questionsPerRound {
            let selectEvent = EventDetails(rawValue: "Event\(generateUnquieNumber()+1)")
            let event = events[selectEvent!]
            currentQuestion.append(event!)
        }
        return currentQuestion
    }
    
    
    
}





