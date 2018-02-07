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

class RequestViewController: UIViewController {

    
    @IBOutlet weak var requestLocationMap: MKMapView!
    @IBOutlet weak var mediaUrlImage: UIImageView!
    @IBOutlet weak var requestIdLabel: UILabel!
    @IBOutlet weak var requestStatusLabel: UILabel!
    @IBOutlet weak var requestDescriptionLabel: UILabel!
    @IBOutlet weak var requestedDateLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    
    var requestId : String?
    var requestStatus : String?
    var requestStatusNotes : String?
    var serviceName : String?
    var serviceCode : String?
    var requestDescription : String?
    var requestedDateTime : Date?
    var updatedDateTime : Date?
    var adress : String?
    var lat : Double?
    var long : Double?
    var mediaUrl : String?
    var mediaData : Image?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaUrlImage.image = mediaData
        requestIdLabel.text = requestId
        requestStatusLabel.text = requestStatus
        requestDescriptionLabel.text = requestDescription
        requestedDateLabel.text = getDateAsString(date: requestedDateTime!)
        updatedDateLabel.text = getDateAsString(date: updatedDateTime!)

        if lat != nil && long != nil {
            let initialLocation = CLLocation(latitude: lat!, longitude: long!)
            centerMapOnLocation(location: initialLocation)
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
