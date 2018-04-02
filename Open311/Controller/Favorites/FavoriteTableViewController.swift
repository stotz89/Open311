//
//  FavoriteTableViewController.swift
//  Open311
//
//  Created by Philipp Stotz on 07.02.18.
//  Copyright © 2018 Philipp Stotz. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireImage
import SwiftIconFont
import SwiftyJSON

class FavoriteTableViewController: UITableViewController {
    
    
    @IBOutlet var favoriteTableView: UITableView!
    
    var mUrlSanFran : String = "http://mobile311.sfgov.org/open311/v2/requests.json?jurisdiction_id=sfgov.org&service_request_id="
    var mRequests : [RequestModel] = [RequestModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewDidLoad")
        
        favoriteTableView.register(UINib(nibName: "ServiceRequestCell", bundle: nil), forCellReuseIdentifier: "serviceRequestCell")
        favoriteTableView.rowHeight = 140

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
        getFavoriteRequestData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mRequests.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mRequests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let requestCell = tableView.dequeueReusableCell(withIdentifier: "serviceRequestCell", for: indexPath) as! ServiceRequestCell
        
        // Set the text in the cells.
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showRequest" {
            let destinationVC = segue.destination as! RequestViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                destinationVC.request = mRequests[indexPath.row]
                
            }
        }
        
    }
    
    
    // MARK : - Get Data of favorite Requests
    
    func getFavoriteRequestData() {
        
        var mRequestRealm : Results<RequestModelRealm>?
        
        // Read Realm instance
        do {
            let realm = try Realm()
            mRequestRealm = realm.objects(RequestModelRealm.self)
            
        } catch {
            print("Error initialising Realm, \(error) ")
        }
        
        for request in mRequestRealm! {
            
            Alamofire.request(mUrlSanFran + request.serviceRequestId, method: .get).responseJSON {
                response in
                if response.result.isSuccess {
                    let resJson : JSON = JSON(response.result.value!)
                    print("Parsing JSON.....")
                    self.parseRequestJson(json: resJson)
                    
                }
                else {
                    print(response.result.error!)
                }
                
                self.favoriteTableView.reloadData()
                print("Done with HTTP")
            }
        }
    }
    
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
