//
//  RegistrVC.swift
//  WP.m.1
//
//  Created by softevol on 9/13/18.
//  Copyright © 2018 softevol. All rights reserved.
//

import UIKit
import Firebase

class RegistrVC: UIViewController {
    
    var ref: DatabaseReference!
    var user: UserModel!
    var refSub: DatabaseReference!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    @IBOutlet weak var rePassText: UITextField!
    @IBOutlet weak var goBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeChar()
        emailText.layer.cornerRadius = 5
        addTapGestureToHideKeyboard()
        
        ref = Database.database().reference(withPath: "users")
    }
    
    //nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
        goBut.layer.cornerRadius = 5
    }
    
    func showAlertError(title: String, withText: String) {
        let alert = UIAlertController(title: title, message: withText, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registrBut(_ sender: Any) {
        guard let email = emailText.text, let password = passwordText.text, email != "", password != "", rePassText.text != ""  else {
            showAlertError(title: "Create Account Failed", withText: "Complete the fields.")
            return
        }
        
        if password != rePassText.text {
            showAlertError(title: "Create Account Failed", withText: "Passwords don’t match.")
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            
            if error != nil {
                if error?.localizedDescription == "The email address is badly formatted." {
                    self?.showAlertError(title: "Create Account Failed", withText: "Invalid email address.")
                } else {
                    self?.showAlertError(title: "Create Account Failed", withText: (error?.localizedDescription)!)
                }
                return
            }
            
            guard error == nil, user != nil else  {
                print(error?.localizedDescription ?? "error")
                return
            }
            
            
            let userRef  = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email": user?.user.email])
            
            self!.performSegue(withIdentifier: "loginAfterRegister", sender: nil)
            
            //alert
//            let alert = UIAlertController(title: "Register", message: "Congratulation.", preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (user) in
//                for controller in self!.navigationController!.viewControllers as Array {
//                    if controller.isKind(of: LoginVC.self) {
//                        self!.navigationController!.popToViewController(controller, animated: true)
//                        break
//                    }
//                }
//            })
//            alert.addAction(cancelAction)
//
//            self?.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func backBut(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        appDelegate.subscribtion = false
        if appDelegate.model == "iPhone"{
            if segue.identifier == "loginAfterRegister" {
                guard let currentUser = Auth.auth().currentUser else { return }
                user = UserModel(user: currentUser)
                ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("favor")
                let segVC = segue.destination as! CepiaVC
                segVC.showAlert = true
                DispatchQueue.main.async {
                    self.favorConnection()
                }
                self.refSub  = Database.database().reference(withPath: "users").child((self.user.uid)).child("subscription")
                self.refSub.setValue(["subscription": self.appDelegate.subscribtion])
            }
        } else {
            if segue.identifier == "loginAfterRegister" {
                guard let currentUser = Auth.auth().currentUser else { return }
                user = UserModel(user: currentUser)
                ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("favor")
                let segVC = segue.destination as! CepiaVCiPad
                segVC.showAlert = true
                DispatchQueue.main.async {
                    self.favorConnection()
                }
                self.refSub  = Database.database().reference(withPath: "users").child((self.user.uid)).child("subscription")
                self.refSub.setValue(["subscription": self.appDelegate.subscribtion])
            }
        }
    }
    fileprivate func favorConnection() {
        var _favor = Array<Favor>()
        
        ref.observe(.value) { (snapshot) in
            
            
            for item in snapshot.children {
                let favor = Favor(snapShot: item as! DataSnapshot)
                _favor.append(favor)
            }
            
            for i in _favor {
                for j in i.favArray {
                    
                    if self.appDelegate.favourites.contains(where: {$0 == j}) == false {
                        self.appDelegate.favourites.append(j)
                    }
                }
            }
            UserDefaults.standard.set(self.appDelegate.favourites, forKey: "favorArr")
            
        }
        
        var value: Int!
        //disc
        let ref3 = Database.database().reference(withPath: "users").child((self.user.uid)).child("disclaimer")
        ref3.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let discl = item as! DataSnapshot
                value = discl.value as? Int
                if value == 1 {
                    self.appDelegate.showDisc = true
                } else {
                    self.appDelegate.showDisc = false
                }
            }
        }
    }
}
