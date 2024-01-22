//
//  DisplayLinkHandler.swift
//  EquationGraphics
//
//  Created by Eskil Gjerde Sviggum on 28/11/2023.
//

import Foundation
import QuartzCore

public class DisplayLinkHandler: NSObject {
    
    public typealias Handler = (DisplayLinkHandler, Double) -> Void
    
    private var startTimestamp: TimeInterval = 0
    private var displayLink: CVDisplayLink?
    private let handler: Handler
    
    public init(handler: @escaping Handler) {
        self.handler = handler
        super.init()
    }
    
    @discardableResult
    public func start() -> Self? {
        guard
            CVDisplayLinkCreateWithCGDisplay(CGMainDisplayID(), &displayLink) == kCVReturnSuccess,
            let displayLink,
            CVDisplayLinkSetOutputHandler(displayLink, didUpdateDisplay(link:inNow:inOut:flagsIn:flagsOut:)) == kCVReturnSuccess,
            CVDisplayLinkStart(displayLink) == kCVReturnSuccess
        else {
            return nil
        }
        
        return self
    }
    
    public func stop() {
        _ = displayLink.map { CVDisplayLinkStop($0) }
        displayLink = nil
    }
    
    @Sendable
    private func didUpdateDisplay(link: CVDisplayLink, inNow: UnsafePointer<CVTimeStamp>, inOut: UnsafePointer<CVTimeStamp>, flagsIn: CVOptionFlags, flagsOut: UnsafeMutablePointer<CVOptionFlags>) -> CVReturn {
        
        let deltaTime = displayLink.map { CVDisplayLinkGetActualOutputVideoRefreshPeriod($0) } ?? 0

        let delta = startTimestamp + deltaTime
        handler(self, delta)
        startTimestamp = delta
        
        return kCVReturnSuccess
    }
    
}
