//
//  JellyfishSaverView.swift
//  JellyfishSaver
//
//  Created by Eskil Gjerde Sviggum on 01/12/2023.
//

import ScreenSaver
import SwiftUI
import os.log

class JellyfishSaverView: ScreenSaverView {
    
    let contentView = ContentView.shared
    let store = Store.shared
    var hasDrawnOnMainScreen = false
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
        self.animationTimeInterval = 1 / 30
        store.delegate = self
    }
    
    required convenience init?(coder: NSCoder) {
        let frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        self.init(frame: frame, isPreview: false)
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        if hasDrawnOnMainScreen {
            return
        }
        
        hasDrawnOnMainScreen = true
        let view = NSHostingView(rootView: contentView)
        
        view.frame = rect
        self.addSubview(view)
    }
    
    override var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        let settingsView = SettingsView(store: store, completionHandler: didUpdateDefaults)
        return NSWindow(contentViewController: NSHostingController(rootView: settingsView))
    }
    
    private func didUpdateDefaults() {
        os_log("Did update defaults")
        
        hasDrawnOnMainScreen = false
        
        self.subviews.forEach {
            $0.removeFromSuperviewWithoutNeedingDisplay()
            self.setNeedsDisplay($0.frame)
        }
    }
    
}

extension JellyfishSaverView: StoreDelegate {
    func storeDidUpdate() {
        didUpdateDefaults()
        contentView.updatePropertiesFromStore()
    }
}
