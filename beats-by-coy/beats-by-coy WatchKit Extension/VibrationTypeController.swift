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
    func createPickerItem(x: WKHapticType, y: String) -> WKPickerItem {
        let pickerItem = WKPickerItem()
        pickerItem.title = y
        //pickerItem.caption = String(n)
        return pickerItem
    }
    
    var vTypes = [
        (WKHapticType.Notification, "Notification"),
        (WKHapticType.Failure, "Fail"),
        (WKHapticType.DirectionUp, "Up"),
        (WKHapticType.DirectionDown, "Down"),
        (WKHapticType.Click, "Click")
    ]

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.

    }
}