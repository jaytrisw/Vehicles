import XCTest
import RxSwift
@testable import Vehicles

class ListViewModelTests: XCTestCase {

    lazy var networkService = NetworkEmitsStaticResults()
    lazy var persistenceService = PersistsNothing(networkService: networkService)
    lazy var viewModel = ListViewModel(persistenceService: persistenceService)
    
    func testViewModel() {
        
        let disposeBag = DisposeBag()
        viewModel.subscribe()
            .subscribe({ event in
                XCTAssertNotNil(event.element)
                XCTAssertEqual(event.element?.count, 3)
            }).disposed(by: disposeBag)
    }
    
    func testFilter() {
        viewModel.filter(with: "HH-GO8480")
        let disposeBag = DisposeBag()
        viewModel.subscribe()
            .subscribe({ event in
                XCTAssertNotNil(event.element)
                XCTAssertEqual(event.element?.count, 1)
            }).disposed(by: disposeBag)
    }
}
