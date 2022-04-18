//
//  SignInWorker.swift
//  Musification
//
//  Created by Георгий Рыбак on 11.02.22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Firebase

final class SignInWorker {
    func signIn(emailOrUsername: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: emailOrUsername, password: password) { _, error in
            completion(error)
        }
    }
}
