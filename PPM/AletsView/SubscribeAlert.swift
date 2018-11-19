import UIKit
import GTProgressBar
import Firebase

class SubscribeAlert: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var subscribeBut: UIButton!
    
    @IBOutlet weak var cancelBut: UIButton!
    
    var progressBar = GTProgressBar()
    var ref: DatabaseReference!
    var user: UserModel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: currentUser)
        
        alertView.layer.cornerRadius = 15
        subscribeBut.layer.cornerRadius = 5
        cancelBut.layer.cornerRadius = 5
        cancelBut.layer.borderWidth = 1
        cancelBut.layer.borderColor = UIColor(displayP3Red: 175/255, green: 187/255, blue: 201/255, alpha: 1).cgColor
    }
    
    override func viewWillLayoutSubviews() {
                if appDelegate.closeCheckData == true {
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    func showSub(nameVC: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: nameVC)
        
        vc?.view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        self.addChild(vc!)
        self.view.addSubview((vc?.view)!)
    }
    
    @IBAction func subscribeButTaped(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
        IAPService.shared.purchase(product: .autoRenewingSubs)
            self.ref  = Database.database().reference(withPath: "users").child((self.user.uid)).child("subscription")
            self.ref.setValue(["subscription": self.appDelegate.subscribtion])
            
        }
        
        
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    @IBAction func cancelButTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    
}
