import RxSwift
@testable import Vehicles

final class PersistsNothing: PersistenceService {
    
    var networkService: NetworkService
    private var vehicles: BehaviorSubject<[Vehicle]> = BehaviorSubject(value: [])
    private let disposeBag = DisposeBag()
    
    func save(_ objects: [Vehicle]) -> Bool {
        return false
    }
    
    func delete(_ object: Vehicle) -> Bool {
        return false
    }
    
    func deleteAll() -> Bool {
        return false
    }
    
    func fetch() -> [Vehicle] {
        return []
    }
    
    func subscribe() -> BehaviorSubject<[Vehicle]> {
        return vehicles
    }
    
    func fetchFromNetwork() {
        networkService.fetch([Vehicle].self, route: .vehicleLocations)
            .bind { [weak self] vehicles in
                self?.vehicles.onNext(vehicles)
            }.disposed(by: self.disposeBag)
    }
    
    init(networkService: NetworkService = NetworkEmitsStaticResults()) {
        self.networkService = networkService
        fetchFromNetwork()
    }
}
