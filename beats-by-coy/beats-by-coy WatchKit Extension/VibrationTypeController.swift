//
//  VibrationTypeController.swift
//  beats-by-coy
//
//  Created by Derek Leung on 3/11/16.
//  Copyright © 2016 Don't Believe Me, Just Watch. All rights reserved.
//

import WatchKit
import Foundation

class VibrationTypeController: WKInterfaceController{
    @IBOutlet var vibrationPicker: WKInterfacePicker!
     
     
     var vTypes = [
     WKHapticType.Failure,
     WKHapticType.DirectionUp,
     WKHapticType.Click,
     WKHapticType.DirectionDown,
     WKHapticType.Notification
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
        
    }
    
    
     @IBAction func vibrationTypePickerChanged(value: Int) {
     // Save Vibration Type Setting
     let defaults = NSUserDefaults.standardUserDefaults()
     
     defaults.setValue(value, forKey: "VibrationType")
     
     }
}