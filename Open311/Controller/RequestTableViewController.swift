//
//  RequestTableViewController.swift
//  Open311
//
//  Created by Philipp Stotz on 29.01.18.
//  Copyright © 2018 Philipp Stotz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class RequestTableViewController: UITableViewController {
    
    @IBOutlet var requestTableView: UITableView!
    
    var service : ServiceModel?
    var mUrlBostonRequest : String = "https://311.boston.gov/open311/v2/requests.json?service_code="
    
    var mRequests : [RequestModel] = [RequestModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        requestTableView.register(UINib(nibName: "ServiceRequestCell", bundle: nil), forCellReuseIdentifier: "serviceRequestCell")

        // First we need to concatenate the service code with the static URL in order to fire the request.
        if service != nil {
            mUrlBostonRequest += (service?.serviceCode)!
            getOpen311Requests()
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
        
        requestCell.serviceId.text = mRequests[indexPath.row].serviceName
        requestCell.serviceDescription.text = mRequests[indexPath.row].description
        
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
            
            if let indexPath = tableView.indexPathForSelectedRow?.row {
                
                print(indexPath)
                print(mRequests[indexPath].serviceName)
                let model : RequestModel = mRequests[indexPath]
                destinationVC.requestId = "Abc"
                //destinationVC.requestIdLabel.text = mRequests[indexPath].serviceName
                //if mRequests[indexPath].serviceName != nil {
                    //destinationVC.requestIdLabel.text = mRequests[indexPath].serviceName
                //}
                
                
                //destinationVC.requestDescriptionLabel.text = mRequests[indexPath].description
            
                //destinationVC.requestDateLabel.text = mRequests[indexPath].lat
                
                //destinationVC.requestTimeLabel.text = mRequests[indexPath].long
                //destinationVC.requestStatusLabel.text = mRequests[indexPath].status
            }
        }
    }
    
    // MARK: Http-Call
    func getOpen311Requests() {
        print("Fire for Requests.....")
        print(mUrlBostonRequest)
        
        Alamofire.request(mUrlBostonRequest, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let resJson : JSON = JSON(response.result.value!)
                print("Parsing JSON.....")
                self.parseRequestJson(json: resJson)
                
            }
            else {
                print(response.result.error!)
            }
            SVProgressHUD.dismiss()
            self.requestTableView.reloadData()
            print("Done with HTTP")
        }
    }
    
    // MARK: JSON Parsing
    func parseRequestJson(json : JSON) {
        for (_, req) in json {
            
            let requestModel = RequestModel()
            
            //print(req)
            if req["status"].string != nil {
                requestModel.status = req["status"].string!
            }
            if req["description"].string != nil {
                requestModel.description = req["description"].string!
            }
            if req["adress"].string != nil {
                requestModel.address = req["address"].string!
            }
            if req["lat"].string != nil {
                requestModel.lat = req["lat"].string!
            }
            if req["long"].string != nil {
                requestModel.long = req["long"].string!
            }
            if req["service_name"].string != nil {
                requestModel.serviceName = req["service_name"].string!
            }
            
            mRequests.append(requestModel)
        }
    }


}
