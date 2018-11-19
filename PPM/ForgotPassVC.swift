import UIKit
import Firebase

class ForgotPassVC: UIViewController {
    
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var reqBut: UIButton!
    
    var auth = Auth.auth();
    var emailAddress = "user@example.com";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeChar()
        addTapGestureToHideKeyboard()
    }
    
    
    //nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
        reqBut.layer.cornerRadius = 5
    }
    
    func showAlertError(title: String, withText: String) {
        let alert = UIAlertController(title: title, message: withText, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func requestBut(_ sender: Any) {
        
        guard emailLbl.text != "" else { return }
        
        Auth.auth().sendPasswordReset(withEmail: emailLbl.text!) { [weak self] (error) in
            
            if error == nil{
                self?.emailLbl.text = ""
                self?.showAlertError(title: "Success request", withText: "Email sent successfully")
            } else {
                //                print("error is \(error?.localizedDescription)")
                self?.showAlertError(title: "Request is failed", withText: "\((error?.localizedDescription)!)")
            }
            
            if error != nil {
                print("error is\(String(describing: error?.localizedDescription))")
                if error?.localizedDescription == "The email address is badly formatted." {
                    self?.showAlertError(title: "Reset In Failed", withText: "Email must be a valid email address.")
                } else if error?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    self?.showAlertError(title: "Reset In Failed", withText: "Username was not found.")
                } else if error?.localizedDescription == "The password is invalid or the user does not have a password." {
                    self?.showAlertError(title: "Reset In Failed", withText: "Incorrect password.")
                } else {
                    
                    self?.showAlertError(title: "Reset In Failed", withText: "\((error?.localizedDescription)!)")
                    return
                }
                
            }
            
        }
    }
        
        @IBAction func backBut(_ sender: Any) {
            navigationController?.popViewController(animated: true)
        }
        
        
}
