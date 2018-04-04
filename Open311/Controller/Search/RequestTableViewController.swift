//
//  RequestTableViewController.swift
//  Open311
//
//  Created by Philipp Stotz on 29.01.18.
//  Copyright © 2018 Philipp Stotz. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SwiftIconFont
import SVProgressHUD

public enum Fonts: String {
    case FontAwesome = "FontAwesome"
    case Iconic = "open-iconic"
    case Ionicon = "Ionicons"
    case Octicon = "octicons"
    case Themify = "themify"
    case MapIcon = "map-icons"
    case MaterialIcon = "MaterialIcons-Regular"
}

class RequestTableViewController: UITableViewController {
    
    @IBOutlet var requestTableView: UITableView!
    
    var service : ServiceModel?
    // var mUrlBostonRequest : String = "https://311.boston.gov/open311/v2/requests.json?service_code="
    //var mUrlTorontoRequest : String = "https://secure.toronto.ca/open311test/ws/requests.json?jurisdiction_id=toronto.ca&service_code="
    //var mUrlKoelnProd : String = "https://sags-uns.stadt-koeln.de/georeport/v2/requests.json?jurisdiction_id=stadt-koeln.de&service_code="
    var mUrlSanFran : String = "http://mobile311.sfgov.org/open311/v2/requests.json?jurisdiction_id=sfgov.org&service_code="
    
    var mRequests : [RequestModel] = [RequestModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTableView.register(UINib(nibName: "ServiceRequestCell", bundle: nil), forCellReuseIdentifier: "serviceRequestCell")
        requestTableView.rowHeight = 140
        
        // First we need to concatenate the service code with the static URL in order to fire the request.
        if service != nil {
            SVProgressHUD.show()
            mUrlSanFran += (service?.serviceCode)!
            getOpen311Requests()
            SVProgressHUD.dismiss()
        } else {
            // TODO: Unable to fetch data.
        }
        
        
        
    }
    
    // MARK: datasource zeugs
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mRequests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let requestCell = tableView.dequeueReusableCell(withIdentifier: "serviceRequestCell", for: indexPath) as! ServiceRequestCell
        
        requestCell.adressLabel.text = mRequests[indexPath.row].address
        requestCell.serviceDescription.text = mRequests[indexPath.row].RequestDescription
        
        if mRequests[indexPath.row].status == "open" {
            //print("open")
            //requestCell.serviceStatus.text = "fa:lock-open"
            requestCell.serviceStatus.font = UIFont.icon(from: .Ionicon, ofSize: 20.0)
            requestCell.serviceStatus.text = String.fontIonIcon("gear-a")
            
        } else if mRequests[indexPath.row].status == "closed" {
            //print("closed")
            //requestCell.serviceStatus.text = "fa:lock-closed"
            requestCell.serviceStatus.font = UIFont.icon(from: .Ionicon, ofSize: 20.0)
            requestCell.serviceStatus.text = String.fontIonIcon("checkmark-round")
        } else if mRequests[indexPath.row].status == "submitted" {
            //print("closed")
            //requestCell.serviceStatus.text = "fa:lock-closed"
            requestCell.serviceStatus.font = UIFont.icon(from: .Ionicon, ofSize: 20.0)
            requestCell.serviceStatus.text = String.fontIonIcon("arrow-right-c")
        }
        
        //requestCell.serviceStatus.parseIcon()
        //print(mRequests[indexPath.row].mediaUrl)
        requestCell.mediaUrl.setIcon(from: .Ionicon, code: "ios-camera", textColor: .black, backgroundColor: .clear, size: nil)
        if mRequests[indexPath.row].mediaUrl != "" {
            Alamofire.request(mRequests[indexPath.row].mediaUrl).responseImage {
                response in
                requestCell.mediaUrl.image = response.result.value
                self.mRequests[indexPath.row].mediaData = response.result.value
            }
        }
        
        return requestCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Button pressed")
        
        performSegue(withIdentifier: "showRequest", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Button Action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //TODO: Add functionality
        performSegue(withIdentifier: "createRequest", sender: self)
        
    }
    
    // MARK: Segue Actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createRequest" {
            
            let destinationVC = segue.destination as! CreateRequestViewController
            
            
        } else if segue.identifier == "showRequest" {
            let destinationVC = segue.destination as! RequestViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                destinationVC.request = mRequests[indexPath.row]

            }
        } 
    }
    
    // MARK: Http-Call
    func getOpen311Requests() {
        print("Fire for Requests.....")
        print(mUrlSanFran)
        
        Alamofire.request(mUrlSanFran, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let resJson : JSON = JSON(response.result.value!)
                print("Parsing JSON.....")
                self.parseRequestJson(json: resJson)
                
            }
            else {
                print(response.result.error!)
            }
            
            
            self.requestTableView.reloadData()
            print("Done with HTTP")
        }
    }
    
    // MARK: JSON Parsing
    func parseRequestJson(json : JSON) {
        for (_, req) in json {
            
            let requestModel = RequestModel()
            let dateFormatter = ISO8601DateFormatter()
            
            //if req["service_request_id"].string != nil {
                requestModel.serviceRequestId = req["service_request_id"].string ?? "Not available"
            //}
            //if req["status"].string != nil {
                requestModel.status = req["status"].string ?? "Not available"
            //}
            //if req["status_notes"].string != nil {
                requestModel.statusNotes = req["status_notes"].string ?? "Not available"
            //}
            //if req["service_name"].string != nil {
                requestModel.serviceName = req["service_name"].string ?? "Not available"
            //}
            //if req["service_code"].string != nil {
                requestModel.serviceCode = req["service_code"].string ?? "Not available"
            //}
            //if req["description"].string != nil {
                requestModel.RequestDescription = req["description"].string ?? "Not available"
            //}
            if req["requested_datetime"].string != nil {
                requestModel.requestDateTime = dateFormatter.date(from: req["requested_datetime"].string!)
            }
            if req["updated_datetime"].string != nil {
                requestModel.updatedDateTime = dateFormatter.date(from: req["updated_datetime"].string!)
            }
            //if req["address"].string != nil {
                requestModel.address = req["address"].string ?? "Not available"
            //}
            //if req["lat"].doubleValue != nil {
                requestModel.lat = req["lat"].doubleValue
            //}
            //if req["long"].doubleValue != nil {
                requestModel.long = req["long"].doubleValue
            //}
            //if req["media_url"].string != nil {
                requestModel.mediaUrl = req["media_url"].string ?? ""
            //}
            
            mRequests.append(requestModel)
        }
    }


}
