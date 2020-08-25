import RxSwift

final class ListViewModel {
    let title = "Vehicles"
    
    private var persistenceService: PersistenceService
    private var items = [ItemViewModel]()
    private var vehicles: BehaviorSubject<[ItemViewModel]> = BehaviorSubject(value: [])
    private let disposeBag = DisposeBag()
    
    func filter(with string: String) {
        if string.isEmpty {
            vehicles.onNext(items)
        } else {
            let filtered = items.filter { vehicle -> Bool in
                return vehicle.text.uppercased().contains(string.uppercased()) || vehicle.detailText.uppercased().contains(string.uppercased())
            }
            vehicles.onNext(filtered)
        }
    }
    
    func subscribe() -> BehaviorSubject<[ItemViewModel]> {
        return vehicles
    }
    
    init(persistenceService: PersistenceService = UserDocumentsPersistenceManager()) {
        self.persistenceService = persistenceService
        self.persistenceService.subscribe().subscribe { [weak self] event in
            self?.items.removeAll()
            guard let vehicles = event.element else { return }
            self?.items = vehicles.map {
                return ItemViewModel($0)
            }
            guard let items = self?.items else { return }
            self?.vehicles.onNext(items)
        }.disposed(by: disposeBag)
    }
}
