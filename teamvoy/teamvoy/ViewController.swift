//
//  ViewController.swift
//  teamvoy
//
//  Created by Roman Mykitchak on 2/1/17.
//  Copyright © 2017 Roman Mykitchak. All rights reserved.
//

import UIKit
import Alamofire

//urn:ietf:wg:oauth:2.0:oob
//urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob
//"https://www.unsplash.com/oauth/authorize?client_id=dcb9cd06a7bba25e602808e656181b9ef80a868dee7047148d4570ae65fbe6b7&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&scope=public+read_user+write_user+read_photos+write_photos+write_likes+read_collections+write_collections"
class ViewController: UIViewController , UIWebViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var webView: UIWebView!
    var searches : Array<Any> = []
    var token : String = "no token"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webLoad()
        self.getToken()
        //self.loadImages()
    }
    
    func webLoad() {
        let str = "https://www.unsplash.com/oauth/authorize?client_id=dcb9cd06a7bba25e602808e656181b9ef80a868dee7047148d4570ae65fbe6b7&response_type=code&scope=public+read_user+write_user+read_photos+write_photos+write_likes+read_collections+write_collections"
        let url = URL (string: str)
        //        let url = URL (string: "http://www.google.com")
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
    }
    
    func loadImages() -> Array<Any> {
        let headers: HTTPHeaders = [
            "Accept-Version": "v1",
            "Authorization": "Bearer "+self.token
        ]
        
        Alamofire.request("https://unsplash.com/photos",
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: headers).responseJSON { response in
                            debugPrint(response)
                            //to get status code
                            if let status = response.response?.statusCode {
                                switch(status){
                                case 201, 200:
                                    print("loadImages success")
                                    //to get JSON return value
                                    if let result = response.result.value {
                                        let JSON = result as! NSDictionary
                                        print(JSON)
                                    }
                                default:
                                    print("loadImages error with response status: \(status)")
                                }
                            }
                            
        }
        
        return Array()
    }
    
    func getToken() -> String {
        let headers: HTTPHeaders = [
            "Accept-Version": "v1"
        ]
        
        let parameters: Parameters = [
            "client_id": "dcb9cd06a7bba25e602808e656181b9ef80a868dee7047148d4570ae65fbe6b7",
            "client_secret": "44eae35c9372829b48be79cd01005cc0b977bb65e635627cf9b8b196c67503eb",
            "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
            "code" : "a33f5f0634e9c3ed10df0ef74446252d7bdce88acaf07ba72df903b05f34e2d6",
            "grant_type" : "authorization_code"
            ]
        
        Alamofire.request("https://unsplash.com/oauth/token",
                          method: .post,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: headers).responseJSON { response in
                            debugPrint(response)
                            //to get status code
                            if let status = response.response?.statusCode {
                                switch(status){
                                case 201, 200:
                                    print("getToken success")
                                    //to get JSON return value
                                    if let result = response.result.value {
                                        let JSON = result as! NSDictionary
                                        print(JSON)
                                        let gotToken:String = JSON["access_token"] as! String
                                        self.token = gotToken
                                        self.loadImages()
                                    }
                                default:
                                    print("getToken error with response status: \(status)")
                                }
                            }
                            
        }
        return "getToken"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("webView request")
        print(request)
        return true
    }
    
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return searches.count
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath)
        cell.backgroundColor = UIColor.black
        // Configure the cell
        return cell
    }

}

