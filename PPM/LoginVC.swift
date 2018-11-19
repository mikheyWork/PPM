import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var passLbl: UITextField!
    @IBOutlet weak var checkBut: UIButton!
    @IBOutlet weak var goBut: UIButton!
    
    var isChecmarkTaped = UserDefaults.standard.bool(forKey: "saved")
    var a: Int! = 0
    var path = UserDefaults.standard.bool(forKey: "saved2")
    
    var showSubAlert = false
    //fire
    var user: UserModel!
    var ref: DatabaseReference!
    var favor = Array<Favor>()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check sub
        //        print("subs3 is \(appDelegate.subscribtion)")
        
        
        
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        rangeChar()
        addTapGestureToHideKeyboard()
        buttonChang(senderButton: checkBut, senderSwitch: isChecmarkTaped)
        
        textFieldFont(text: "Email", textField: emailLbl, fontName: "Lato", fontSize: 14.0)
        textFieldFont(text: "Password", textField: passLbl, fontName: "Lato", fontSize: 14.0)
        
        
        //check sub
        if isChecmarkTaped == true {
            if path == true {
                
                var lis1 =  Auth.auth().addStateDidChangeListener { [weak self ] (auth, user) in
                    if user != nil {
                        self?.performSegue(withIdentifier: "cepia", sender: nil)
                    }
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        emailLbl.text = ""
        passLbl.text = ""
    }
    
    
    
    //nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
        goBut.layer.cornerRadius = 5
    }
    
    fileprivate func buttonChang(senderButton: UIButton,senderSwitch: Bool) {
        if senderSwitch == false {
            checkBut.setImage(UIImage(named: "Rectangle 11"), for: .normal)
        } else {
            
            checkBut.setImage(UIImage(named: "Artboard"), for: .normal)
        }
    }
    
    func showAlertError(title: String,withText: String) {
        let alert = UIAlertController(title: title, message: withText, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backBut(_ sender: Any) {
    }
    
    @IBAction func logibButTaped(_ sender: Any) {
        guard let email = emailLbl.text, let password = passLbl.text, email != "", password != ""  else {
            showAlertError(title: "Sign In Failed", withText: "Complete the fields.")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            
            self?.path = true
            UserDefaults.standard.setValue(self?.path, forKey: "saved2")
            if error != nil {
                print("error is\(String(describing: error?.localizedDescription))")
                if error?.localizedDescription == "The email address is badly formatted." {
                    self?.showAlertError(title: "Sign In Failed", withText: "Email must be a valid email address.")
                } else if error?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    self?.showAlertError(title: "Sign In Failed", withText: "Username was not found.")
                } else if error?.localizedDescription == "The password is invalid or the user does not have a password." {
                    self?.showAlertError(title: "Sign In Failed", withText: "Incorrect password.")
                } else {
                    
                    self?.showAlertError(title: "Sign In Failed", withText: "\((error?.localizedDescription)!)")
                    return
                }
            }
            
            
            if user != nil {
                self?.performSegue(withIdentifier: "cepia", sender: nil)
                return
//                print("user222 is \(user)")
            }
            self?.showAlertError(title: "Sign In Failed", withText: "Username was not found.")
        }
    }
    
    @IBAction func createAccBut(_ sender: Any) {
        
    }
    
    @IBAction func forgotPassBut(_ sender: Any) {
        
    }
    
    @IBAction func checkbutTaped(_ sender: Any) {
        
        if isChecmarkTaped == false {
            isChecmarkTaped = true
        } else {
            isChecmarkTaped = false
        }
        buttonChang(senderButton: checkBut, senderSwitch: isChecmarkTaped)
        UserDefaults.standard.setValue(isChecmarkTaped, forKey: "saved")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        print("models is \(appDelegate.model)")
        if appDelegate.model == "iPhone"{
            if segue.identifier == "cepia" {
                guard let currentUser = Auth.auth().currentUser else { return }
                user = UserModel(user: currentUser)
                ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("favor")
                let segVC = segue.destination as! CepiaVC
                segVC.showAlert = true
                DispatchQueue.main.async {
                    self.favorConnection()
                }
            }
        } else {
            if segue.identifier == "cepia" {
                guard let currentUser = Auth.auth().currentUser else { return }
                user = UserModel(user: currentUser)
                ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("favor")
                let segVC = segue.destination as! CepiaVCiPad
                segVC.showAlert = true
                DispatchQueue.main.async {
                    self.favorConnection()
                }
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

extension UIViewController {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldFont(text: String, textField: UITextField, fontName: String, fontSize: CGFloat) {
        var myMutableStringTitle = NSMutableAttributedString()
        let name  = text // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string:name, attributes: [NSAttributedString.Key.font:UIFont(name: fontName, size: fontSize)!])
        textField.attributedPlaceholder = myMutableStringTitle
    }
}
