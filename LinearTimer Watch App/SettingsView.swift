//
//  Settings.swift
//  LinearTimer Watch App
//
//  Created by Jeremyah Payne on 6/19/23.
//

import SwiftUI

struct SettingsView: View {
    //Style wise I am thinking of adding a Contants file for String names and literals
    @AppStorage("startLag") var startLag:String = "5"
    @AppStorage("prefinishTime") var prefinish:String = "15"
    @AppStorage("hideFace") var hideFace:Bool = true
    @AppStorage("useSound") var useSound:Bool = true
    
    
    //creating local variables vs the system variables. soon as the systems ones are changed they save. This lets me cancel and only write the locals to the system when the save button is clicked. 
    @State var lcl_startLag:String = "5"
    @State var lcl_prefinish:String = "15"
    @State var lcl_hideFace:Bool = false
    @State var lcl_useSound:Bool = true
    
    
    @Binding var settingsPresented:Bool
    
    var body: some View {
        
        ScrollView{
            VStack {
                
                Spacer(minLength:5)
                HStack {
                    Text("Start Lag")
                    Spacer()
                    TextField( "Start Lag", text: $lcl_startLag)
                    //                    .fixedSize()
                        .frame(width: 40)
                    Text("Sec")
                }
                Spacer(minLength:5)
                HStack {
                    Text("Time to Warn")
                    Spacer(minLength:10)
                    TextField( "Time to Warn", text: $lcl_prefinish)
                        .frame(width: 40)
                    
                    
                    
                    Text("Sec")
                }
                //            Spacer(minLength:5)
                HStack {
                    //                Text("Hide Face")
                    Spacer()
                    Toggle( "Hide Face", isOn: $lcl_hideFace)
                        .accentColor(.accentColor)
                    Spacer(minLength:50)
                    
                }
                Spacer(minLength:15)
                HStack {
                    //                Text("Hide Face")
                    Spacer()
                    Toggle( "Sound", isOn: $lcl_useSound)
                        .accentColor(.accentColor)
                    Spacer(minLength:50)
                    
                }
                Spacer(minLength:20)
                HStack{
                    //                Button("Cancel", action: cancel)
                    Button ("Save", action:save)
                    
                        .accentColor(.accentColor)
                }.frame(maxWidth: 125, maxHeight: 25)
            }//end Vstack
            .onAppear(){
                lcl_startLag = startLag
                lcl_prefinish = prefinish
                lcl_hideFace = hideFace
                lcl_useSound = useSound
            }
        }
    }//end body
        
    
    func cancel() -> Void {
        
    }
    
    func save() -> Void {
        startLag = lcl_startLag
        prefinish = lcl_prefinish
        hideFace = lcl_hideFace
        useSound = lcl_useSound
        
        settingsPresented = false
    }
}//end view struct

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        @State var settingsPresented:Bool = true
        SettingsView(settingsPresented:$settingsPresented)
    }
}
