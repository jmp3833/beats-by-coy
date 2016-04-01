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
    
    var timer = MetronomeTimer.instance
    
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
        upperSignature.setTitle(String(timer.timeSignature.beatsPerBar));
        lowerSignature.setTitle(String(timer.timeSignature.noteValue));

        print("YO?!?!?!")
    }

    
    @IBAction func onSelection(value: Int) {
        selectedSignature?.setTitle(String(value + 1));
        
        if selectedSignature == upperSignature {
            timer.timeSignature.beatsPerBar = value + 1;
        } else if selectedSignature == lowerSignature {
            timer.timeSignature.noteValue = value + 1;
        }

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
            button?.setBackgroundColor(UIColor.blueColor())
            
        }
        if selectedSignature == nil {
            signaturePicker.setItems([]);
        } else {
            signaturePicker.setItems((1...12).map(createPickerItem));
            if selectedSignature == upperSignature {
                signaturePicker.setSelectedItemIndex(
                    timer.timeSignature.beatsPerBar - 1);
            } else if selectedSignature == lowerSignature {
                signaturePicker.setSelectedItemIndex(
                    timer.timeSignature.noteValue - 1);
            }
        }
    }
    
} 
