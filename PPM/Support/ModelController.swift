import UIKit

class ModelController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let model = UIDevice.current.model
        if model == "iPhone" {
            performSegue(withIdentifier: "showiPhone", sender: nil)
        } else {
            performSegue(withIdentifier: "showiPad", sender: nil)
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "abc" {
        }
    }

}
