/*
 This source file is part of the Swift.org open source project

 Copyright 2016 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import XCTest

import Basic
import SourceControl
import Utility

@testable import class SourceControl.GitRepository

// FIXME: Move to Utilities.
func XCTAssertThrows<T where T: Swift.Error, T: Equatable>(_ expectedError: T, file: StaticString = #file, line: UInt = #line, _ body: () throws -> ()) {
    do {
        try body()
        XCTFail("body completed successfully", file: file, line: line)
    } catch let error as T {
        XCTAssertEqual(error, expectedError, file: file, line: line)
    } catch {
        XCTFail("unexpected error thrown", file: file, line: line)
    }
}

class GitRepositoryTests: XCTestCase {
    /// Test the basic provider functions.
    func testProvider() throws {
        mktmpdir { path in
            let testRepoPath = path.appending("test-repo")
            try! makeDirectories(testRepoPath)
            initGitRepo(testRepoPath, tag: "1.2.3")

            // Test the provider.
            let testCheckoutPath = path.appending("checkout")
            let provider = GitRepositoryProvider()
            let repoSpec = RepositorySpecifier(url: testRepoPath.asString)
            try! provider.fetch(repository: repoSpec, to: testCheckoutPath)

            // Verify the checkout was made.
            XCTAssert(testCheckoutPath.asString.exists)

            // Test the repository interface.
            let repository = provider.open(repository: repoSpec, at: testCheckoutPath)
            let tags = repository.tags
            XCTAssertEqual(repository.tags, ["1.2.3"])

            let revision = try repository.resolveRevision(tag: tags.first ?? "<invalid>")
            // FIXME: It would be nice if we had a deterministic hash here...
            XCTAssertEqual(revision.identifier, try Git.runPopen([Git.tool, "-C", testRepoPath.asString, "rev-parse", "--verify", "1.2.3"]).chomp())
            if let revision = try? repository.resolveRevision(tag: "<invalid>") {
                XCTFail("unexpected resolution of invalid tag to \(revision)")
            }
        }
    }

    /// Check hash validation.
    func testGitRepositoryHash() throws {
        let validHash = "0123456789012345678901234567890123456789"
        XCTAssertNotEqual(GitRepository.Hash(validHash), nil)
        
        let invalidHexHash = validHash + "1"
        XCTAssertEqual(GitRepository.Hash(invalidHexHash), nil)
        
        let invalidNonHexHash = "012345678901234567890123456789012345678!"
        XCTAssertEqual(GitRepository.Hash(invalidNonHexHash), nil)
    }
    
    /// Check raw repository facilities.
    ///
    /// In order to be stable, this test uses a static test git repository in
    /// `Inputs`, which has known commit hashes. See the `construct.sh` script
    /// contained within it for more information.
    func testRawRepository() throws {
        mktmpdir { path in
            // Unarchive the static test repository.
            let inputArchivePath = AbsolutePath(#file).parentDirectory.appending(components: "Inputs", "TestRepo.tgz")
            try systemQuietly(["tar", "-x", "-v", "-C", path.asString, "-f", inputArchivePath.asString])
            let testRepoPath = path.appending("TestRepo")

            // Check hash resolution.
            let repo = GitRepository(path: testRepoPath)
            XCTAssertEqual(try repo.resolveHash(treeish: "1.0", type: "commit"),
                           try repo.resolveHash(treeish: "master"))

            // Get the initial commit.
            let initialCommitHash = try repo.resolveHash(treeish: "a8b9fcb")
            XCTAssertEqual(initialCommitHash, GitRepository.Hash("a8b9fcbf893b3b02c0196609059ebae37aeb7f0b"))

            // Check commit loading.
            let initialCommit = try repo.read(commit: initialCommitHash)
            XCTAssertEqual(initialCommit.hash, initialCommitHash)
            XCTAssertEqual(initialCommit.tree, GitRepository.Hash("9d463c3b538619448c5d2ecac379e92f075a8976"))

            // Check tree loading.
            let initialTree = try repo.read(tree: initialCommit.tree)
            XCTAssertEqual(initialTree.hash, initialCommit.tree)
            XCTAssertEqual(initialTree.contents.count, 1)
            guard let readmeEntry = initialTree.contents.first else { return XCTFail() }
            XCTAssertEqual(readmeEntry.hash, GitRepository.Hash("92513075b3491a54c45a880be25150d92388e7bc"))
            XCTAssertEqual(readmeEntry.type, .blob)
            XCTAssertEqual(readmeEntry.name, "README.txt")

            // Check loading of odd names.
            //
            // This is a commit which has a subdirectory 'funny-names' with
            // paths with special characters.
            let funnyNamesCommit = try repo.read(commit: repo.resolveHash(treeish: "a7b19a7"))
            let funnyNamesRoot = try repo.read(tree: funnyNamesCommit.tree)
            XCTAssertEqual(funnyNamesRoot.contents.map{ $0.name }, ["README.txt", "funny-names", "subdir"])
            guard funnyNamesRoot.contents.count == 3 else { return XCTFail() }

            // FIXME: This isn't yet supported.
            let funnyNamesSubdirEntry = funnyNamesRoot.contents[1]
            XCTAssertEqual(funnyNamesSubdirEntry.type, .tree)
            if let _ = try? repo.read(tree: funnyNamesSubdirEntry.hash) {
                XCTFail("unexpected success reading tree with funny names")
            }
       }
    }

    /// Test the Git file system view.
    func testGitFileView() throws {
        mktmpdir { path in
            let testRepoPath = path.appending(component: "test-repo")
            try makeDirectories(testRepoPath)
            initGitRepo(testRepoPath)

            // Add a couple files and a directory.
            let test1FileContents: ByteString = "Hello, world!"
            let test2FileContents: ByteString = "Hello, happy world!"
            try localFileSystem.writeFileContents(testRepoPath.appending(component: "test-file-1.txt"), bytes: test1FileContents)
            try localFileSystem.createDirectory(testRepoPath.appending(component: "subdir"))
            try localFileSystem.writeFileContents(testRepoPath.appending(components: "subdir", "test-file-2.txt"), bytes: test2FileContents)
            try systemQuietly([Git.tool, "-C", testRepoPath.asString, "add", "test-file-1.txt", "subdir/test-file-2.txt"])
            try systemQuietly([Git.tool, "-C", testRepoPath.asString, "commit", "-m", "Add some files."])
            try tagGitRepo(testRepoPath, tag: "test-tag")

            // Get the the repository via the provider. the provider.
            let testCheckoutPath = path.appending("checkout")
            let provider = GitRepositoryProvider()
            let repoSpec = RepositorySpecifier(url: testRepoPath.asString)
            try provider.fetch(repository: repoSpec, to: testCheckoutPath)
            let repository = provider.open(repository: repoSpec, at: testCheckoutPath)

            // Get and test the file system view.
            let view = try repository.openFileView(revision: repository.resolveRevision(tag: "test-tag"))

            // Check basic predicates.
            XCTAssert(view.isDirectory("/"))
            XCTAssert(view.isDirectory("/subdir"))
            XCTAssert(!view.isDirectory("/does-not-exist"))
            XCTAssert(view.exists("/test-file-1.txt"))
            XCTAssert(!view.exists("/does-not-exist"))
            XCTAssert(view.isFile("/test-file-1.txt"))
            XCTAssert(!view.isSymlink("/test-file-1.txt"))

            // Check read of a directory.
            XCTAssertEqual(try view.getDirectoryContents("/").sorted(), ["file.swift", "subdir", "test-file-1.txt"])
            XCTAssertEqual(try view.getDirectoryContents("/subdir").sorted(), ["test-file-2.txt"])
            XCTAssertThrows(FileSystemError.isDirectory) {
                _ = try view.readFileContents("/subdir")
            }

            // Check read versus root.
            XCTAssertThrows(FileSystemError.isDirectory) {
                _ = try view.readFileContents("/")
            }

            // Check read through a non-directory.
            XCTAssertThrows(FileSystemError.notDirectory) {
                _ = try view.getDirectoryContents("/test-file-1.txt")
            }
            XCTAssertThrows(FileSystemError.notDirectory) {
                _ = try view.readFileContents("/test-file-1.txt/thing")
            }
            
            // Check read/write into a missing directory.
            XCTAssertThrows(FileSystemError.noEntry) {
                _ = try view.getDirectoryContents("/does-not-exist")
            }
            XCTAssertThrows(FileSystemError.noEntry) {
                _ = try view.readFileContents("/does/not/exist")
            }

            // Check read of a file.
            XCTAssertEqual(try view.readFileContents("/test-file-1.txt"), test1FileContents)
            XCTAssertEqual(try view.readFileContents("/subdir/test-file-2.txt"), test2FileContents)
        }
    }

    static var allTests = [
        ("testProvider", testProvider),
        ("testGitRepositoryHash", testGitRepositoryHash),
        ("testRawRepository", testRawRepository),
        ("testGitFileView", testGitFileView),
    ]
}
