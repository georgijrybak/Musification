//
//  SignUpWorker.swift
//  Musification
//
//  Created by Георгий Рыбак on 15.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
import Firebase

final class SignUpWorker {
    func registerUser(username: String, password: String, email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let error = error else {
                if let result = result {
                    let dataBase = Database.database().reference().child("users")
                    dataBase.child(result.user.uid).updateChildValues(["name": username, "email": email])

                    let currentUser = Auth.auth().currentUser
                    currentUser?.sendEmailVerification(completion: nil)

                    try? Auth.auth().signOut()
                    completion(error)
                }
                return
            }
            completion(error)
        }
    }
}
