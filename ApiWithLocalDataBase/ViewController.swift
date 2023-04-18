//
//  ViewController.swift
//  ApiWithLocalDataBase
//
//  Created by R&W on 15/02/23.
//

import UIKit
import Alamofire
import FMDB

class ViewController: UIViewController {
    
    var arrUser: [Users] = []
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
    }
    private func getUsers(){
        AF.request("https://gorest.co.in/public/v2/users", method: .get).responseData {  response in
            debugPrint("response \(response)")
            if response.response?.statusCode == 200{
                guard let apiData = response.data else {return}
                do{
                    self.arrUser = try JSONDecoder().decode([Users].self, from: apiData)
                }
                catch{
                    print(error.localizedDescription)
                }
            }else{
                print("Something went wrong")
            }
        }
    }
    @IBAction func saveButtonTab(_ sender: UIButton) {
        for i in arrUser{
            let query = "INSERT INTO userTable values ('\(i.id)','\(i.name)','\(i.email)','\(i.gender)','\(i.status)');"
            print(query)
            let dataBaseObject = FMDatabase(path: AppDelegate.dataBasePath)
            if dataBaseObject.open() {
                let result = dataBaseObject.executeUpdate(query, withArgumentsIn: [])
                if result == true{
                    nameLabel.text = "Data saved"
                }else{
                    nameLabel.text = "Data not saved"
                }
            }
            
        }
    }
}

struct Users: Decodable{
    var id: Double
    var name: String
    var email: String
    var gender: String
    var status: String
}
