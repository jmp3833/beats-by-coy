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
    
    @IBOutlet var signaturePicker: WKInterfacePicker!
    
    @IBOutlet var upperSignature: WKInterfaceButton!
    
    @IBOutlet var lowerSignature: WKInterfaceButton!
    
    var selectedSignature: WKInterfaceButton?
    
    func createPickerItem(n: integer_t) -> WKPickerItem {
        let pickerItem = WKPickerItem()
        pickerItem.title = String(n)
        pickerItem.caption = String(n)
        return pickerItem
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.

        print("YO?!?!?!")
    }

    
    @IBAction func onUpperTap() {
        selectSignature(upperSignature)
    }
    
    
    @IBAction func onLowerTap() {
        selectSignature(lowerSignature)
    }
    
    
    func selectSignature(button: WKInterfaceButton?) {
        selectedSignature?.setBackgroundColor(UIColor.blackColor())
        if selectedSignature == button {
            selectedSignature = nil;
        } else {
            selectedSignature = button;
            // restyle, etc
            button?.setBackgroundColor(UIColor.cyanColor())
            
        }
    }
    
}
