//
//  RequestViewController.swift
//  Open311
//
//  Created by Philipp Stotz on 29.01.18.
//  Copyright © 2018 Philipp Stotz. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import AlamofireImage
import RealmSwift

class RequestViewController: UIViewController {

    
    @IBOutlet weak var addToFavoritesButton: UIBarButtonItem!
    @IBAction func bookmarkButtonPressed(_ sender: Any) {
        
        print("Bookmark Button Pressed")
        
        // Persist the data in RealmDatabase
        var requestPersist : RequestModelRealm = RequestModelRealm()
        requestPersist.serviceRequestId = self.request!.serviceRequestId
        requestPersist.RequestDescription = self.request!.RequestDescription
        requestPersist.serviceCode = self.request!.serviceCode
        requestPersist.serviceName = self.request!.serviceName
        
        /*print(requestPersist.serviceRequestId)
        print(requestPersist.RequestDescription)
        print(requestPersist.serviceName)
        print(requestPersist.serviceCode)*/
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(requestPersist)
            }
        } catch {
            print("Error initialising Realm, \(error) ")
        }
        
    }
    
    @IBOutlet weak var requestLocationMap: MKMapView!
    @IBOutlet weak var mediaUrlImage: UIImageView!
    @IBOutlet weak var requestIdLabel: UILabel!
    @IBOutlet weak var requestStatusLabel: UILabel!
    @IBOutlet weak var requestDescriptionLabel: UILabel!
    @IBOutlet weak var requestedDateLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    
    var request : RequestModel?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaUrlImage.image = request!.mediaData
        requestIdLabel.text = request!.serviceRequestId
        requestStatusLabel.text = request!.status
        requestDescriptionLabel.text = request!.RequestDescription
        if request!.requestDateTime != nil {
            requestedDateLabel.text = getDateAsString(date: request!.requestDateTime!)
        } else {
            requestedDateLabel.text = "Not provided"
        }
        
        if request!.updatedDateTime != nil {
            updatedDateLabel.text = getDateAsString(date: request!.updatedDateTime!)
        } else {
            updatedDateLabel.text = "Not provided"
        }
        

        if request!.lat != nil && request!.long != nil {
            let initialLocation = CLLocation(latitude: request!.lat!, longitude: request!.long!)
            centerMapOnLocation(location: initialLocation)
        }
        
        //Check whether the status is submitted --> no adding to favorites possible --> Hiding the "Add to favorite" Button
        if ( request!.status == "submitted" ) {
            addToFavoritesButton.isEnabled = false
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: MapKit Stuff
    func centerMapOnLocation(location: CLLocation) {
        let annotation = MKPointAnnotation()
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        
        
        let coordinatePoint = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        annotation.coordinate = coordinatePoint
        requestLocationMap.addAnnotation(annotation)
        requestLocationMap.setRegion(coordinateRegion, animated: true)
        
    }
    
    // MARK: Convert Date & Time
    func getDateFromDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
        
    }
    
    func getTimeFromDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: date)
        
    }
    
    func getDateAsString(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
