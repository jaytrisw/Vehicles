import UIKit
import RxSwift
import RxCocoa

class ListController: UIViewController {
    
    private var coordinator: VehiclesCoordinator
    private var viewModel: ListViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    override func loadView() {
        super.loadView()
        title = viewModel.title
        navigationItem.searchController = searchController
        view.addSubview(tableView)
        activateConstraints()
        subscribeToViewModel()
        configureTableView()
        configureSearchController()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureTableView() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
        tableView.rx.modelSelected(ItemViewModel.self)
            .subscribe(onNext: { item in
                self.coordinator.selectMap(at: item)
            }).disposed(by: disposeBag)
    }
    
    private func configureSearchController() {
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind { searchString in
                self.viewModel.filter(with: searchString)
            }.disposed(by: disposeBag)
    }
    
    private func subscribeToViewModel() {
        title = viewModel.title
        viewModel.subscribe()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: DetailTableViewCell.reuseIdentifier)) { index, viewModel, cell in
                cell.textLabel?.text = viewModel.text
                cell.detailTextLabel?.text = viewModel.detailText
            }.disposed(by: disposeBag)
    }
    
    init(_ coordinator: VehiclesCoordinator, viewModel: ListViewModel = ListViewModel()) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
