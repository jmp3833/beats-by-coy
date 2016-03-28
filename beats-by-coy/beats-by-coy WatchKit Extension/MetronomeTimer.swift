//
//  MetronomeTimer.swift
//  beats-by-coy
//
//  Created by Luke Coy on 3/28/16.
//  Copyright © 2016 Don't Believe Me, Just Watch. All rights reserved.
//

import Foundation
import WatchKit

struct TimeSignature {
    var beatsPerBar: Int = 1
    var noteValue: Int = 1
}

class MetronomeTimer: NSObject {
    internal var timeSignature = TimeSignature()
    
    var tempo: NSTimeInterval = 80
    
    var isRunning: Bool = false {
        didSet {
            
        }
    }
    
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
        WKInterfaceDevice.currentDevice().playHaptic(.Click)
        print("buzz")
    }
    
}