import Foundation

enum NetworkRoute {
    case vehicleLocations
    
    var url: URL? {
        switch self {
        case.vehicleLocations:
            return URL(string: "https://wunder-test-case.s3-eu-west-1.amazonaws.com/ios/locations.json")
        }
    }
}
