//
//  Photo.swift
//  ImageAnalyzer
//
//  Created by Dawin Ye on 4/25/20.
//  Copyright © 2020 Dawin Ye. All rights reserved.
//

import Foundation

class Photo: Codable {
    struct ImageResult: Codable {
        var description: Description
        var requestId: String
        var metadata: Metadata
        
    }
    struct Description: Codable {
        var tags: [String]
        var captions: [Caption]
    }
    struct Caption: Codable{
        var text: String
        var confidence: Double
    }
    struct Metadata: Codable {
        var width: Int
        var height: Int
    }
    var tags: [String] = []
    var text = ""
    var confidence = 0.0
    var width = 0
    var height = 0

    
    func getData(search: String, completed: @escaping ()->()) {
        
    
        
        let searchableString = search
        
        let headers = [
            "x-rapidapi-host": "microsoft-azure-microsoft-computer-vision-v1.p.rapidapi.com",
            "x-rapidapi-key": "251a9bbcedmsh156edb3430858ddp165201jsn0d7790048b0c",
            "content-type": "application/json",
            "accept": "application/json"
        ]
        
        let parameters = ["url": "\(searchableString)"] as [String : Any]
        let request = NSMutableURLRequest(url: NSURL(string: "https://microsoft-azure-microsoft-computer-vision-v1.p.rapidapi.com/describe")! as URL,
            cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription)")
            }
            
            // note: there are some additional things that could go wrong when using URL session, but we shouldn't experience them, so we'll ignore testing for these for now...
            
            // deal with the data
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
            }
            do {
                let imageResult = try JSONDecoder().decode(ImageResult.self, from: data!)
                self.height = imageResult.metadata.height
                self.width = imageResult.metadata.width
                self.tags = imageResult.description.tags
                self.confidence = (imageResult.description.captions[0].confidence*100).rounded()
                self.text = imageResult.description.captions[0].text
                
            } catch {
                print("😡 JSON ERROR: \(error.localizedDescription)")
            }
            completed()
        }
        dataTask.resume()
    }
}
