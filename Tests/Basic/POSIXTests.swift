/*
 This source file is part of the Swift.org open source project

 Copyright 2015 - 2016 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import XCTest

import Basic

class POSIXTests : XCTestCase {

    func testFileStatus() throws {
        let file = try TemporaryFile()
        XCTAssertTrue(exists(file.path))
        XCTAssertTrue(isFile(file.path))
        XCTAssertFalse(isDirectory(file.path))

        let dir = try TemporaryDirectory()
        XCTAssertTrue(exists(dir.path))
        XCTAssertFalse(isFile(dir.path))
        XCTAssertTrue(isDirectory(dir.path))

        let sym = dir.path.appending("hello")
        try createSymlink(sym, pointingAt: file.path)
        XCTAssertTrue(exists(sym))
        XCTAssertFalse(isFile(sym, followSymlink: false))
        XCTAssertTrue(isFile(sym, followSymlink: true))
        XCTAssertFalse(isDirectory(sym, followSymlink: false))
        XCTAssertFalse(isDirectory(sym, followSymlink: true))

        let dir2 = try TemporaryDirectory()
        let dirSym = dir.path.appending("dir2")
        try createSymlink(dirSym, pointingAt: dir2.path)
        XCTAssertTrue(exists(dirSym))
        XCTAssertFalse(isFile(dirSym, followSymlink: false))
        XCTAssertFalse(isFile(dirSym, followSymlink: true))
        XCTAssertFalse(isDirectory(dirSym, followSymlink: false))
        XCTAssertTrue(isDirectory(dirSym, followSymlink: true))
    }
    
    static var allTests = [
        ("testFileStatus", testFileStatus),
    ]
}
