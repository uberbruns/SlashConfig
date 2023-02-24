import XCTest
@testable import SlashConfig


struct Starship {
  var commandingOfficer: String
  var registry: String
  var isActive: Bool
}


extension Starship {
  static let titan = Starship(
    commandingOfficer: "William T. Riker",
    registry: "NCC-80102",
    isActive: false
  )
}


final class SlashConfigTests: XCTestCase {
  func testSlashConfigConfigurationViaDynamicMemberLookup() throws {
    let titanRefit = Starship.titan/
      .commandingOfficer("Liam Shaw")/
      .registry({ $0.appending("-A") })/
      .isActive(true)

    XCTAssertEqual(titanRefit.registry, "NCC-80102-A")
    XCTAssertEqual(titanRefit.commandingOfficer, "Liam Shaw")
    XCTAssertEqual(titanRefit.isActive, true)
  }

  func testSlashConfigConfigurationViaClosureConfiguration() throws {
    let titanRefit = Starship.titan/ {
      $0.commandingOfficer = "Liam Shaw"
      $0.registry = "NCC-80102-A"
      $0.isActive = true
    }

    XCTAssertEqual(titanRefit.registry, "NCC-80102-A")
    XCTAssertEqual(titanRefit.commandingOfficer, "Liam Shaw")
    XCTAssertEqual(titanRefit.isActive, true)
  }

  func testSlashConfigConfigurationMixingTechniques() throws {
    let year = 2397
    let titanRefit = Starship.titan/
      .commandingOfficer("Liam Shaw")/
      .configure({ $0.isActive = year >= 2396 })/
      .registry("NCC-80102-A")

    XCTAssertEqual(titanRefit.registry, "NCC-80102-A")
    XCTAssertEqual(titanRefit.commandingOfficer, "Liam Shaw")
    XCTAssertEqual(titanRefit.isActive, true)
  }
}
