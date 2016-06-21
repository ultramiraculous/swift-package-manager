//
//  ProjectModels.swift
//  SwiftPM
//
//  Created by Chris Williams on 6/20/16.
//
//

import Foundation

class PBXAggregateTarget: PBXTarget {
    let fileRef: PBXReference
    let settings: [String: AnyObject]
    
    init(name: String, dependencies: [PBXTargetDependency], buildPhases: [PBXBuildPhase], buildConfigurations: XCConfigurationList, productName: String, productReference: PBXFileReference, productType: ProductType, fileRef: PBXReference, settings: [String: AnyObject]) {
        self.fileRef = fileRef
        self.settings = settings
        super.init(name: name, dependencies: dependencies, buildPhases: buildPhases, buildConfigurations: buildConfigurations, productName: productName, productReference: productReference, productType: productType)
    }
}

class PBXBuildFile: PBXProjectItem {
    let fileRef: PBXReference
    let settings: [String: AnyObject]
    
    init(fileRef: PBXReference, settings: [String: AnyObject]) {
        self.fileRef = fileRef
        self.settings = settings
    }
}

class PBXBuildPhase: PBXProjectItem {
    let files: [PBXBuildFile]
    
    init (files: [PBXBuildFile]) {
        self.files = files
    }
}

class PBXBuildStyle: PBXProjectItem {
    let name: String
    let buildSettings: [String: AnyObject]
    
    init(name: String, settings: [String: AnyObject]) {
        self.name = name
        self.buildSettings = settings
    }
}

class PBXContainer: PBXObject {
    
}

class PBXContainerItem: PBXObject {
    
}

class PBXContainerItemProxy: PBXContainerItem {
    enum ProxyType: UInt {
        case targetReference = 1
    }
    
    let containerPortal: PBXFileReference
    let remoteGlobalIDString: String
    let proxyType: ProxyType
    
    init(containerPortal: PBXFileReference, remoteGlobalIDString: String, proxyType: ProxyType = .targetReference) {
        self.containerPortal = containerPortal
        self.remoteGlobalIDString = remoteGlobalIDString
        self.proxyType = proxyType
    }
}

class PBXCopyFilesBuildPhase: PBXBuildPhase {
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
    
    let dstSubfolderSpec: CopyFilesDestination
    
    init(files: [PBXBuildFile], destination: CopyFilesDestination) {
        self.dstSubfolderSpec = destination
        super.init(files: files)
    }
}

class PBXFileReference: PBXReference {
    let explicitFileType: String?
    let lastKnownFileType: String?
    
    init(sourceTreeRoot: SourceTreeRoot, explicitFileType: String? = nil, lastKnownFileType: String? = nil) {
        self.explicitFileType = explicitFileType
        self.lastKnownFileType = lastKnownFileType
        super.init(sourceTreeRoot: sourceTreeRoot)
    }
}

class PBXFrameworksBuildPhase: PBXBuildPhase {
    
}

class PBXGroup: PBXReference {
    let children: [PBXReference]
    
    init(sourceTreeRoot: SourceTreeRoot, children: [PBXFileReference]) {
        self.children = children
        super.init(sourceTreeRoot: sourceTreeRoot)
    }
}

class PBXHeadersBuildPhase: PBXBuildPhase {
    
}

class PBXNativeTarget: PBXTarget {
    
}

typealias GID = String
class PBXObject {
    let gid: GID = ""
    let isa: String = ""
    // Stable hash
}

class PBXProject: PBXContainer {
    let name: String
    let mainGroup: PBXGroup
    let targets: [PBXTarget]
    let buildConfigurationList: XCConfigurationList
    let compatibilityVersion: String = "Xcode 3.2"
    
    init(name: String, mainGroup: PBXGroup, targets: [PBXTarget], buildConfigurations: XCConfigurationList) {
        self.name = name
        self.mainGroup = mainGroup
        self.targets = targets
        self.buildConfigurationList = buildConfigurations
    }
}

class PBXProjectItem: PBXContainerItem {
    
}

class PBXReference: PBXContainerItem {
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
    
    let sourceTree: SourceTreeRoot
    
    init(sourceTreeRoot: SourceTreeRoot) {
        self.sourceTree = sourceTreeRoot
    }
}

class PBXResourcesBuildPhase: PBXBuildPhase {
    
}

class PBXShellScriptBuildPhase: PBXBuildPhase {
    let inputPaths: [String]
    let outputPaths: [String]
    let shellPath: String?
    let shellScript: String?
    
    init(files: [PBXBuildFile], inputPaths: [String], outputPaths: [String], shellPath: String?, shellScript: String?) {
        self.inputPaths = inputPaths
        self.outputPaths = outputPaths
        self.shellPath = shellPath
        self.shellScript = shellScript
        super.init(files: files)
    }
}

class PBXSourcesBuildPhase: PBXBuildPhase {
    
}

class PBXTarget: PBXProjectItem {
    enum ProductType: String {
        case staticLibrary = "com.apple.product-type.library.static"
        case dynamicLibrary = "com.apple.product-type.library.dynamic"
        case tool = "com.apple.product-type.tool"
        case bundle = "com.apple.product-type.bundle"
        case framework = "com.apple.product-type.framework"
        case staticFramework = "com.apple.product-type.framework.static"
        case application = "com.apple.product-type.application"
        case watchApplication = "com.apple.product-type.application.watchapp2"
        case unitTest =  "com.apple.product-type.bundle.unit-test"
        case appExtension =  "com.apple.product-type.app-extension"
    }
    
    let name: String
    let dependencies: [PBXTargetDependency]
    let buildPhases: [PBXBuildPhase]
    let buildConfigurationList: XCConfigurationList
    let productName: String
    let productReference: PBXFileReference
    let productType: ProductType
    
    init(name: String, dependencies: [PBXTargetDependency], buildPhases: [PBXBuildPhase], buildConfigurations: XCConfigurationList, productName: String, productReference: PBXFileReference, productType: ProductType) {
        self.name = name
        self.dependencies = dependencies
        self.buildPhases = buildPhases
        self.buildConfigurationList = buildConfigurations
        self.productName = productName
        self.productReference = productReference
        self.productType = productType
    }
}

class PBXTargetDependency: PBXProjectItem {
    let targetProxy: PBXContainerItemProxy
    
    init(targetProxy: PBXContainerItemProxy) {
        self.targetProxy = targetProxy
    }
}

class PBXVariantGroup: PBXGroup {
    
}

class SourceTreePath {
    let sourceTree: PBXReference.SourceTreeRoot
    let path: String
    let defaultType: String?
    
    init(path: String) {
        self.sourceTree = .absolute
        self.path = path
        self.defaultType = ""
    }
}

class XCBuildConfiguration: PBXBuildStyle {
    let baseConfigurationReference: PBXFileReference
    
    init(name: String, settings: [String: AnyObject], baseConfigurationReference: PBXFileReference) {
        self.baseConfigurationReference = baseConfigurationReference
        super.init(name: name, settings: settings)
    }
}

class XCConfigurationList: PBXProjectItem {
    let buildConfigurations: [XCBuildConfiguration]
    let defaultConfigurationName: String?
    let defaultConfigurationIsVisible: Bool
    
    init(buildConfigurations: [XCBuildConfiguration], defaultConfigurationName: String?, defaultConfigurationIsVisible: Bool) {
        self.buildConfigurations = buildConfigurations
        self.defaultConfigurationName = defaultConfigurationName
        self.defaultConfigurationIsVisible = defaultConfigurationIsVisible
    }
}

class XCVersionGroup: PBXReference {
    let currentVersion: PBXFileReference?
    let children: [PBXFileReference]
    
    init(sourceTreeRoot: SourceTreeRoot, children: [PBXFileReference], currentVersion: PBXFileReference? = nil) {
        self.children = children
        self.currentVersion = currentVersion
        super.init(sourceTreeRoot: sourceTreeRoot)
    }
}

