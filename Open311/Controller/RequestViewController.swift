//
//  RequestViewController.swift
//  Open311
//
//  Created by Philipp Stotz on 29.01.18.
//  Copyright © 2018 Philipp Stotz. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController {

    @IBOutlet weak var requestIdLabel: UILabel!
    @IBOutlet weak var requestStatusLabel: UILabel!
    @IBOutlet weak var requestDescriptionLabel: UILabel!
    @IBOutlet weak var requestDateLabel: UILabel!
    @IBOutlet weak var requestTimeLabel: UILabel!
    
    var requestId : String?
    var requestStatus : String?
    var requestDescription : String?
    var requestDate : String?
    var requestTime : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestIdLabel.text = requestId
        requestStatusLabel.text = requestStatus

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
