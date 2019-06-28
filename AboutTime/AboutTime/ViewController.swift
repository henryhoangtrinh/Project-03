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
    
    @IBOutlet weak var wikiSite1: UIButton!
    @IBOutlet weak var wikiSite2: UIButton!
    @IBOutlet weak var wikiSite3: UIButton!
    @IBOutlet weak var wikiSite4: UIButton!
    
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
    var isTesting = false // True for display the year (which is ez for testing) , set false to let the apps  go as it suppose to
    var currentRound = 0
    var currentSite : String = ""
    var timer = Timer()
    var seconds = 60
    var myGameSound = SoundManager()
    
    //MARK: load the plist
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "TimeLines", ofType: "plist")
            let events = try EventsUnarchinver.selectEvents(fromDictionary: dictionary)
            self.eventTimeLine = EventsManager(events: events)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        start()
    }
    // MARK : Basic function for the apps
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
        showWikiButton(inUse: false)
        myGameSound.loadGameStartSound()
        myGameSound.playGameSound()
        allEvents = eventTimeLine.randomEvents()
        ScoreLabel.text = "\(eventTimeLine.correctedAnswer) | \(currentRound)"
        eventTimeLine.NumberOfRound += 1
        currentRound += 1
        displayQuestion()
        disableButtons(isUse: false)
        shakeLabel.text = "Shake to complete"
        setCountdown()
    }

    func nextRound() {
        print(eventTimeLine.NumberOfRound)
        print(eventTimeLine.NumberOfTotalRound)
        if eventTimeLine.NumberOfRound < eventTimeLine.NumberOfTotalRound {
            timeReset(at: 60)
            start()
        } else {
            shakeLabel.text = "Shake to complete"
            performSegue(withIdentifier: "EndGame", sender: nil)
        }
    }
    // MARK : check answer base on the provided file
    func checkAnswer() {
        if (allEvents[0].year <= allEvents[1].year &&
            allEvents[1].year <= allEvents[2].year &&
            allEvents[2].year <= allEvents[3].year) {
            showCorrect()
            disableButtons(isUse: true)
        } else {
            disableButtons(isUse: true)
            showWrong()
        }
    }
    // MARK : Activate the Shake Gesture features
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            timer.invalidate()
            checkAnswer()
        }
    }
    // MARK : show the wikisite and buttons
    func showWikiButton(inUse use : Bool) {
        if use { // TRUE when we want to show the wikibuttonSite -wiki should .isHidden = false
                 // should .isEnabled = true to make the buttons work
                 // and Questions need to be .isHidden = true ( not show )
            wikiSite1.isHidden = false
            wikiSite2.isHidden = false
            wikiSite3.isHidden = false
            wikiSite4.isHidden = false
            
            wikiSite1.isEnabled = true
            wikiSite2.isEnabled = true
            wikiSite3.isEnabled = true
            wikiSite4.isEnabled = true
            
            wikiSite1.setTitle(allEvents[0].eventTitle, for: .normal)
            wikiSite2.setTitle(allEvents[1].eventTitle, for: .normal)
            wikiSite3.setTitle(allEvents[2].eventTitle, for: .normal)
            wikiSite4.setTitle(allEvents[3].eventTitle, for: .normal)
            
            Question1.isHidden = true
            Question2.isHidden = true
            Question3.isHidden = true
            Question4.isHidden = true
        } else  { // otherwise
            wikiSite1.isHidden = true
            wikiSite2.isHidden = true
            wikiSite3.isHidden = true
            wikiSite4.isHidden = true
            
            wikiSite1.isEnabled = false
            wikiSite2.isEnabled = false
            wikiSite3.isEnabled = false
            wikiSite4.isEnabled = false
            
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
    // MARK : decide to show correctness
    func showCorrect() {
        myGameSound.loadCorrectSound()
        myGameSound.playGameSound()
        timer.invalidate()
        TimeLabel.isHidden = true
        CheckButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: .normal)
        CheckButton.isHidden = false
        eventTimeLine.correctedAnswer += 1
        shakeLabel.text = "Tap events to learn more"
        showWikiButton(inUse: true)
    }
    
    func showWrong() {
        myGameSound.loadIncorrectSound()
        myGameSound.playGameSound()
        timer.invalidate()
        TimeLabel.isHidden = true
        CheckButton.setImage(#imageLiteral(resourceName: "next_round_fail"), for: .normal)
        CheckButton.isHidden = false
        shakeLabel.text = "Tap events to learn more"
        showWikiButton(inUse: true)
    }
    
  
    
    //Mark : Segue for End Game VC & Wikisite VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(segue.identifier)
        if segue.identifier == "EndGame" {
            let EndGameVC = segue.destination as? EndGameViewController
            EndGameVC?.currentScore = eventTimeLine.correctedAnswer
            EndGameVC?.TotalRound = currentRound
        } else if segue.identifier == "goToWiki1" {
            let navigationVC = segue.destination as? UINavigationController
            let wikiSiteVC1 = navigationVC?.topViewController as? WebViewViewController
            wikiSiteVC1?.wikiSite = allEvents[0].site
        } else if segue.identifier == "goToWiki2" {
            let navigationVC = segue.destination as? UINavigationController
            let wikiSiteVC1 = navigationVC?.topViewController as? WebViewViewController
            wikiSiteVC1?.wikiSite = allEvents[1].site
        } else if segue.identifier == "goToWiki3" {
            let navigationVC = segue.destination as? UINavigationController
            let wikiSiteVC1 = navigationVC?.topViewController as? WebViewViewController
            wikiSiteVC1?.wikiSite = allEvents[2].site
        } else if segue.identifier == "goToWiki4" {
            let navigationVC = segue.destination as? UINavigationController
            let wikiSiteVC1 = navigationVC?.topViewController as? WebViewViewController
            wikiSiteVC1?.wikiSite = allEvents[3].site
        }
    }
    
    @IBAction func unwindToVC (_ sender: UIStoryboardSegue){
        eventTimeLine.NumberOfRound = 0
        eventTimeLine.correctedAnswer = 0
        currentRound = 0
        nextRound()
        print("START HERE NOW")
    }
    //Mark : Time set up
    
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
    
    func timeReset(at second: Int) {
        timer.invalidate()
        seconds = second
        //setCountdown()
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
    
    @IBAction func showWikiSite1(_ sender: UIButton) {
        performSegue(withIdentifier: "goToWiki1", sender: nil)
    }
    
    @IBAction func showWikiSite2(_ sender: UIButton) {
        performSegue(withIdentifier: "goToWiki2", sender: nil)
    }
    @IBAction func showWikiSite3(_ sender: UIButton) {
        performSegue(withIdentifier: "goToWiki3", sender: nil)
    }
    @IBAction func showWikiSite4(_ sender: UIButton) {
        performSegue(withIdentifier: "goToWiki4", sender: nil)
    }
    
    
    @IBAction func downButton1Pressed(_ sender: UIButton) {
        downButton1.setImage(#imageLiteral(resourceName: "down_full_selected"), for: .highlighted )
    }
    
    @IBAction func upButton2Pressed(_ sender: UIButton) {
        upButton2.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted )
    }
    
    @IBAction func upButton3Pressed(_ sender: UIButton) {
        upButton3.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted )
    }
    
    @IBAction func downButton2Pressed(_ sender: UIButton) {
        downButton2.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted )
    }
    @IBAction func downButton3Pressed(_ sender: UIButton) {
        downButton3.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted )
    }
    @IBAction func upButton4Pressed(_ sender: UIButton) {
        upButton4.setImage(#imageLiteral(resourceName: "up_full_selected"), for: .highlighted )
    }
        
}


