//
//  ContentView.swift
//  LinearTimer Watch App
//
//  Created by Jeremyah Payne on 6/18/23.
//

import SwiftUI

struct ContentView: View {
    @State var settingsPresented: Bool = false
    var timeValue:Int
    
    var body: some View {
        VStack {
            HStack{
                Image(systemName:"gear")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .onTapGesture{ settingsPresented.toggle()}
                    .sheet(isPresented: $settingsPresented, content: {SettingsView(settingsPresented:$settingsPresented)}) 

            
                Spacer()
                Image(systemName: "music.mic") // will switch the app icon when I figure that out
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Spacer()
                Spacer()
            }
            NavigationStack {
                List {
                    //Setting the value for each link to pass to the run view in seconds
                    NavigationLink("4 Min", value: 240)
                    NavigationLink("3 Min", value: 180)
                    NavigationLink("2 Min", value: 120)
                    NavigationLink("1 Min", value: 60)
                    //lol, NOT WORKING... ugh. Need to learn about custom views or somehting
                        .multilineTextAlignment(.center)             
                }
                .navigationDestination(for: Int.self) { timeValue in
                    RunView(inputTime: timeValue)
                }
            }//end of Nav Stack
        }// end of VStack
    }//end of Content View
}//end of BOdy 

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( timeValue: 60)
    }
}
