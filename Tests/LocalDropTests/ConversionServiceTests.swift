import XCTest
@testable import LocalDrop

final class ConversionServiceTests: XCTestCase {
    func testSuggestedFormatsExcludeSourceFormat() {
        let formats = ConversionService.suggestedExtensions(for: URL(fileURLWithPath: "/tmp/photo.jpeg"))
        XCTAssertFalse(formats.contains("jpg"))
        XCTAssertTrue(formats.contains("png"))
    }

    func testUnsupportedInputHasNoSuggestions() {
        XCTAssertEqual(ConversionService.suggestedExtensions(for: URL(fileURLWithPath: "/tmp/archive.zip")), [])
    }
}
