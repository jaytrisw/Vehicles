import UIKit

class MainController: UITabBarController {
    
    let coordinator: VehiclesCoordinator
    
    init(_ coordinator: VehiclesCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
