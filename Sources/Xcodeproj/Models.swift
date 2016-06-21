//
//  Models.swift
//  SwiftPM
//
//  Created by Chris Williams on 6/15/16.
//
//

import Foundation

protocol PBXObject  {
    
    var isa: String { get }
    var gid: String { get }
    
}

protocol PBXContainer {
    
}

struct PBXProject: PBXObject {
    let name: String
    let mainGroup: PBXGroup
    let targets: [PBXTarget]
    let compatibilityVersion: String
}

struct PBXTarget: PBXObject {
    
}

struct XCConfigurationList: PBXObject {
    
}

struct PBXGroup: PBXReference {
    enum SourceTreeRoot: String {
        /**
         * Relative to the path of the group containing this.
         */
        case group = "<group>"
        
        /**
         * Absolute system path.
         */
        case absolute = "<absolute>"
        
        /**
         * Relative to the build setting {@code BUILT_PRODUCTS_DIR}.
         */
        case builtProductsDirectory = "BUILT_PRODUCTS_DIR"
        
        /**
         * Relative to the build setting {@code PLATFORM_DIR}.
         */
        case platformDirectory = "PLATFORM_DIR"
        
        /**
         * Relative to the build setting {@code SDKROOT}.
         */
        case sdkRoot = "SDKROOT"
        
        /**
         * Relative to the directory containing the project file {@code SOURCE_ROOT}.
         */
        case sourceRoot = "SOURCE_ROOT"
        
        /**
         * Relative to the Developer content directory inside the Xcode application
         * (e.g. {@code /Applications/Xcode.app/Contents/Developer}).
         */
        case developerDirectory = "DEVELOPER_DIR"
    }
    
    let children: [PBXReference]
    
}

struct PBXReference: PBXObject {
    let sourceTree: SourceTreeRoot
    let name: String
    let path: String
}

struct PBXFileReference: PBXObject {
    let sourceTree: SourceTreeRoot
    let name: String
    let path: String
    let explicitFileType: String?
    let lastKnownFileType: String?
}


struct PBXShellScriptBuildPhase: PBXObject {
    let shellPath = "/bin/sh"
    let shellScript = ""
}

typealias GID = String

extension PBXObject {
    
    var isa: String {
        get {
            return String(self.dynamicType)
        }
    }
    
    var gid: GID {
        get {
            return "\(isa.hash)\(isa.hash)\(isa.hash)"
        }
    }
    
    func printOut() {
        let mirror = Mirror(reflecting: self)
        
        for attr in mirror.children {
            print(attr.label)
            print(attr.value)
        }
        
    }
    
}


class Thing: NSCoding {
    
    init?(coder aDecoder: NSCoder) {
        
    }
    
    func encode(with aCoder: NSCoder) {
        let mirror = Mirror(reflecting: self)
        for attr in mirror.children {
            guard let label = attr.label, let value = attr.value else { continue }
            print(label)
            print(value)
            switch value {
            case let bool as Bool: aCoder.encode(bool, forKey: label)
            case let int as Int: aCoder.encode(Int, forKey: label)
            case let object as AnyObject: aCoder.encode(object, forKey: label)
            }
        }
    }
    
}

