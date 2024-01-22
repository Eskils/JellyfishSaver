//
//  Store.swift
//  JellyfishSaver
//
//  Created by Eskil Gjerde Sviggum on 01/12/2023.
//

import ScreenSaver

protocol StoreDelegate: NSObject {
    func storeDidUpdate()
}

class Settings: Codable {
    var sections: Float? {
        didSet {
            try? save()
        }
    }
    var iterations: Float? {
        didSet {
            try? save()
        }
    }
    var angularSeparation: Float? {
        didSet {
            try? save()
        }
    }
    
    private init(sections: Float? = nil, iterations: Float? = nil, angularSeparation: Float? = nil) {
        self.sections = sections
        self.iterations = iterations
        self.angularSeparation = angularSeparation
    }
    
    private static var filename = "JellyfishSaverSettings.json"
    
    
    private func save() throws {
        let data = try JSONEncoder().encode(self)
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "URL does not exist", code: -1)
        }
        let url = documentDirectoryURL.appending(path: Self.filename)
        try data.write(to: url)
    }
    
    static func get() -> Self? {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let url = documentDirectoryURL.appending(path: Self.filename)
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? JSONDecoder().decode(Self.self, from: data)
    }
    
    static func delete() throws {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let url = documentDirectoryURL.appending(path: Self.filename)
        
        if FileManager.default.fileExists(atPath: url.path()) {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    static func getOrMake() -> Settings {
        return Self.get() ?? Settings()
    }
}

class Store: NSObject, StoreDelegate {
    
    weak var delegate: StoreDelegate?
    
    private static let defaultSections: Float = 3
    private static let defaultIterations: Float = 10
    private static let defaultAngularSeparation: Float = 0.25
    
    static var shared = Store()
    
    private var settings = Settings.getOrMake()
    
    private override init() {
        super.init()
    }
    
    private func getFloat(named keyPath: KeyPath<Settings, Float?>) -> Float? {
        settings = Settings.getOrMake()
        return settings[keyPath: keyPath]
    }
    
    var sections: Float {
        get {
            getFloat(named: \.sections) ?? Self.defaultSections
        }
        set(value) {
            settings.sections = value
            didUpdate()
        }
    }
    
    var iterations: Float {
        get {
            getFloat(named: \.iterations) ?? Self.defaultIterations
        }
        set(value) {
            settings.iterations = value
            didUpdate()
        }
    }
    
    var angularSeparation: Float {
        get {
            getFloat(named: \.angularSeparation) ?? Self.defaultAngularSeparation
        }
        set(value) {
            settings.angularSeparation = value
            didUpdate()
        }
    }
    
    func resetValues() {
        do {
            try Settings.delete()
            settings = Settings.getOrMake()
        } catch {
            print("Could not reset values")
        }
        didUpdate()
    }
    
    func didUpdate() {
        storeDidUpdate()
    }
    
    func storeDidUpdate() {
        delegate?.storeDidUpdate()
    }
    
    
}
