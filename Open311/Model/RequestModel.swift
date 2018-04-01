//
//  RequestModel.swift
//  Hello World
//
//  Created by Philipp Stotz on 26.01.18.
//  Copyright © 2018 Philipp Stotz. All rights reserved.
//

import Alamofire
import AlamofireImage

class RequestModel : RequestModelRealm {
    
    //@objc dynamic var serviceRequestId : String = ""
    var status : String = ""
    var statusNotes : String = ""
    /*@objc dynamic var serviceName : String = ""
    @objc dynamic var serviceCode : String = ""
    @objc dynamic var RequestDescription : String = ""*/
    var requestDateTime : Date?
    var updatedDateTime : Date?
    var address : String = ""
    var long : Double?
    var lat : Double?
    var mediaUrl : String = ""
    var mediaData : Image?
    
}
