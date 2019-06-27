//
//  ViewController.swift
//  AboutTime
//
//  Created by Henry Trinh on 6/26/19.
//  Copyright © 2019 HR-Soft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Declare all buttons
    @IBOutlet weak var downButton1: UIButton!
    @IBOutlet weak var upButton2: UIButton!
    @IBOutlet weak var downButton2: UIButton!
    @IBOutlet weak var upButton3: UIButton!
    @IBOutlet weak var downButton3: UIButton!
    @IBOutlet weak var upButton4: UIButton!
    @IBOutlet weak var CheckButton: UIButton!
    
    // Declare all Labels
    @IBOutlet weak var Question1: UILabel!
    @IBOutlet weak var Question2: UILabel!
    @IBOutlet weak var Question3: UILabel!
    @IBOutlet weak var Question4: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var shakeLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    
    
    // Declare all Variables
    let eventTimeLine : EventsManager
    var allEvents : [QuestionObject] = []
    var isTesting = true
    var currentRound = 0
    var currentSite : String = ""
    var timer = Timer()
    var seconds = 60
    
    //load the plist
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "TimeLines", ofType: "plist")
            let events = try EventsUnarchinver.selectEvents(fromDictionary: dictionary)
            //print(events)
            self.eventTimeLine = EventsManager(events: events)
            //print(events)
        } catch let error {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        setCountdown()
        start()
    //showWikiButton(inUse: true)
    
    }

    func displayQuestion() {
        if isTesting {
            Question1.text = "\(allEvents[0].eventTitle) \n \(allEvents[0].year)"
            Question2.text = "\(allEvents[1].eventTitle) \n \(allEvents[1].year)"
            Question3.text = "\(allEvents[2].eventTitle) \n \(allEvents[2].year)"
            Question4.text = "\(allEvents[3].eventTitle) \n \(allEvents[3].year)"
        } else {
            Question1.text = allEvents[0].eventTitle
            Question2.text = allEvents[1].eventTitle
            Question3.text = allEvents[2].eventTitle
            Question4.text = allEvents[3].eventTitle
    }
        CheckButton.isHidden = true
        TimeLabel.isHidden = false
        shakeLabel.isHidden = false
}

    func start() {
        allEvents = eventTimeLine.randomEvents()
        ScoreLabel.text = "\(eventTimeLine.correctedAnswer) | \(currentRound)"
        eventTimeLine.NumberOfRound += 1
        currentRound += 1
        print(allEvents[0])
        print(allEvents[1])
        print(allEvents[2])
        print(allEvents[3])
        displayQuestion()
        disableButtons(isUse: false)
        shakeLabel.text = "Shake to complete"
        //setCountdown()
    }

    func nextRound() {
        if eventTimeLine.NumberOfRound < eventTimeLine.NumberOfTotalRound {
            timeReset()
            start()
           // showWikiButton(inUse: false)
        } else {
            eventTimeLine.NumberOfRound = 0
            performSegue(withIdentifier: "EndGame", sender: nil)
            shakeLabel.text = "Shake to complete"
            //timer.invalidate()
            eventTimeLine.correctedAnswer = 0
            currentRound = 0
            restartNewRound()
            timeReset()
        }
    }

    func checkAnswer() {
        if (allEvents[0].year <= allEvents[1].year && allEvents[1].year <= allEvents[2].year && allEvents[2].year <= allEvents[3].year) {
        
            showCorrect()
            disableButtons(isUse: true)
        } else {
           disableButtons(isUse: true)
            showWrong()
        }
    
    
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            timer.invalidate()
            checkAnswer()
        }
    }
    
    func restartNewRound() {
        
        
        start()
        //showWikiButton(inUse: false)
    }
    
    func showWikiButton(inUse use : Bool) {
        if use {
            print(use)
           // wikiButton1.isHidden = false
          //  wikiButton1.isHidden = false
          //  wikiButton1.isHidden = false
          //  wikiButton1.isHidden = false
            
           // wikiButton1.isEnabled = true
           // wikiButton2.isEnabled = true
          // wikiButton3.isEnabled = true
          //  wikiButton4.isEnabled = true
            
            Question1.isHidden = true
            Question2.isHidden = true
            Question3.isHidden = true
            Question4.isHidden = true
        } else  {
            print(use)
         //   wikiButton1.isHidden = true
          //  wikiButton1.isHidden = true
         //   wikiButton1.isHidden = true
         //   wikiButton1.isHidden = true
            
         //   wikiButton1.isEnabled = false
         //   wikiButton2.isEnabled = false
        //    wikiButton3.isEnabled = false
         //   wikiButton4.isEnabled = false
            
            Question1.isHidden = false
            Question2.isHidden = false
            Question3.isHidden = false
            Question4.isHidden = false
        }
    }
    
    func disableButtons (isUse use : Bool){
        if use {
            downButton1.isEnabled = false
            upButton2.isEnabled = false
            downButton2.isEnabled = false
            upButton3.isEnabled = false
            downButton3.isEnabled = false
            upButton4.isEnabled = false

        } else {
            downButton1.isEnabled = true
            upButton2.isEnabled = true
            downButton2.isEnabled = true
            upButton3.isEnabled = true
            downButton3.isEnabled = true
            upButton4.isEnabled = true

        }
    }
    
    
    func showCorrect() {
        //sound
        //time
        TimeLabel.isHidden = true
        CheckButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: .normal)
        CheckButton.isHidden = false
        eventTimeLine.correctedAnswer += 1
        shakeLabel.text = "Tap events to learn more"
       // showWikiButton(inUse: true)
        //nextRound()
    }
    
    func showWrong() {
        //sound
        //time
        TimeLabel.isHidden = true
        CheckButton.setImage(#imageLiteral(resourceName: "next_round_fail"), for: .normal)
        CheckButton.isHidden = false
        shakeLabel.text = "Tap events to learn more"
        //showWikiButton(inUse: true)
        //nextRound()
    }
    
    func setCountdown() {
        TimeLabel.text = "00:\(seconds)"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeFunc), userInfo: nil, repeats: true)
    }
    
    @objc func timeFunc () {
        if seconds < 1 {
            timer.invalidate()
            checkAnswer()
        } else {
            seconds -= 1
            TimeLabel.text = "0:\(String(format: "%02d", seconds))"
        }
    }
    
    //Mark : Segue for End Game VC & Wikisite VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EndGame" {
            let EndGameVC = segue.destination as? EndGameViewController
            EndGameVC?.currentScore = eventTimeLine.correctedAnswer
            EndGameVC?.TotalRound = currentRound
        }
    }
    
    func timeReset() {
        timer.invalidate()
        seconds = 60
        setCountdown()
    }
    
    //Mark : Action's buttons
    @IBAction func downButton1Swapped(_ sender: UIButton) {
        allEvents.swapAt(0, 1)
        displayQuestion()
        
    }
    
    @IBAction func upButton2Swapped(_ sender: UIButton) {
        allEvents.swapAt(1, 0)
        displayQuestion()
    }
    
    @IBAction func downButton2Swapped(_ sender: UIButton) {
        allEvents.swapAt(1, 2)
        displayQuestion()
    }
    
    @IBAction func upButton3Swapped(_ sender: UIButton) {
        allEvents.swapAt(2, 1)
        displayQuestion()
    }
    
    @IBAction func downButton3Swapped(_ sender: UIButton) {
        allEvents.swapAt(2, 3)
        displayQuestion()
    }
    
    
    @IBAction func upButton4Swapped(_ sender: UIButton) {
        allEvents.swapAt(3, 2)
        displayQuestion()
    }
    
    @IBAction func toNextQuestion(_ sender: UIButton) {
        nextRound()
    }
    
    
}

