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
     
    func request<T: Decodable>(api : String, someClass: T.Type, param : Parameters = [:], method: Alamofire.HTTPMethod = .get, urlBase: String = baseURL , completion: @escaping (T?, ErrorHandler?) -> Void) {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "x-api-key ": "dbbe77b1-31dd-4976-b914-dd8914b20b1c"
        ]
        Alamofire.request( urlBase + api , method: method, parameters: param, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            print(response.response?.statusCode ?? -1)
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
}
 
extension APIClient {
    private func toJsonData(data: Data) {
        do {
            let _ = try JSONSerialization.jsonObject(with: data, options: .allowFragments )
            print("String RESPONSE --------- \n \(String(data: data, encoding: String.Encoding.utf8)?.stringJSON() ?? "") \n --------------------------------------")
        } catch {
            print(error.localizedDescription)
        }
    }
}
