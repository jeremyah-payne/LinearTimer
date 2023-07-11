//
//  RunView.swift
//  LinearTimer Watch App
//
//  Created by Jeremyah Payne on 6/19/23.
//

import SwiftUI
import UIKit

struct RunView: View {
    
    // input to the view from the parent selection. time is in seconds. 
    let inputTime:Int
    //Two vars for keeping up with start and run times. 
    @State var runTime:Int = 0
    @State var countDownTime:Int = 0
    
    //the button label will be drynamic based on time status
    @State var CurrentLabel:String = "Start"
    //chenage the opactity of button based on app preferences, might make this apply to whole view
    @State var buttonOpacity:Double = 100.0
    // chnage the color of the button text based on time logic 
    @State var modeColor:Color = .green
    /*this timer will fire every second. do not connect or autoconnet. here as that starts the time
    originally had as a let but using as a var so that way I can reinit the timer without reloading the view*/
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    //monitor if the time is running or not to determine the button state
    @State var running:Bool = false
    //unsued, mutability breaks view... still not sure how to handle cancleable... see below
    //var stopTime :Timer
    
    ///app system preferences with defaukt values for a first run. 
    @AppStorage("startLag") var startLag:String = "5"
    @AppStorage("prefinishTime") var prefinish:String = "15"
    @AppStorage("hideFace") var hideFace:Bool = false
    
    
    var body: some View {
        let lagInt:Int = Int (startLag) ?? 0
        //FYI, in Swift UI .XYZ following an object essentialy appends functinality
        Button(CurrentLabel, action:toggleTimer )
            //.fixedSize()
//            .controlSize(.large)
        //Still cant get the framing right for the button... I have much to learn.
            .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity

                )
            .foregroundColor(modeColor)
            .opacity(buttonOpacity)
            .onReceive(timer)  { time in
                //compare the timer to the count down first., only evalute  runtime after counter is  done
                if countDownTime < lagInt {
                    countDownTime = countDownTime + 1
                    CurrentLabel = "Starting in... \(lagInt - countDownTime)"
                    if countDownTime == lagInt {
                        // do haptic feedback, I'm thinking of making this a system pref based on beta tester feedback and personal testing. i.e pref = .click || pref = .start then play(pref)
                        WKInterfaceDevice.current().play(.start)
                        //check if hideface then set opacity or some var
                        if hideFace {
                            //change opactity
                            buttonOpacity = 0.0
                        }
                    }
                } else { //evalute the runtime block
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
                        
                        WKInterfaceDevice.current().play(.stop)
                    }
                    //if the run time is over the input then we are in the grace period and need to let the user know.
                    if runTime >= inputTime {
                        //set the watch face to yellow to warn
                        buttonOpacity = 100.0
                        modeColor = .red
                        WKInterfaceDevice.current().play(.stop)
                        WKInterfaceDevice.current().play(.stop)
                    }
                    
                }//end else run time evaluation block. 
                if ( runTime == ( inputTime + 10)) {
                    //final warning!
                    timer.connect().cancel()
                }
            }// End on Receive 
    }
        
    
     func toggleTimer() -> Void {
        
         if running {
            //
             buttonOpacity = 100.0
             timer.connect().cancel()
             running = false 
             CurrentLabel = "Start"
             modeColor = .green
         }else
         {
             running = true
             CurrentLabel = "Starting in... \(startLag)"
             //        stopTime =  timer.connect() as! Timer
            runTime = 0
             countDownTime = 0 
             timer = Timer.publish(every: 1, on: .main, in: .common)
             /* so I still have more to learn about timers etc. but it wants to assign cancleable
             now in the examples i have seen, the autoconnect used also starts the timer immmediatly, which I don't want. So for now a warning on an unsed variable, and 
              also not sure how this responds to interuption events since it is on the main thread. Hope the user has the watch on DND. lol */
             timer.connect()
         }
    }
}

struct RunView_Previews: PreviewProvider {
    static var previews: some View {
        RunView(inputTime:60)
    }
}
