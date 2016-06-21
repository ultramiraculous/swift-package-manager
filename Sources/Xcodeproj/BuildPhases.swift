//
//  BuildPhase.swift
//  SwiftPM
//
//  Created by Chris Williams on 6/15/16.
//  Copyright © 2016 Fitbit. All rights reserved.
//

import Foundation
/*

protocol PBXBuildPhase: PBXObject {
    var files: [PBXBuildFile] { get }
}


// {ATTRIBUTES = (CodeSignOnCopy, )
// settings = {COMPILER_FLAGS = adsfas; }; };
struct PBXBuildFile: PBXObject {
    let fileRef: PBXReference
    let settings: [String: String]
}

struct PBXFrameworksBuildPhase: PBXBuildPhase {
    let files: [PBXBuildFile]
}

/**
 * Lists the files to be copied into the output resources directory for the containing
 * {@link PBXTarget}. Has no effect in library rules.
 *
 * A target should contain at most one of this build phase.
 */
struct PBXResourcesBuildPhase: PBXBuildPhase {
    let files: [PBXBuildFile]
}

/**
 * Lists the files to be compiled for the containing {@link PBXTarget}.
 *
 * A target should contain at most one of this build phase.
 */
struct PBXSourcesBuildPhase: PBXBuildPhase {
    let files: [PBXBuildFile]
}

/**
 * Build phase that copies header files into the output headers directory. Does nothing for binary
 * and test rules.
 */
struct PBXHeadersBuildPhase: PBXBuildPhase {
    let files: [PBXBuildFile]
}

struct PBXCopyFilesBuildPhase: PBXBuildPhase {
    enum CopyFilesDestination: UInt {
        case absolute = 0
        case wrapper = 1
        case executables = 6
        case resources = 7
        case frameworks = 10
        case sharedFrameworks = 11
        case sharedSupport = 12
        case plugins = 13
        case javaResources = 15
        case products = 16
    }
    
    let files: [PBXBuildFile]
    let dstPath: String
    let dstSubfolderSpec: CopyFilesDestination
}

*/
