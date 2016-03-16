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
    @IBOutlet var vibrationPicker: WKInterfacePicker!
    
    
    var vTypes = [
        WKHapticType.Notification,
        WKHapticType.Failure,
        WKHapticType.DirectionUp,
        WKHapticType.DirectionDown,
        WKHapticType.Click
    ]
    
    func createPickerItem(n: integer_t) -> WKPickerItem {
        let pickerItem = WKPickerItem()
        pickerItem.title = String(n)
        pickerItem.caption = String(n)
        return pickerItem
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        let defaults = NSUserDefaults.standardUserDefaults()
        
        vibrationPicker.setItems((1...5).map(createPickerItem))
        
        if (defaults.valueForKey("VibrationType") != nil) {
            let vibration = defaults.stringForKey("VibrationType")!
            vibrationPicker.setSelectedItemIndex(Int(vibration)!)
        } else {
            defaults.setValue(1, forKey: "VibrationType")
            vibrationPicker.setSelectedItemIndex(1)
        }
        
        
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
    
    @IBAction func vibrationTypePickerChanged(value: Int) {
        // Save Vibration Type Setting
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(value, forKey: "VibrationType")
        
    }
}