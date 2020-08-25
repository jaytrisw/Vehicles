import Foundation
import RxSwift

class NetworkManager: NetworkService {
    private lazy var jsonDecoder = JSONDecoder()
    private let urlSession: URLSession
    
    static let shared = NetworkManager()
    
    func fetch<C: Codable>(_ object: C.Type, route: NetworkRoute) -> Observable<C> {
        return Observable.create { observer -> Disposable in
            guard let url = route.url else {
                fatalError()
            }
            let task = self.urlSession.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    observer.onError(error ?? NetworkError.unknownError)
                    return
                }
                do {
                    let objects = try self.jsonDecoder.decode(object, from: data)
                    observer.onNext(objects)
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()
            return Disposables.create()
        }
    }
    
    enum NetworkError: Error {
        case unknownError
    }
    
    private init() {
        urlSession = URLSession.shared
    }
}
