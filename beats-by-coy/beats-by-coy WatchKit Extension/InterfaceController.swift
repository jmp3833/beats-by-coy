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
    var metronomeTimer: NSTimer? = nil
    var countdownTimer: NSTimer? = nil
    var session : WCSession!
    var metronomeIsOn = false
    var countingDown = false
    var tempo: NSTimeInterval = 80 {
        didSet {

        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }
    
    /*
    * Send watch to sync screen
    */
    @IBAction func syncMenuActivate() {
    
    }
    
    /*
    * Send watch to subdivide screen
    */
    @IBAction func subdivideMenuActivate() {
        
    }
    
    /*
    * Send watch to signature screen
    */
    @IBAction func signatureMenuActivate() {
        
    }
    
    /*
    * Send watch to volume screen
    */
    @IBAction func volumeMenuActivate() {
        
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
    
    func stopMetronome(){
        if metronomeIsOn {
            metronomeIsOn = false
            metronomeTimer?.invalidate()
        }
    }
    
    func startMetronome(){
        if metronomeIsOn {

            metronomeTimer?.invalidate()
            
        }
        
        // Start countdown
        dispatch_sync(dispatch_get_main_queue()){
            self.startCountdown()
        }
    }
    
    func playMetronomeVibration(){
        WKInterfaceDevice.currentDevice().playHaptic(.Click)
        print("buzz")
    }
    
    func startCountdown() -> Void {
        self.countingDown = true
        let seconds = 5;
        self.countdown(seconds)
    }
    
    func countdown(seconds: Int){
        
        // Update UILabel
        if (seconds == 0) {
            self.countingDown = false
            print("Metronome starting.")
            metronomeIsOn = true
            // Start the metronome.
            let metronomeTimeInterval:NSTimeInterval = 60.0 / tempo
            print(metronomeTimeInterval)
            dispatch_async(dispatch_get_main_queue()){
                self.metronomeTimer = NSTimer.scheduledTimerWithTimeInterval(metronomeTimeInterval, target: self, selector: Selector("playMetronomeVibration"), userInfo: nil, repeats: true)
            }
            return
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            print("Metronome starting in: \(seconds)")
            self.countdown(seconds - 1)
            }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if message["ChangeTempo"] != nil{
            dispatch_async(dispatch_get_main_queue()) {
                //score stuff update
                self.tempo = message["ChangeTempo"] as! Double
            }
        }
        else if message["StartMetronome"] != nil{
            self.tempo = message["StartMetronome"] as! Double
            startMetronome()
        }
        else if message["StopMetronome"] != nil{
            stopMetronome()
        }
    }
    
    
}
