//
//  HttpUtility.swift
//  Actofit
//
//  Created by Mujahed Ansari on 26/04/21.
//  Copyright © 2021 Neeraj Rathi. All rights reserved.
//

import Foundation

struct HttpUtility {
    func getApiData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void)
    {
        URLSession.shared.dataTask(with: requestUrl) { (responseData, httpUrlResponse, error) in
            print(error)
            print(httpUrlResponse)
            do {
                if let data = responseData {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                      print(json)
                }
            }catch let catchError {
                print(catchError)
            }
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                //parse the responseData here
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    _=completionHandler(result)
                }
                catch let error{
                    completionHandler(nil)
                    debugPrint("error occured while decoding = \(error.localizedDescription)")
                }
            }else {
                completionHandler(nil)
            }
        }.resume()
    }

    func postApiData<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            print(httpUrlResponse)
            if(data != nil && data?.count != 0)
            {
                do {
                  let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(json)
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    _=completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
        }.resume()
    }
    
    func putApiData<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "PUT"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")

        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in

            if(data != nil && data?.count != 0)
            {
                do {

                    let response = try JSONDecoder().decode(T.self, from: data!)
                    _=completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
        }.resume()
    }
    
    func deleteApiData<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "DELETE"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            if(data != nil && data?.count != 0)
            {
                do {
                  let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(json)
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    _=completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
        }.resume()
    }//end function body.
    
    func postApiData<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, header: [String: String],completionHandler:@escaping(_ result: T)-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        for key in header.keys {
            urlRequest.addValue(header[key]!, forHTTPHeaderField: key)
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            print(httpUrlResponse)
            if(data != nil && data?.count != 0)
            {
                do {
                  let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(json)
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    _=completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
        }.resume()
    }//end function body.
    
}
