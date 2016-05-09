//
//  MetronomeTimer.swift
//  beats-by-coy
//
//  Created by Luke Coy on 3/28/16.
//  Copyright © 2016 Don't Believe Me, Just Watch. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

struct TimeSignature {
    var beatsPerBar: Int = 1
    var noteValue: Int = 1
}

class MetronomeTimer: NSObject, WCSessionDelegate {
    internal var timeSignature = TimeSignature()

    var tempo: NSTimeInterval = 80

    var beatNumber: Int = 0

    var isRunning: Bool = false {
        didSet {

        }
    }


    var session: WCSession!

    var metronomeTimer: NSTimer? = nil

    internal static let instance: MetronomeTimer = MetronomeTimer()


    func stopMetronome(){
        if isRunning {
            isRunning = false
            metronomeTimer?.invalidate()
        }
    }

    func startMetronome(){
        if isRunning {
            metronomeTimer?.invalidate()

        }

        let metronomeTimeInterval:NSTimeInterval = 60.0 / tempo

        dispatch_async(dispatch_get_main_queue()){
            self.metronomeTimer = NSTimer.scheduledTimerWithTimeInterval(
                metronomeTimeInterval,
                target: self,
                selector: Selector("playMetronomeVibration"),
                userInfo: nil,
                repeats: true)
        }
        isRunning = true
    }

    func playMetronomeVibration(){
        beatNumber = (beatNumber + 1) % timeSignature.beatsPerBar

        let defaults = NSUserDefaults.standardUserDefaults()
        var haptic: WKHapticType? = nil;
        if (defaults.valueForKey("VibrationType") != nil) {
            let vibration = defaults.stringForKey("VibrationType")
            haptic = WKHapticType.init(rawValue: Int(vibration!)!)
        } else {
            defaults.setValue(1, forKey: "VibrationType")
            haptic = WKHapticType.init(rawValue: 1)
        }

        if beatNumber == 0 {
            WKInterfaceDevice.currentDevice().playHaptic(.Click)
            print("downbeat")
        } else {

            WKInterfaceDevice.currentDevice().playHaptic(haptic!)
            print("buzz")
        }

        //Send message to iphone to vibrate if desired
        var vibrationDict = [String:Bool]()
        vibrationDict["vibrate"] = true
        self.session.sendMessage(vibrationDict, replyHandler: { (response) -> Void in
            }, errorHandler: { (error) -> Void in
                print(error)
        })
    }




}
