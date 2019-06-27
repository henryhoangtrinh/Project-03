//
//  QuestionObject.swift
//  AboutTime
//
//  Created by Henry Trinh on 6/26/19.
//  Copyright © 2019 HR-Soft. All rights reserved.
//

import UIKit

enum EventDetails : String {
    
    /* 1 */     case Event1
    /* 2 */     case Event2
    /* 3 */     case Event3
    /* 4 */     case Event4
    /* 5 */     case Event5
    /* 6 */     case Event6
    /* 7 */     case Event7
    /* 8 */     case Event8
    /* 9 */     case Event9
    /* 10 */    case Event10
    /* 11 */    case Event11
    /* 12 */    case Event12
    /* 13 */    case Event13
    /* 14 */    case Event14
    /* 15 */    case Event15
    /* 16 */    case Event16
    /* 17 */    case Event17
    /* 18 */    case Event18
    /* 19 */    case Event19
    /* 20 */    case Event20
    /* 21 */    case Event21
    /* 22 */    case Event22
    /* 23 */    case Event23
    /* 24 */    case Event24
    /* 24 */    case Event25
    /* 24 */    case Event26
    /* 24 */    case Event27
    /* 24 */    case Event28
    /* 24 */    case Event29
    /* 24 */    case Event30
    /* 24 */    case Event31
    /* 24 */    case Event32
    /* 24 */    case Event33
    /* 24 */    case Event34
    /* 24 */    case Event35
    /* 24 */    case Event36
    /* 24 */    case Event37
    /* 24 */    case Event38
    /* 24 */    case Event39
    /* 24 */    case Event40
    
    
}
// Protocol for Question and Events

protocol QuestionObject {
    var eventTitle : String {get}
    var site: String {get}
    var year: Int {get}
}

protocol Events {
    var events: [EventDetails : QuestionObject] {get set}
    
    func selectEvent (forSelect select: EventDetails) -> QuestionObject?
}
/////

//prefer to the VendingMachine example
struct Question : QuestionObject{
    var eventTitle: String
    var site: String
    var year: Int
}

enum EventErrors: Error {
    case invalidResource
    case invalidSelection
    case consersionFailure
}


// Plist converter & Unarchiver (refence from VendingMachine example)
class PlistConverter {
    static func dictionary (fromFile name: String, ofType type: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw EventErrors.invalidResource }
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String : AnyObject] else {
            throw EventErrors.invalidResource
        }
        return dictionary
    }
}

class EventsUnarchinver {
    static func selectEvents (fromDictionary dictionary : [String: AnyObject]) throws -> [EventDetails: QuestionObject] {
        
        var events : [EventDetails: QuestionObject] = [:]
        
        for (key,value) in dictionary {
            if let itemDictionary = value as?[String:Any],
                let eventName = itemDictionary["eventName"] as? String,
                let siteOfEvent = itemDictionary["site"] as? String,
                let yearOfEvent = itemDictionary["year"] as? Int{
                let question = Question(eventTitle: eventName, site: siteOfEvent, year: yearOfEvent)
                guard let selection = EventDetails(rawValue: key) else {
                    throw EventErrors.invalidSelection
                }
                events.updateValue(question, forKey: selection)
            }
        }
        return events
    }
}
