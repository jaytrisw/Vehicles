import UIKit
import MapKit
import RxSwift

class MapController: UIViewController {
    
    private var coordinator: VehiclesCoordinator
    private var viewModel: ListViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var deselectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.setTitle("Deselect", for: .normal)
        button.backgroundColor = .systemBlue
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(mapView)
        view.addSubview(deselectButton)
        activateConstraints()
        subscribeToViewModel()
        deselectButton.rx.tap
            .bind {
                self.mapView.selectedAnnotations.forEach {
                    self.mapView.deselectAnnotation($0, animated: true)
                }
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                self.viewModel.filter(with: "")
            }.disposed(by: disposeBag)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            deselectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            deselectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func subscribeToViewModel() {
        viewModel.subscribe()
            .observeOn(MainScheduler.instance)
            .bind { viewModel in
                self.mapView.removeAnnotations(self.mapView.annotations)
                let annotations = viewModel.map { viewModel -> MKPointAnnotation in
                    return viewModel.annotation
                }
                self.mapView.showAnnotations(annotations, animated: true)
                if annotations.count == 1 {
                    self.mapView.selectAnnotation(annotations.first!, animated: true)
                }
                
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

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = view.annotation?.coordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        deselectButton.isHidden = false
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        deselectButton.isHidden = true
    }
}
