import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(KeychainWrapperTests.allTests),
    ]
}
#endif
