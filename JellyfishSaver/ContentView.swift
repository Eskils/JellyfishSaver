//
//  ContentView.swift
//  EquationGraphics
//
//  Created by Eskil Gjerde Sviggum on 27/11/2023.
//

import SwiftUI
import os.log

struct ContentView: View {
    
    private init(store: Store) {
        self._store = State(wrappedValue: store)
    }
    
    static var shared = ContentView(store: .shared)
    
    @State
    var store: Store
    
    @State
    var t: Float = 0
    
    @State
    var sections: Float = 5
    
    @State
    var iterations: Float = 10
    
    @State
    var angularSeparation: Float = 0.3
    
    let metalLibraryURL = Bundle(for: JellyfishSaverView.self).url(forResource: "default", withExtension: "metallib")
    
    var body: some View {
        VStack {
            ZStack {
                if let metalLibraryURL {
                    Rectangle()
                        .visualEffect { content, geometryProxy in
                            content.layerEffect(ShaderLibrary(url: metalLibraryURL).shadeFunction(
                                .float2(geometryProxy.size.width, geometryProxy.size.height),
                                .float(t),
                                .float(sections),
                                .float(iterations),
                                .float(angularSeparation)
                            ), maxSampleOffset: .zero)
                        }
                        .background(Color.red)
                }
            }
        }
        .onAppear(perform: {
            updatePropertiesFromStore()
            
            DisplayLinkHandler { _, t in
                self.t = Float(t)
            }.start()
        })
    }
    
    func updatePropertiesFromStore() {
        self.sections = store.sections
        self.iterations = store.iterations
        self.angularSeparation = store.angularSeparation
        os_log("Did update props from store %f %f %f", self.sections, self.iterations, self.angularSeparation)
    }
}

#Preview {
    ContentView.shared
}
