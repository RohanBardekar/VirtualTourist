//
//  PhotoCollectionViewController.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import UIKit
import MapKit
import CoreData

final class PhotoCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var toolBarButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    var pin: Pin?
    var selectedIndexe = [NSIndexPath]()
    var deleteIndexPaths: [NSIndexPath]!
    var updateIndexPaths: [NSIndexPath]!
    var insertIndexPaths: [NSIndexPath]!
   
    lazy var fetchedResults: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.photo)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constant.id, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: Constant.format, self.pin!)
        let fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResults
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureLocation()
        search()
        fetchedResults.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        downloadCollection()
    }
    
    @IBAction func newCollectionButton(_ sender: UIBarButtonItem) {
        
        selectedIndexe.isEmpty ? newCollection() : deleteSelectedPhoto()
    }
}

extension PhotoCollectionViewController {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResults.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.photoViewCell, for: indexPath) as! PhotoViewCell
        configureCell(cell, atIndexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoViewCell
        
        if let index = selectedIndexe.index(of: indexPath as NSIndexPath) {
            
            selectedIndexe.remove(at: index)
        }
        else {
            
            selectedIndexe.append(indexPath as NSIndexPath)
        }
        
        configureCell(cell, atIndexPath: indexPath as NSIndexPath)
        updateButton()
    }
    
    func configureCell(_ cell: PhotoViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let photo = self.fetchedResults.object(at: indexPath as IndexPath) as! Photo
        let imagePlaceholder = UIImage(named: ImageName.flickr)
        var cellImage = imagePlaceholder
        cell.collectionImageView.image = nil
        
        if let image = photo.photo {
            
            cellImage = UIImage(data: image)
        }
        else {
            
            let task = DataLoader.sharedInstance().getFlickrImages(photo) { (success, errorString, imageData) in
                
                if errorString != nil {
   
                    cellImage = nil
                }
                else {
                    
                    if let data = imageData {
                        
                        performUIUpdatesOnMain {
                            
                            photo.photo = data
                          
                          //Post Review Addition - Saving 'photo' (BD Browser shows BLOB and NULL)
                           AppDelegate.coreDataStack.save()
                           cell.collectionImageView.image = UIImage(data: data)
                        }
                    }
                    else {
                        
                        print(Error.getImage)
                    }
                }
                
            }
            cell.cancelTaskCellReused = task
        }
        cell.collectionImageView.image = cellImage
        
        if selectedIndexe.index(of: indexPath as NSIndexPath) != nil {
          
            cell.collectionImageView.layer.borderWidth = 2.0
            cell.collectionImageView.layer.borderColor = UIColor.yellow.cgColor
        }
        else {
           
            cell.collectionImageView.layer.borderWidth = 0.0
            cell.collectionImageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}

extension PhotoCollectionViewController {
    
    func downloadCollection() {
        
        if pin?.photo?.count == 0 {
            
            showActivityIndicator()
            DataLoader.sharedInstance().getPhotosUsingFlickr(pin) { (success, errorString) in
   
                if success {
                    
                    performUIUpdatesOnMain {
                        
                        self.hideActivityIndicator()
                        
                        
                        AppDelegate.coreDataStack.save()
                        
                    }
                }
            }
        }
    }
    
    func newCollection() {
        
        for photo in fetchedResults.fetchedObjects as! [Photo] {
            
            AppDelegate.coreDataStack.context.delete(photo)
        }
        
        AppDelegate.coreDataStack.save()
        
        if fetchedResults.fetchedObjects?.count == 0 {
            
            showActivityIndicator()
            DataLoader.sharedInstance().getPhotosUsingFlickr(pin) {
                (success, errorString)in
                
                if success {
                    
                    performUIUpdatesOnMain {
                        
                        self.hideActivityIndicator()
                    }
                    
                    AppDelegate.coreDataStack.save()
                }
            }
        }
    }
    
    func deleteSelectedPhoto() {
        
        var deletedPhoto = [Photo]()
        
        for indexPath in selectedIndexe {
            
            deletedPhoto.append(fetchedResults.object(at: indexPath as IndexPath) as! Photo)
        }
        
        for photo in deletedPhoto {
            
            AppDelegate.coreDataStack.context.delete(photo)
        }
        
        AppDelegate.coreDataStack.save()
        selectedIndexe = [NSIndexPath]()
        updateButton()
    }
}

extension PhotoCollectionViewController {
    
    func configureLocation() {
       
        if let mapAnnotation = pin {
          
            let coordinate = CLLocationCoordinate2D(latitude: mapAnnotation.latitude, longitude: mapAnnotation.longitude)
            mapView.addAnnotation(mapAnnotation)
            mapView.camera.altitude = 10000.0
            mapView.setCenter(coordinate, animated: true)
        }
    }
    
    func search() {
        do {
          
            try fetchedResults.performFetch()
        }
        catch let e as NSError {
            
            print("Error while trying to perform a search: \n\(e)\n\(fetchedResults)")
        }
    }
}


extension PhotoCollectionViewController {
    
    func updateButton() {
        
        selectedIndexe.count > 0 ? (toolBarButton.title = ButtonTitle.deletePhoto) : (toolBarButton.title = ButtonTitle.newCollection)
    }
}

extension PhotoCollectionViewController {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        insertIndexPaths = [NSIndexPath]()
        deleteIndexPaths = [NSIndexPath]()
        updateIndexPaths = [NSIndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            insertIndexPaths.append(newIndexPath! as NSIndexPath)
            break
        case .delete:
            deleteIndexPaths.append(indexPath! as NSIndexPath)
        case .update:
            updateIndexPaths.append(indexPath! as NSIndexPath)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView.performBatchUpdates({() -> Void in
            
            for indexPath in self.insertIndexPaths {
                
                self.collectionView.insertItems(at: [indexPath as IndexPath])
            }
            
            for indexPath in self.deleteIndexPaths {
                
                self.collectionView.deleteItems(at: [indexPath as IndexPath])
            }
            
            for indexPath in self.updateIndexPaths {
                
                self.collectionView.reloadItems(at: [indexPath as IndexPath])
            }
            
        },  completion: nil)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let set = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            self.collectionView.insertSections(set)
        case .delete:
            self.collectionView.deleteSections(set)
        default:
            return
        }
    }
    
}

