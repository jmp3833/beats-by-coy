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
    @IBOutlet var bpmPicker: WKInterfacePicker!
    @IBOutlet var countdownLabel: WKInterfaceLabel!

    
    var metronomeTimer: NSTimer? = nil
    var countdownTimer: NSTimer? = nil
    var session : WCSession!
    var metronomeIsOn = false
    var countingDown = false
    var tempo: NSTimeInterval = 80 {
        didSet {

        }
    }
    
    func createPickerItem(n: integer_t) -> WKPickerItem {
        let pickerItem = WKPickerItem()
        pickerItem.title = String(n)
        pickerItem.caption = String(n)
        return pickerItem
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        bpmPicker.setItems((10...200).filter({$0%5==0}).map(createPickerItem))
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.valueForKey("BPM") != nil) {
            let index = Int(defaults.stringForKey("BPM")!)
            bpmPicker.setSelectedItemIndex(index!)
        } else {
            bpmPicker.setSelectedItemIndex(70)
        }
    }
    
    /*
    * Send watch to sync screen
    */
    @IBAction func syncMenuActivate() {
        pushControllerWithName("SyncController", context: nil)
    }
    
    /*
    * Send watch to sudbdivide screen
    */
    @IBAction func settingsMenuActivate() {
        pushControllerWithName("SettingsController", context: nil)
        
    }
    
    /*
    * Send watch to signature screen
    */
    @IBAction func signatureMenuActivate() {
        pushControllerWithName("SignatureController", context: nil)
    }
    
    @IBAction func bpmPickerChanged(value: Int) {
        // Save BPM in settings
        let defaults = NSUserDefaults.standardUserDefaults()
        let bpmValue = (value * 5) + 10
        defaults.setValue(bpmValue, forKey: "BPM")
        
        self.session.sendMessage(["BPMChanged": bpmValue], replyHandler: { (response) -> Void in
            }, errorHandler: { (error) -> Void in
                print(error)
        })

    }
    
    /*
    * Send watch to volume screen
    */
    @IBAction func volumeMenuActivate() {
        pushControllerWithName("VolumeController", context: nil)
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
            self.countdownLabel.setText("Metronome Stopped")
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
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.valueForKey("VibrationType") != nil) {
            let vibration = defaults.stringForKey("VibrationType")
            let haptic = WKHapticType.init(rawValue: Int(vibration!)!)
            
            WKInterfaceDevice.currentDevice().playHaptic(haptic!)
            print("buzz \(haptic!.rawValue)")
        } else {
            defaults.setValue(1, forKey: "VibrationType")
            let haptic = WKHapticType.init(rawValue: 1)
            
            WKInterfaceDevice.currentDevice().playHaptic(haptic!)
            print("buzz \(haptic!.rawValue)")
        }
        
    }
    
    func startCountdown() -> Void {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if ((defaults.valueForKey("Countdown")) != nil) {
            let seconds = Int(defaults.stringForKey("Countdown")!)
            self.countdown(seconds!)
        } else {
            let seconds = 5
            // TODO: This needs to be initially set when the app is first launched for a user
            defaults.setValue(seconds, forKey: "Countdown")
            self.countdown(seconds)
        }
        self.countingDown = true
        
    
        
    }
    
    func countdown(seconds: Int){
        
        // Update UILabel
        if (seconds == 0) {
            self.countingDown = false
            print("Metronome starting.")
            self.countdownLabel.setText("Metronome Started")
            metronomeIsOn = true
            // Start the metronome.
            let metronomeTimeInterval:NSTimeInterval = 60.0 / tempo
            print(metronomeTimeInterval)
            dispatch_async(dispatch_get_main_queue()){
                self.metronomeTimer = NSTimer.scheduledTimerWithTimeInterval(metronomeTimeInterval, target: self, selector: Selector("playMetronomeVibration"), userInfo: nil, repeats: true)
            }
            return
        }
        
        print("Metronome starting in: \(seconds)")
        self.countdownLabel.setText("\(seconds)")
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.countdown(seconds - 1)
            }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if message["ChangeTempo"] != nil{
            dispatch_async(dispatch_get_main_queue()) {
                //score stuff update
                self.tempo = message["ChangeTempo"] as! Double
                self.bpmPicker.setSelectedItemIndex((Int(self.tempo) - 10) / 5)
            }
        }
        else if message["StartMetronome"] != nil{
            self.tempo = message["StartMetronome"] as! Double
            self.bpmPicker.setSelectedItemIndex((Int(self.tempo) - 10) / 5)

            startMetronome()
        }
        else if message["StopMetronome"] != nil{
            stopMetronome()
        }
    }
    

}
