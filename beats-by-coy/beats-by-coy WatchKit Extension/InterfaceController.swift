//
//  InterfaceController.swift
//  beats-by-coy WatchKit Extension
//
//  Created by Justin on 2/22/16.
//  Copyright © 2016 Don't Believe Me, Just Watch. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate{

    @IBOutlet var tempoLabel: WKInterfaceLabel!
    var metronomeTimer: NSTimer!
    var session : WCSession!
    var metronomeIsOn = false
    var tempo: NSTimeInterval = 80 {
        didSet {
            tempoLabel.setText(String(format: "%.0f", tempo))
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func toggleMetronome(){
        if metronomeIsOn {
            // Mark the metronome as off.
            metronomeIsOn = false
            
            // Stop the metronome.
            metronomeTimer?.invalidate()
        }
            
        else {
            // Mark the metronome as on.
            metronomeIsOn = true
            
            // Start the metronome.
            let metronomeTimeInterval:NSTimeInterval = 60.0 / tempo
            print(metronomeTimeInterval)
            metronomeTimer = NSTimer.scheduledTimerWithTimeInterval(metronomeTimeInterval, target: self, selector: Selector("playMetronomeVibration"), userInfo: nil, repeats: true)
          //  metronomeTimer?.fire()
            // Change the toggle metronome button's image to "Stop" and tint
        }
    }
    
    func playMetronomeVibration(){
       // WKInterfaceDevice.currentDevice().playHaptic(.Click)
        print("buzz")
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if message["ChangeTempo"] != nil{
            dispatch_async(dispatch_get_main_queue()) {
                //score stuff update
                self.tempo = message["ChangeTempo"] as! Double
                self.tempoLabel.setText(String(format: "%.0f", self.tempo))
            }
        }
        else if message["StartMetronome"] != nil{
            self.tempo = message["StartMetronome"] as! Double
            self.tempoLabel.setText(String(format: "%.0f", self.tempo))
            toggleMetronome()
        }
    }
}
