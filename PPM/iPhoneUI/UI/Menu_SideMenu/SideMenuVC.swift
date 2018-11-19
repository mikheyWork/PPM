import UIKit
import Firebase

class SideMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: -variables
    var a = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func back2(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SideMenuVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell11", for: indexPath)
        cell.textLabel?.textColor  = .white
        cell.textLabel?.text = " "
        cell.textLabel?.font = UIFont(name: "Lato-Regular", size: 15)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Favourites"
        case 1:
            cell.textLabel?.text = "Send Feedback"
        case 2:
            cell.textLabel?.text = "Disclaimer"
        case 3:
            cell.textLabel?.text = "Subscription"
        case 4:
            cell.textLabel?.text = "Log Out"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "sideMenuShowFav", sender: indexPath)
        case 1:
            performSegue(withIdentifier: "sideMenuShowFeedB", sender: indexPath)
        case 2:
            performSegue(withIdentifier: "sideMenuShowDiscl", sender: indexPath)
        case 3:
            if a == 1 {
                performSegue(withIdentifier: "sideMenuShowSubs", sender: indexPath)
            } else {
                performSegue(withIdentifier: "sideMenuShowSubsAlready", sender: indexPath)
            }
        case 4:
            
            do {
              try Auth.auth().signOut()
            } catch {
                print(error.localizedDescription)
            }
            performSegue(withIdentifier: "LogOut", sender: indexPath)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogOut" {
            let vc = segue.destination as! LoginVC
            vc.path = false
            UserDefaults.standard.setValue(false, forKey: "saved2")
            
        }
    }
    
    
}
