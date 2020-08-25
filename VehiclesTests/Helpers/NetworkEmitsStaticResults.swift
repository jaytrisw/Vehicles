import RxSwift
@testable import Vehicles

final class NetworkEmitsStaticResults: NetworkService {
    func fetch<C>(_ object: C.Type, route: NetworkRoute) -> Observable<C> where C : Decodable, C : Encodable {
        return Observable.create { observer -> Disposable in
            guard let data = StaticJSON.sampleData() else {
                fatalError("Failed to generate data from sample json string")
            }
            do {
                let vehicles = try JSONDecoder().decode(object, from: data)
                observer.onNext(vehicles)
            } catch {
                fatalError(error.localizedDescription)
            }
            return Disposables.create()
        }
    }
}
