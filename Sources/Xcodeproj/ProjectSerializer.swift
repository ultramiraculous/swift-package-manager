//
//  ProjectSerializer.swift
//  SwiftPM
//
//  Created by Chris Williams on 6/15/16.
//
//

import Foundation
import PackageModel
import Utility

class PBXRoot: PBXObject {
    let archiveVersion: String
    let classes: [String: String]
    let objectVersion: String
    let objects: [PBXObject]
    let rootObject: GID
    
    init(archiveVersion: String, classes: [String: String], objectVersion: String, objects: [PBXObject], rootObject: GID) {
        self.archiveVersion = archiveVersion
        self.classes = classes
        self.objectVersion = objectVersion
        self.objects = objects
        self.rootObject = rootObject
    }
}

extension PBXFileReference {

    convenience init(relativePath: String) {
        super.init(sourceTree: .sourceRoot,
                  name: Path(relativePath).components.last!,
                  path: relativePath,
                  explicitFileType: nil,
                  lastKnownFileType: nil)
    }
    
}

func directoryStructure(relativePaths: String) {
    
    
}

extension PBXProject {
    
    init(module: XcodeModuleProtocol) {
        
        let fileReferences = module.sources.relativePaths.map(PBXFileReference.init(relativePath:))
        
        
        
        
        
    }
    
}

extension PBXFileReference {
    func forSources(source: Sources) -> PBXFileReference {
        
    }
}



func things(relativePath: String) -> ([PBXGroup], PBXFileReference) {
    
}


struct Project {
    
}

/// Loop through and keep track of GIDs


public func generator(dstdir: String, projectName: String, srcroot: String, modules: [XcodeModuleProtocol], externalModules: [XcodeModuleProtocol], products: [Product], options: XcodeprojOptions) throws {
    
    externalModules.first?.nativeTargetDependencies
    
    
    
//    var projectPathForModule = [String: String]()
//    func createProjectForModule(.odule: XcodeModuleProtocol) {
//        
//        
////        return projectPathForModule[module]
//    }
//    
//    
//    let project = PBXProject(name: projectName, mainGroup: PBXGroup(children: []), targets: [], compatibilityVersion: "46")
    
}





