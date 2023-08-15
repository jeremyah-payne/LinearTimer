//
//  TimerVM.swift
//  LinearTimer Watch App
//
//  Created by Jeremyah Payne on 8/9/23.
//

import Foundation
import WatchKit
import SwiftUI

class TimerVM:NSObject,ObservableObject, WKExtendedRuntimeSessionDelegate  {
    
    // input to the view from the parent selection. time is in seconds. 
    var inputTime:Int = 0
    
    //regular variables
    //Two vars for keeping up with start and run times. 
    var runTime:Int = 0
    var countDownTime:Int = 0
    
        
    //monitor if the time is running or not to determine the button state
    var running:Bool = false
    var timer :Timer = Timer()
    
    
    //Publish these variables to the view
    //the button label will be drynamic based on time status
    @Published var CurrentLabel:String = "Start"
    // chnage the color of the button text based on time logic 
    @Published var modeColor:Color = .green
    //chenage the opactity of button based on app preferences, might make this apply to whole view
    @Published var buttonOpacity:Double = 100.0
    
    //Settings variables
    @AppStorage("startLag") var startLag:String = "5"
    @AppStorage("prefinishTime") var prefinish:String = "15"
    @AppStorage("useSound") var useSound:Bool = true
    @AppStorage("hideFace") var hideFace:Bool = true
    
   
    //debug
    var runCount:Int = 0
    
    ///ROUting Methods ////
    //start / restart the timer from the toggle button
    func resetTimer(input:Int) {
        running = true
        inputTime = input
        runTime = 0
        countDownTime = 0 
        modeColor = .green
        CurrentLabel = "Starting in... \(startLag)"
        timer = Timer.scheduledTimer(
                        timeInterval: 1, 
                        target: self,   
                        selector: #selector(updateTimeLoop), 
                        userInfo: nil, 
                        repeats: true
                        )
    }
    //stop the timer form the timer button
    func stopTimer() {
        running = false
        buttonOpacity = 100.0
        CurrentLabel = "Start"
        modeColor = .green
        timer.invalidate()
    }
    
    //Logic
    @objc func updateTimeLoop() {
        runCount+=1
        print("run loop: \(runCount)")
        guard running else  {
            return
        }
        let lagInt:Int = Int (startLag) ?? 0
        //compare the timer to the count down first., only evalute  runtime after counter is  done
        if countDownTime < lagInt {
            updateCountDown(lagInt:lagInt)
        } else { //evalute the runtime block
            updateRuntime()
        }//end updateloop
    }
    func updateCountDown(lagInt:Int) {
        countDownTime += 1
            CurrentLabel = "Starting in... \(lagInt - countDownTime)"
        
            if countDownTime >= lagInt {
                // do haptic feedback, I'm thinking of making this a system pref based on beta tester feedback and personal testing. i.e pref = .click || pref = .start then play(pref)
                if(useSound) {
                    WKInterfaceDevice.current().play(.start)
                }else {
                    WKInterfaceDevice.current().play(.click)
                }
                //check if hideface then set opacity or some var
                if hideFace {
                    //change opactity
                    buttonOpacity = 0.0
                }   
            }
        }
    
    func updateRuntime() {
        runTime = runTime + 1
        //click on the minute markers, might need this as a preferences, .et the user speak
        if( runTime % 60 == 0 && runTime != inputTime) {
            WKInterfaceDevice.current().play(.click)
        }
        //reformat the time form counting seconds to clokc minute sec format
        if(runTime >= 60) {
            CurrentLabel = String(format: "%d:%.2d", (runTime/60),(runTime%60))
        }else // leave in seconds
        {
            CurrentLabel = String(runTime)
        }
        //check if it is time for the warning yet based on the system preference
        if runTime == (inputTime - (Int (prefinish) ?? 15)) {
            //warn the user with double haptic touch
            //set the watch face to yellow to warn
            modeColor = .yellow
            if (useSound) {
                WKInterfaceDevice.current().play(.stop)
            } else {
                WKInterfaceDevice.current().play(.click)
            }
        }
        //if the run time is over the input then we are in the grace period and need to let the user know.
        if runTime >= inputTime {
            //set the watch face to yellow to warn
            //buttonOpacity = 100.0
            modeColor = .red
            if (useSound) {
                WKInterfaceDevice.current().play(.stop)
                WKInterfaceDevice.current().play(.stop)
            } else {
                WKInterfaceDevice.current().play(.click)
                WKInterfaceDevice.current().play(.click)
            }
        }
        
        
        if ( runTime == ( inputTime + 10)) {
            //final warning!
            timer.invalidate()
            running = false 
        }
    }
    
    // Bakcground Delegate Session methods.
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
//start stuff??
        
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        //MId Stuff
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        //EXPIRE STUFF
    }
    
    
}
