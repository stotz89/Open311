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
    
    var serviceName : String = ""
    var serviceCode : String = ""
    var RequestDescription : String = ""
    var address : String = ""
    var status : String = ""
    var statusNotes : String = ""
    var mediaUrl : String = ""
    
    var requestDateTime : Date?
    var updatedDateTime : Date?
    var long : Double?
    var lat : Double?
    var mediaData : Image?
    
}
