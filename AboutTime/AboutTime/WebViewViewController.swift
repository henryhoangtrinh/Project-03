//
//  WebViewViewController.swift
//  AboutTime
//
//  Created by Henry Trinh on 6/27/19.
//  Copyright © 2019 HR-Soft. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class WebViewViewController: UIViewController, WKNavigationDelegate {

    
    @IBOutlet weak var navigateBar: UINavigationItem!
    
    @IBOutlet weak var goBack: UIButton!
    var webView: WKWebView!
    var wikiSite : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wikiURL =  wikiSite
        let url = URL(string: wikiURL)
        webView.load(URLRequest(url: url!))
        goBack.isHidden = false
        goBack.isEnabled = true
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
   
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    
    @IBAction func goBacktoVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
