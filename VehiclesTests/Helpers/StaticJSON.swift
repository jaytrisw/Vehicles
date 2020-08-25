import Foundation
@testable import Vehicles

class StaticJSON {
    
    private static let sampleJson = """
            [
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
            },
            {
              "address": "Grosse Reichenstraße 7, 20457 Hamburg",
              "coordinates": [
                9.99622,
                53.54847,
                0
              ],
              "engineType": "CE",
              "exterior": "UNACCEPTABLE",
              "fuel": 45,
              "interior": "GOOD",
              "name": "HH-GO8480",
              "vin": "WME4513341K412697"
            },
            {
              "address": "Spreenende 1 - 11, 22453 Hamburg (Umkreis 100m)",
              "coordinates": [
                9.97417,
                53.61274,
                0
              ],
              "engineType": "CE",
              "exterior": "UNACCEPTABLE",
              "fuel": 57,
              "interior": "UNACCEPTABLE",
              "name": "HH-GO8001",
              "vin": "WME4513341K412709"
            }
            ]
            """
    
    static func sampleData() -> Data? {
        return sampleJson.data(using: .utf8)
    }
    
    static func sampleVehicles() throws -> [Vehicle] {
        guard let data = sampleData() else {
            return []
        }
        let vehicles = try JSONDecoder().decode([Vehicle].self, from: data)
            .sorted(by: { $0.name < $1.name })
        return vehicles
    }
}
