//
//  SettingsView.swift
//  JellyfishSaver
//
//  Created by Eskil Gjerde Sviggum on 01/12/2023.
//

import SwiftUI
import os.log

struct SettingsView: View {
    let store: Store
    
    var completionHandler: () -> Void
    
    @Environment(\.dismiss)
    var dismiss
    
    @State
    var sections: Float = 0 
    
    @State
    var iterations: Float = 0
    
    @State
    var angularSeparation: Float = 0
    
    var maxAngularSeparation: Float {
        2 * .pi / iterations
    }
    
    let sectionsFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = 1
        formatter.maximum = 10
        return formatter
    }()
    
    let iterationsFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = 1
        formatter.maximum = 15
        return formatter
    }()
    
    let angularSeparationFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = 0
        formatter.maximum = NSNumber(value: 2 * Float.pi)
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text("Jellyfish Saver Preferences")
                .font(.title)
                .bold()
                .padding(.horizontal)
            
            Divider()
            
            VStack {
                HStack {
                    Text("Sections")
                    TextField("Sections", value: $sections, formatter: sectionsFormatter)
                    Stepper("", value: $sections, in: 1...10)
                }
                
                HStack {
                    Text("Iterations")
                    TextField("Iterations", value: $iterations, formatter: iterationsFormatter)
                    Stepper("", value: $iterations, in: 1...15)
                }
                
                HStack {
                    let _ = angularSeparationFormatter.maximum = NSNumber(value: maxAngularSeparation)
                    
                    Text("Angular separation")
                    TextField("Angular separation", value: $angularSeparation, formatter: angularSeparationFormatter)
                    Stepper("", value: $angularSeparation, in: 0...maxAngularSeparation, step: 0.05)
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            HStack {
                
                Button {
                    store.resetValues()
                    updatePropertiesFromStore()
                } label: {
                    Text("Reset")
                }
                .buttonStyle(BorderedButtonStyle())
                
                Spacer()
                
                Button {
                    NSApp.keyWindow.map { NSApp.endSheet($0) }
                    completionHandler()
                } label: {
                    Text("Done")
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
            .padding(.horizontal)
            
        }
        .padding(.vertical)
        .frame(minWidth: 300)
        .onAppear {
            updatePropertiesFromStore()
        }
        .onChange(of: sections) { _, newValue in
            os_log("Update Sections: %f", newValue)
            store.sections = newValue
        }
        .onChange(of: iterations) { _, newValue in
            store.iterations = newValue
        }
        .onChange(of: angularSeparation) { _, newValue in
            store.angularSeparation = newValue
        }
    }
    
    func updatePropertiesFromStore() {
        os_log("Update props settingsview: %f", store.sections)
        self.sections = store.sections
        self.iterations = store.iterations
        self.angularSeparation = store.angularSeparation
    }
}
