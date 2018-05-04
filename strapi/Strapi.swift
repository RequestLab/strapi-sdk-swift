//
//  Strapi.swift
//  strapi
//
//  Created by lgriffie on 02/05/2018.
//  Copyright © 2018 RequestLab. All rights reserved.
//

import Foundation
import Alamofire

/// The Strapi manager is responsible for calling strapi APIs.
public class Strapi {
    private var manager: SessionManager = SessionManager.default

    private func set(token: String) {
        let headers = [
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers

        if #available(iOS 11.0, *) {
            configuration.waitsForConnectivity = true
        }

        let sessionDelegate = SessionDelegate()

        sessionDelegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            var finalRequest = request
            finalRequest.allHTTPHeaderFields = headers

            return finalRequest
        }

        manager = SessionManager(configuration: configuration, delegate: sessionDelegate)
    }

    /// baseURL is the server URL that will be used for the request
    public let baseURL: String

    public init(baseURL: String) {
        self.baseURL = baseURL
    }

    /**
     Register a new user.
     - parameters:
     - username
     - email
     - password
     - success
     - failure
     */
    public func register(username: String,
                         email: String,
                         password: String,
                         success: (@escaping (_ jwt: String, _ user: [String: Any]) -> Void),
                         failure: (@escaping (_ error: Error) -> Void)) {
        let parameters = [
            "username": username,
            "email": email,
            "password": password
        ]

        manager
            .request("\(baseURL)/auth/local/register", method: .post, parameters: parameters)
            .validate(statusCode: 200...200)
            .responseJSON(completionHandler: { [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.result.value as? [String: Any],
                        let jwt = data["jwt"] as? String,
                        let user = data["user"] as? [String: Any] else {
                            return
                    }

                    self?.set(token: jwt)
                    success(jwt, user)
                case .failure(let error):
                    failure(error)
                }
            })
    }

    /**
     Login by getting an authentication token.
     - parameters:
     - identifier: Can either be an email or a username.
     - password
     - success
     - failure
     */
    public func login(identifier: String,
                      password: String,
                      success: (@escaping (_ jwt: String, _ user: [String: Any]) -> Void),
                      failure: (@escaping (_ error: Error) -> Void)) {
        let parameters = [
            "identifier": identifier,
            "password": password
        ]

        manager
            .request("\(baseURL)/auth/local", method: .post, parameters: parameters)
            .validate(statusCode: 200...200)
            .responseJSON(completionHandler: { [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.result.value as? [String: Any],
                        let jwt = data["jwt"] as? String,
                        let user = data["user"] as? [String: Any] else {
                            return
                    }

                    self?.set(token: jwt)
                    success(jwt, user)
                case .failure(let error):
                    failure(error)
                }
            })
    }

    /**
     Logout current authenticated user and clear JWT token.
     - parameters:
     - success
     */
    public func logout(success: (@escaping () -> Void)) {
        manager = SessionManager.default
        success()
    }

    /**
     Create a data model object.
     - parameters:
     - model
     - parameters
     - success
     - failure
     */
    public func create(entry model: String,
                       _ parameters: [String: Any],
                       success: (@escaping (_ objects: [String: Any]) -> Void),
                       failure: (@escaping (_ error: Error) -> Void)) {
        manager
            .request("\(baseURL)/\(model)", method: .post, parameters: parameters)
            .validate(statusCode: 200...200)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    guard let data = response.result.value as? [String: Any] else {
                        return
                    }
                    success(data)
                case .failure(let error):
                    failure(error)
                }
            })
    }

    /**
     Get all given data model objects.
     - parameters:
     - model
     - success
     - failure
     */
    public func all(entries model: String,
                    success: (@escaping (_ objects: [[String: Any]]) -> Void),
                    failure: (@escaping (_ error: Error) -> Void)) {
        manager
            .request("\(baseURL)/\(model)", method: .get)
            .validate(statusCode: 200...200)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    guard let data = response.result.value as? [[String: Any]] else {
                        return
                    }
                    success(data)
                case .failure(let error):
                    failure(error)
                }
            })
    }

    /**
     Get a given data model object.
     - parameters:
     - model
     - id
     - success
     - failure
     */
    public func get(entry model: String,
                    _ id: String,
                    success: (@escaping (_ objects: [String: Any]) -> Void),
                    failure: (@escaping (_ error: Error) -> Void)) {
        manager
            .request("\(baseURL)/\(model)/\(id)", method: .get)
            .validate(statusCode: 200...200)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    guard let data = response.result.value as? [String: Any] else {
                        return
                    }
                    success(data)
                case .failure(let error):
                    failure(error)
                }
            })
    }

    /**
     Get all given data model objects.
     - parameters:
     - model
     - id
     - parameters
     - success
     - failure
     */
    public func update(entry model: String,
                       _ id: String,
                       _ parameters: [String: Any],
                       success: (@escaping (_ objects: [String: Any]) -> Void),
                       failure: (@escaping (_ error: Error) -> Void)) {
        manager
            .request("\(baseURL)/\(model)/\(id)", method: .put, parameters: parameters)
            .validate(statusCode: 200...200)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    guard let data = response.result.value as? [String: Any] else {
                        return
                    }
                    success(data)
                case .failure(let error):
                    failure(error)
                }
            })
    }

    /**
     Delete a given data model object.
     - parameters:
     - model
     - id
     - success
     - failure
     */
    public func delete(entry model: String,
                       _ id: String,
                       success: (@escaping (_ objects: [String: Any]) -> Void),
                       failure: (@escaping (_ error: Error) -> Void)) {
        manager
            .request("\(baseURL)/\(model)/\(id)", method: .delete)
            .validate(statusCode: 200...200)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    guard let data = response.result.value as? [String: Any] else {
                        return
                    }
                    success(data)
                case .failure(let error):
                    failure(error)
                }
            })
    }

    /**
     Get all files objects.
     - parameters:
        - success
        - failure
     */
    public func files(success: (@escaping (_ objects: [[String: Any]]) -> Void),
                      failure: (@escaping (_ error: Error) -> Void)) {
        manager
            .request("\(baseURL)/upload/files", method: .get)
            .validate(statusCode: 200...200)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    guard let data = response.result.value as? [[String: Any]] else {
                        return
                    }
                    success(data)
                case .failure(let error):
                    failure(error)
                }
            })
    }

    /**
     Get all files objects.
     - parameters:
        - id
        - success
        - failure
     */
    public func file(_ id: String,
                     success: (@escaping (_ objects: [String: Any]) -> Void),
                     failure: (@escaping (_ error: Error) -> Void)) {
        manager
            .request("\(baseURL)/upload/files/\(id)", method: .get)
            .validate(statusCode: 200...200)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    guard let data = response.result.value as? [String: Any] else {
                        return
                    }
                    success(data)
                case .failure(let error):
                    failure(error)
                }
            })
    }

    /**
     Upload files objects.
     - parameters:
        - files
        - progress
        - success
        - failure
     */
    public func upload(files: [Data],
                       progress: @escaping (_ progress: Double) -> Void,
                       success: (@escaping (_ objects: [[String: Any]]) -> Void),
                       failure: (@escaping (_ error: Error) -> Void)) {
        manager.upload(multipartFormData: { multipartFormData in
            files.forEach({ file in
                multipartFormData.append(file, withName: "files", fileName: "\(UUID().uuidString).jpeg", mimeType: file.mimeType)
            })
        }, usingThreshold: UInt64(), to: "\(baseURL)/upload", method: .post, encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { uploadProgress in
                    progress(uploadProgress.fractionCompleted)
                })

                upload.responseJSON(completionHandler: { response in
                    guard let data = response.result.value as? [[String: Any]] else {
                        return
                    }
                    success(data)
                })
            case .failure(let error):
                failure(error)
            }
        })
    }
}
