//
//  EndGameViewController.swift
//  AboutTime
//
//  Created by Henry Trinh on 6/26/19.
//  Copyright © 2019 HR-Soft. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    var currentScore: Int?
    var TotalRound: Int?
     
    
    @IBOutlet weak var showScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       if let score = currentScore,
        let round = TotalRound {
        showScore.text = "\(score)/\(round)"
       } else {
        currentScore = 0
        TotalRound = 0
        }
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
