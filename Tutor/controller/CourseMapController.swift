//
//  CourseMapController.swift
//  Tutor
//
//  Created by Fagan Rasulov on 28.07.22.
//

import UIKit
import MapKit

class CourseMapController: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var map: MKMapView!
    var courses = [Course]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        addMarks()
    }
    
    
    @IBAction func valueChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex {
                case 0:
                    map.mapType = .standard
                case 1:
                    map.mapType = .satellite
                case 2:
                    map.mapType = .hybrid
                default:
                    map.mapType = .standard
                }
    }
    
    
    func addMarks() {
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(1),
                                                                       longitude: CLLocationDegrees(1))
        for course in courses {
            if let latitude = course.latitude, let longitude = course.longitude {
                coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                                        longitude: CLLocationDegrees(longitude))
                let pin = CustomMKPointAnnotation()
                pin.coordinate = coordinate
                pin.title = course.title
                pin.subtitle = course.createdBy?.name
                pin.course = course
                map.addAnnotation(pin)
            }
        }
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: CLLocationDistance(30000), longitudinalMeters: CLLocationDistance(30000))
        map.setRegion(region, animated: true)

        
    }


}


extension CourseMapController: MKMapViewDelegate {
    

       func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
           let controller = storyboard?.instantiateViewController(withIdentifier: "\(CourseController.self)") as! CourseController
           
           controller.modalPresentationStyle = .pageSheet
           if let sheet = controller.sheetPresentationController {
               sheet.detents = [.medium(), .large()]
           }
           let parsed = view.annotation as! CustomMKPointAnnotation
           controller.course = parsed.course
           present(controller, animated: true, completion: nil)

           
           
       }
}


class CustomMKPointAnnotation: MKPointAnnotation {
    var course = Course()
}
