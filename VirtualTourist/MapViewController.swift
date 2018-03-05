//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import UIKit
import MapKit
import CoreData

final class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,NSFetchedResultsControllerDelegate {
    
    enum PresentationState { case configure, on, off }
    var presentationState: Bool!
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.pin)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constant.latitude, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.mapView.delegate = self
        fetchedResultsController?.delegate = self
        loadRegion()
        setLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        setupGesture()
    }
}

extension MapViewController {
   
    func setupGesture() {
     
        let longPressRecognize = UILongPressGestureRecognizer(target: self, action: #selector(action))
        longPressRecognize.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPressRecognize)
    }
    
    @objc func action(recognizeGesture:UILongPressGestureRecognizer){
       
        if recognizeGesture.state == .ended {
        
            let touchPosition = recognizeGesture.location(in: mapView)
            let newCoordinates = mapView.convert(touchPosition, toCoordinateFrom: mapView)
            let annotation = Pin(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude, context: AppDelegate.coreDataStack.context)
            
            performUIUpdatesOnMain {
            
                self.mapView.addAnnotation(annotation)
            }
            AppDelegate.coreDataStack.save()
        }
    }
}

extension MapViewController {
    
    func search() {
        
        if let fc = fetchedResultsController {
            
            do {
                
                try fc.performFetch()
            }
            catch let error as NSError {
                
                print("Error while trying to perform a search: \n\(error)\n\(String(describing: fetchedResultsController))")
            }
        }
    }
    
    func loadRegion() {
        
        if let region = UserDefaults.standard.object(forKey: Constant.region) as AnyObject? {
            
            let latitude = region[Constant.latitude] as! CLLocationDegrees
            let longitude = region[Constant.longitude] as! CLLocationDegrees
            let latDelta = region[Constant.latitudeDelta] as! CLLocationDegrees
            let longDelta = region[Constant.longitudeDelta] as! CLLocationDegrees
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            let updatedRegion = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(updatedRegion, animated: true)
        }
    }
    
    func setLocation() {
        
        search()
        
        for pin in fetchedResultsController?.fetchedObjects as! [Pin] {
            
            mapView.addAnnotation(pin)
        }
    }
}

extension MapViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Identifier.photoCollection {
        
            let pin = sender as! Pin
            let nextController = segue.destination as! PhotoCollectionViewController
            nextController.pin = pin
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = ReuseId.pin
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
        
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.animatesDrop = true
            pinView!.isDraggable = true
            pinView!.pinTintColor = .red
            
        }
        else {
        
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation, animated: true)
        let pin = view.annotation as! Pin
        performSegue(withIdentifier: Identifier.photoCollection, sender: pin)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let persisteRegion = [
        
            Constant.latitude : mapView.region.center.latitude,
            Constant.longitude : mapView.region.center.longitude,
            Constant.latitudeDelta : mapView.region.span.latitudeDelta,
            Constant.longitudeDelta : mapView.region.span.longitudeDelta
        ]
        
        UserDefaults.standard.set(persisteRegion, forKey: Constant.region)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if newState == .ending {
        
            let annotation = view.annotation as! Pin
            mapView.addAnnotation(annotation)
            AppDelegate.coreDataStack.save()
        }
    }
}

extension MapViewController {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {}
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {}
    
}
