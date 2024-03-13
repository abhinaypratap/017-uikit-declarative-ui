import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal

        let navigationManager = NavigationManager()
        navigationManager.fetch { initialScreen in
            let vc = TableScreen(screen: initialScreen)
            vc.navigationManager = navigationManager
            self.navigationController?.viewControllers = [vc]
        }
    }
}
