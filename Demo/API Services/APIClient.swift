//
//  APIClient.swift
//  Demo
//
//  Created by Julio Lemus on 12/02/21.
//

import Alamofire

class APIClient {
    
    public typealias Headers = [String: String]
    static let baseURL = "https://api.thecatapi.com/v1/"
    
    func request<T: Decodable>(api : String, someClass: T.Type, param : Parameters? = [:], method: Alamofire.HTTPMethod = .get, urlBase: String = baseURL, headersCustom:[String:String]? = nil, encoding:URLEncoding =  URLEncoding.default, completion: @escaping (T?, ErrorHandler?) -> Void) {
        
        var headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "x-api-key ": "dbbe77b1-31dd-4976-b914-dd8914b20b1c"
        ]
        
        if let newHeader = headersCustom {
            headers = newHeader
        }
        
        Alamofire.request( urlBase + api , method: method, parameters: param, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response.response?.statusCode ?? -1)
            debugPrint("Path request : \(urlBase+api)")
            
            guard let httpResponse = response.response else {
                completion(nil, .requestFailed)
                return
            }
            
            guard let data = response.data else {
                completion(nil, .invalidData)
                return
            }
            
            self.toJsonData(data: data)
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let genericType = try JSONDecoder().decode(someClass.self, from: data)
                    completion(genericType, nil)
                } catch {
                    completion(nil, .jsonParsinFail)
                }
            case 300...600:
                completion(nil, .responseUnsuccessfull)
            default:
                completion(nil, .requestFailed)
            }
        }
    } 
    
    func postRequestHLJSON<T: Decodable>(parameter: ContactBaseRequest, url: String, someClass: T.Type, completion: @escaping ([String:AnyObject]?, ErrorHandler?) -> Void){
        
        let url = URL(string: url)!
        let jsonDict = parameter.dictionary ?? [:]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])

        var request = URLRequest(url: url)
        request.httpMethod = "post"
        //request.setValue("application/hal+json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                debugPrint("error:", error)
                completion(nil, .requestFailed)
                return
            }
            guard let data = data else {
                completion(nil, .invalidData)
                return
            }
            self.toJsonData(data: data)
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                completion(json, nil) 
            }catch {
                completion(nil, .requestFailed)
            }
        }

        task.resume()
    }
    
    func postRequestQuery<T: Decodable>(parameters: ContactBaseRequest, url: String, someClass: T.Type, completion: @escaping ([String:AnyObject]?, ErrorHandler?) -> Void) {
         
        var components = URLComponents(string: url)!
        var request = URLRequest(url: components.url!)
        request.setValue("application/hal+json", forHTTPHeaderField: "Accept")
        request.httpMethod = "post"
        
        components.queryItems = [
            URLQueryItem(name: "type", value: "" ),
            URLQueryItem(name: "field_nombre_completo", value: ""),
            URLQueryItem(name: "field_fecha_de_nacimiento", value: ""),
            URLQueryItem(name: "field_correo_electronico", value: ""),
            URLQueryItem(name: "field_mensaje", value: "")
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                completion(nil, .invalidData)
                return
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            
            debugPrint(" response JSON \( String(describing: responseObject))")
        }
        task.resume()
    }
}

extension APIClient {
    private func toJsonData(data: Data) {
        do {
            let _ = try JSONSerialization.jsonObject(with: data, options: .allowFragments )
            debugPrint("String RESPONSE --------- \n \(String(data: data, encoding: String.Encoding.utf8)?.stringJSON() ?? "") \n --------------------------------------")
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
