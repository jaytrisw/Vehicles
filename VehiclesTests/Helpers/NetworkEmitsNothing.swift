import RxSwift
@testable import Vehicles

final class NetworkEmitsNothing: NetworkService {
    func fetch<C>(_ object: C.Type, route: NetworkRoute) -> Observable<C> where C : Decodable, C : Encodable {
        return Observable.create { _ -> Disposable in
            return Disposables.create()
        }
    }
}
