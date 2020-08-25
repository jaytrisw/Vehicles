import RxSwift

protocol NetworkService {
    func fetch<C: Codable>(_ object: C.Type, route: NetworkRoute) -> Observable<C>
}
