import CoreLocation

struct Vehicle: Codable, Hashable, Equatable, CustomStringConvertible {
    var name: String
    var vin: String
    var address: String
    var engineType: String
    var exterior: Condition
    var interior: Condition
    var fuel: Float
    
    private var coordinates: [Double]
    
    var description: String {
        return name
    }
    
    var location: CLLocation? {
        guard coordinates.count >= 3 else {
            return nil
        }
        let coordinate = CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        return CLLocation(coordinate: coordinate, altitude: coordinates[2], horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
    }
    
    enum Condition: String, Codable {
        case good = "GOOD"
        case unacceptable = "UNACCEPTABLE"
        case unspecified = "UNSPECIFIED"
    }
    
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.vin == rhs.vin
    }
}
