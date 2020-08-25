import UIKit

final class VehiclesCoordinator: ApplicationCoordinator {
    
    private(set) var window: UIWindow
    private(set) var rootViewController: UITabBarController!
    private var listController: ListController!
    
    private var mapController: MapController!
    
    private var listViewModel: ListViewModel = ListViewModel()
    private var mapViewModel: ListViewModel = ListViewModel()
    
    private var navigationController: UINavigationController!
    
    private(set) var childCoordinators = [ChildCoordinator]()
    
    init(_ window: UIWindow) {
        self.window = window
        self.window.makeKeyAndVisible()
        start()
    }
    
    func selectMap(at annotation: AnnotationViewModel) {
        rootViewController.selectedViewController = mapController
        mapViewModel.filter(with: annotation.title)
    }
    
    func childDidFinish(_ childCoordinator: ChildCoordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    func createChildCoordinator<C>(_ type: C.Type) -> C where C : ChildCoordinator {
        let childCoordinator = C(withParent: self)
        childCoordinators.append(childCoordinator)
        return childCoordinator
    }
    
    func start() {
        let mainViewController = MainController(self)
        
        let listController = ListController(self, viewModel: listViewModel)
        listController.navigationItem.largeTitleDisplayMode = .always
        if #available(iOS 13.0, *) {
            listController.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.dash"), tag: 0)
        } else {
            listController.tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "list-solid"), tag: 0)
        }
        
        let navigationController = UINavigationController(rootViewController: listController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        let mapController = MapController(self, viewModel: mapViewModel)
        if #available(iOS 13.0, *) {
            mapController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 1)
        } else {
            mapController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map-regular"), tag: 1)
        }
        
        mainViewController.viewControllers = [navigationController, mapController]
        
        window.rootViewController = mainViewController
        
        self.rootViewController = mainViewController
        self.listController = listController
        self.navigationController = navigationController
        self.mapController = mapController
    }
}
