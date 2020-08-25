import Foundation
import RxSwift

final class UserDocumentsPersistenceManager: PersistenceService {
    
    private let networkService: NetworkService
    private var vehicles: BehaviorSubject<[Vehicle]> = BehaviorSubject(value: [])
    private let disposeBag = DisposeBag()
    
    func subscribe() -> BehaviorSubject<[Vehicle]> {
        return vehicles
    }
    
    @discardableResult
    func save(_ objects: [Vehicle]) -> Bool {
        do {
            for vehicle in objects {
                let data = try JSONEncoder().encode(vehicle)
                let documentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileURL = documentDirURL.appendingPathComponent(vehicle.name)
                try data.write(to: fileURL)
            }
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func fetch() -> [Vehicle] {
        var fetchedVehicles = [Vehicle]()
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
            for fileURL in directoryContents {
                let data = try Data(contentsOf: fileURL)
                if let vehicle = try? JSONDecoder().decode(Vehicle.self, from: data) {
                    fetchedVehicles.append(vehicle)
                }
            }
            self.vehicles.onNext(fetchedVehicles)
            return fetchedVehicles
        } catch {
            self.vehicles.onNext([])
            return []
        }
    }
    
    @discardableResult
    func delete(_ object: Vehicle) -> Bool {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let path = documentsURL.appendingPathComponent(object.name)
        do {
            try FileManager.default.removeItem(at: path)
            return true
        } catch {
            return false
        }
        
    }
    
    @discardableResult
    func deleteAll() -> Bool {
        var returnValue = false
        for string in fetch() {
            returnValue = delete(string)
        }
        return returnValue
    }
    
    func fetchFromNetwork() {
        networkService.fetch(Placemark.self, route: .vehicleLocations)
            .bind { [weak self] (placemark) in
                self?.vehicles.onNext(placemark.placemarks)
                self?.save(placemark.placemarks)
            }.disposed(by: self.disposeBag)
    }
        
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
        fetch()
        fetchFromNetwork()
    }
}
