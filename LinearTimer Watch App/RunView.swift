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
    //monitor if the time is running or not to determine the button state
    @State var running:Bool = false
    @StateObject var timeVM:TimerVM  = TimerVM()
    
    var body: some View {
        
        //FYI, in Swift UI .XYZ following an object essentialy appends functinality
        Button(timeVM.CurrentLabel, action:toggleTimer )
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .foregroundColor(timeVM.modeColor
            )
            .opacity(timeVM.buttonOpacity)
    }
    
    func toggleTimer() -> Void {
        
        if running {
            //
            running = false 
            timeVM.stopTimer()
        }else
        {
            timeVM.resetTimer(input:inputTime)
            running = true
            
        }
    }//end toggletimw 
    
    func onDisappear() {
        print("Good Bye")
        timeVM.stopTimer()
    }
}//end struct runview 

struct RunView_Previews: PreviewProvider {
    static var previews: some View {
        RunView(inputTime:60)
    }
}
