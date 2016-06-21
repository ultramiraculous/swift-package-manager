//
//  XCScheme.swift
//  SwiftPM
//
//  Created by Chris Williams on 6/20/16.
//
//

import Foundation

struct XCScheme {
    let name: String
    let buildAction: BuildAction?
    let testAction: TestAction?
    let launchAction: LaunchAction?
    let profileAction: ProfileAction?
    let analyzeAction: AnalyzeAction?
    let archiveAction: ArchiveAction?
}

struct BuildableReference {
    let containerRelativePath: String
    let blueprintIdentifier: String
    let buildableName: String
    let blueprintName: String
}

struct BuildAction {
    let buildActionEntries: [BuildActionEntry]
    let parallelizeBuild: Bool
}

struct BuildActionEntry {
    struct BuildFor: OptionSet {
        let rawValue: UInt
        static let running = BuildFor(rawValue: 0)
        static let testing = BuildFor(rawValue: 2)
        static let profiling = BuildFor(rawValue: 4)
        static let archiving = BuildFor(rawValue: 8)
        static let analyzing = BuildFor(rawValue: 16)
    }
    
    let buildableReference: BuildableReference
    let buildFor: BuildFor
}

struct LaunchAction {
    enum LaunchStyle {
        /**
         * Starts the process with attached debugger.
         */
        case Auto
        
        /**
         * Debugger waits for executable to be launched.
         */
        case Wait
    }
    
    let buildableReference: BuildableReference
    let buildConfiguration: String
    let runnablePath: String?
    let remoteRunnablePath: String?
    let launchStyle: LaunchStyle
}

struct ProfileAction {
    let buildableReference: BuildableReference
    let buildConfiguration: String
}

struct TestAction {
    let testables: [TestableReference]
    let buildConfiguration: String
}

struct TestableReference {
    let buildableReference: BuildableReference
}

struct AnalyzeAction {
    let buildConfiguration: String
}

struct ArchiveAction {
    let buildConfiguration: String
}
