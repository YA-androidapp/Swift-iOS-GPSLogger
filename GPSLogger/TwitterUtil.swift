//
//  TwitterUtil.swift
//  GPSLogger
//
//  Created by Yu on 2021/09/07.
//

import Foundation
import Swifter

class TwitterUtil{
    func tweet(message: String) {
        let consumerKey = UserDefaults.standard.string(forKey: "consumerKey") ?? ""
        let consumerSecret = UserDefaults.standard.string(forKey: "consumerSecret") ?? ""
        let accessKey = UserDefaults.standard.string(forKey: "accessKey") ?? ""
        let accessSecret = UserDefaults.standard.string(forKey: "accessSecret") ?? ""
        
        if accessKey == "" || accessSecret == "" {
            let swifter = Swifter(consumerKey: consumerKey, consumerSecret: consumerSecret)
            let callbackUrl = URL(string: "swifter-"+consumerKey+"://")
            
            if consumerKey != "" && consumerSecret != "" && callbackUrl != nil{
                swifter.authorize(
                    with: callbackUrl!,
                    success: { accessToken, response in
                        print(response)
                        guard let accessToken = accessToken else { return }
                        UserDefaults.standard.set(accessToken.key, forKey: "accessKey")
                        UserDefaults.standard.set(accessToken.secret, forKey: "accessSecret")
                        self.tweet()
                    }, failure: { error in
                        print(error)
                    })
            }
            
        } else {
        }
    }
}
