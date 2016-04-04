//
//  MetronomeViewController.swift
//  beats-by-coy
//
//  Created by Adam Blaine on 2/22/16.
//  Copyright © 2016 Don't Believe Me, Just Watch. All rights reserved.
//

import UIKit
import WatchConnectivity
import AudioToolbox

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
    @IBAction func VibrateOnPhoneSet(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if(sender.on) {
          defaults.setValue("true", forKey: "PhoneVibrate");
        }
        else {
            defaults.setValue("false", forKey: "PhoneVibrate");
        }
    }
    @IBAction func startMetronome(sender: AnyObject) {
        self.session.sendMessage(["StartMetronome": Double(tempoTextField.text!)!], replyHandler: { (response) -> Void in
            }, errorHandler: { (error) -> Void in
                print(error)
        })
    }
    @IBAction func stopMetronome(sender: AnyObject) {
        self.session.sendMessage(["StopMetronome": Double(tempoTextField.text!)!], replyHandler: { (response) -> Void in
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
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("Message")
        if message["vibrate"] != nil {
            //Make watch vibrate if appropriate bit is flipped
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if (defaults.valueForKey("PhoneVibrate") != nil){
                if(defaults.stringForKey("PhoneVibrate")! == "true") {
                  AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                }
            }
            
            else {
                defaults.setValue("false", forKey: "PhoneVibrate");
            }
        }
        if message["BPMChanged"] != nil {
            print(String(message["BPMChanged"] as! Int))
            dispatch_async(dispatch_get_main_queue()) {
                do {
                    try self.tempoTextField.text = String(message["BPMChanged"] as! Int)
                    
                }
                catch {
                    print("set BPM didn't work")
                }
                
            }
        }
    }
    
}
