import XCTest
import RxSwift
@testable import Vehicles

class PersistenceManagerTests: XCTestCase {
    
    let persistenceManager = UserDocumentsPersistenceManager(networkService: NetworkEmitsNothing())
    
    func testSave() throws {
        persistenceManager.deleteAll()
        XCTAssertTrue(persistenceManager.save(try saveSampleVehicles()))
    }
    
    func testFetch() throws {
        persistenceManager.deleteAll()
        let vehicles = try saveSampleVehicles()
        let fetchedVehicles = persistenceManager.fetch()
            .sorted(by: { $0.name < $1.name })
        XCTAssertEqual(fetchedVehicles.count, 3)
        XCTAssertEqual(fetchedVehicles, vehicles)
    }
    
    func testDelete() throws {
        persistenceManager.deleteAll()
        let vehicles = try saveSampleVehicles()
        let success = persistenceManager.delete(vehicles[0])
        XCTAssertTrue(success)
        let fetchedVehicles = persistenceManager.fetch()
            .sorted(by: { $0.name < $1.name })
        XCTAssertEqual(fetchedVehicles.count, 2)
    }
    
    func testDeleteFail() throws {
        persistenceManager.deleteAll()
        let jsonString = """
                {
                  "address": "Lesserstraße 170, 22049 Hamburg",
                  "coordinates": [
                    10.07526,
                    53.59301,
                    0
                  ],
                  "engineType": "CE",
                  "exterior": "UNACCEPTABLE",
                  "fuel": 42,
                  "interior": "UNACCEPTABLE",
                  "name": "HH-GO8522",
                  "vin": "WME4513341K565439"
                }
            """
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Unable to convert test json string to data.")
            return
        }
        let vehicle = try JSONDecoder().decode(Vehicle.self, from: data)
        XCTAssertFalse(persistenceManager.delete(vehicle))
    }
    
    func testDeleteAll() throws {
        persistenceManager.deleteAll()
        try saveSampleVehicles()
        XCTAssertTrue(persistenceManager.deleteAll())
    }
    
    @discardableResult
    func saveSampleVehicles() throws -> [Vehicle] {
        persistenceManager.deleteAll()
        let vehicles = try StaticJSON.sampleVehicles()
        persistenceManager.save(vehicles)
        return vehicles
    }
    
    
}
