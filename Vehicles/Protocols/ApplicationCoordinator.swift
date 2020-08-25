import UIKit

protocol ApplicationCoordinator: AnyObject {
    var childCoordinators: [ChildCoordinator] { get }
    var window: UIWindow { get }
    var rootViewController: UITabBarController! { get }
    
    func start()
    func createChildCoordinator<C: ChildCoordinator>(_ type: C.Type) -> C
    func childDidFinish(_ childCoordinator: ChildCoordinator)
    init(_ window: UIWindow)
}
