//
//  LobbyViewController.swift
//  Techmon
//
//  Created by Koutaro Matsushita on 2021/09/05.
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var staminaLabel:UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var stamina:Int = 100
    var staminaTimer:Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "勇者"
        staminaLabel.text = String(stamina)+"/100"
        
        staminaTimer = Timer.scheduledTimer(timeInterval: 3.0,
                                            target: self,
                                            selector:#selector(self.updateStaminaValue),
                                            userInfo: nil,
                                            repeats: true)
        
        staminaTimer.fire()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        techMonManager.playBGM(fileName: "lobby")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @IBAction func toBattle(){
        if stamina >= 50{
            stamina -= 50
            staminaLabel.text = "\(stamina)/100"
            performSegue(withIdentifier: "toBattle", sender: nil)
        }else{
            
            let alert:UIAlertController = UIAlertController(title: "バトルにいけません",
                                                          message: "スタミナが足りません",
                                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func updateStaminaValue(){
        if stamina < 100{
            stamina += 1
            staminaLabel.text="\(stamina)/100"
        }
    }

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
