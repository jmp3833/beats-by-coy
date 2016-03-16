//
//  TimeSigController.swift
//  beats-by-coy
//
//  Created by Luke Coy on 3/9/16.
//  Copyright © 2016 Don't Believe Me, Just Watch. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class TimeSigController: WKInterfaceController {
    
    @IBOutlet var UpperPicker: WKInterfacePicker!
    
    
    func createPickerItem(n: integer_t) -> WKPickerItem {
        let pickerItem = WKPickerItem()
        pickerItem.title = String(n)
        pickerItem.caption = String(n)
        return pickerItem
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        UpperPicker.setItems((1...16).map(createPickerItem))
        UpperPicker.setSelectedItemIndex(3
        )
        print("YO?!?!?!")
    }

    
}
