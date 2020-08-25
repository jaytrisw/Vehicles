import MapKit

struct ItemViewModel: CellViewModel, AnnotationViewModel {
    
    private var vehicle: Vehicle
    
    var title: String {
        return vehicle.name
    }
    
    var text: String {
        return vehicle.name
    }
    var detailText: String {
        return """
            \(vehicle.vin)
            \(vehicle.address)
            Interior Condition: \(vehicle.interior.rawValue.capitalized)
            Exterior Condition: \(vehicle.exterior.rawValue.capitalized)
            Engine Type: \(vehicle.engineType)
            Fuel: \(vehicle.fuel)%
            """
    }
    
    var annotation: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = vehicle.location!.coordinate
        annotation.subtitle = vehicle.name
        return annotation
    }
    
    init(_ vehicle: Vehicle) {
        self.vehicle = vehicle
    }
}
