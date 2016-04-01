//
//  SettingsController.swift
//  beats-by-coy
//
//  Created by Tyler Schoen on 3/11/16.
//  Copyright © 2016 Don't Believe Me, Just Watch. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class SettingsController: WKInterfaceController, WCSessionDelegate{

    // MARK: Properties
    @IBOutlet var countdownSettingLabel: WKInterfaceLabel!


    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        let defaults = NSUserDefaults.standardUserDefaults()

        
        if ((defaults.valueForKey("Countdown")) != nil) {
            let seconds = defaults.stringForKey("Countdown")!
            countdownSettingLabel.setText(seconds)
        } else {
            defaults.setValue(5, forKey: "Countdown")
            countdownSettingLabel.setText("5")
        }
    }
    
    // MARK: Actions
    @IBAction func countdownPlus() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
                if ((defaults.valueForKey("Countdown")) != nil) {
                    let seconds = Int(defaults.stringForKey("Countdown")!)!+1
                    defaults.setValue(seconds, forKey: "Countdown")
                    countdownSettingLabel.setText("\(seconds)")
                } else {
                    //throw err
                }
        
    }

    @IBAction func countdownMinus() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
                if ((defaults.valueForKey("Countdown")) != nil) {
                    let seconds = Int(defaults.stringForKey("Countdown")!)!-1
                    defaults.setValue(seconds, forKey: "Countdown")
                    countdownSettingLabel.setText("\(seconds)")
                } else {
                    //throw err
                }
    }
}