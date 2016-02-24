//
//  MetronomeViewController.swift
//  beats-by-coy
//
//  Created by Adam Blaine on 2/22/16.
//  Copyright © 2016 Don't Believe Me, Just Watch. All rights reserved.
//

import UIKit
import WatchConnectivity

class MetronomeViewController: UIViewController, WCSessionDelegate {
   
    @IBOutlet weak var tempoTextField: UITextField!
    var session : WCSession!
    
    override func viewDidLoad() {
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        self.session.sendMessage(["ChangeTempo": Double(tempoTextField.text!)!], replyHandler: { (response) -> Void in
            }, errorHandler: { (error) -> Void in
                print(error)
        })
    }
    @IBAction func startMetronome(sender: AnyObject) {
        self.session.sendMessage(["StartMetronome": Double(tempoTextField.text!)!], replyHandler: { (response) -> Void in
            }, errorHandler: { (error) -> Void in
                print(error)
        })
    }
    @IBAction func stopMetronome(sender: AnyObject) {
        self.session.sendMessage(["StartMetronome": Double(tempoTextField.text!)!], replyHandler: { (response) -> Void in
            }, errorHandler: { (error) -> Void in
                print(error)
        })
    }
    @IBAction func tempoChanged(sender: AnyObject) {
        self.session.sendMessage(["ChangeTempo": Double(tempoTextField.text!)!], replyHandler: { (response) -> Void in
            }, errorHandler: { (error) -> Void in
                print(error)
        })

    }
}
