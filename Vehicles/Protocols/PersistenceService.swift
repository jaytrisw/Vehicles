import RxSwift

protocol PersistenceService {
    @discardableResult func save(_ objects: [Vehicle]) -> Bool
    @discardableResult func delete(_ object: Vehicle) -> Bool
    @discardableResult func deleteAll() -> Bool
    @discardableResult func fetch() -> [Vehicle]
    func subscribe() -> BehaviorSubject<[Vehicle]>
    func fetchFromNetwork()
}
