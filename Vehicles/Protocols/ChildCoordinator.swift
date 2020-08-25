import UIKit

protocol ChildCoordinator: AnyObject {
    var rootViewController: UIViewController? { get }
    var parentCoordinator: ApplicationCoordinator? { get }
    
    func start()
    func didFinish()
    
    init(withParent parentCoordinator: ApplicationCoordinator)
}
