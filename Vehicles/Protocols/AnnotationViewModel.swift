import MapKit

protocol AnnotationViewModel {
    var title: String { get }
    var annotation: MKPointAnnotation { get }
}
