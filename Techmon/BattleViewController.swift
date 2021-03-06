//
//  BattleViewController.swift
//  Techmon
//
//  Created by Koutaro Matsushita on 2021/09/05.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel:UILabel!
    @IBOutlet var playerImageView:UIImageView!
    @IBOutlet var playerHPLabel:UILabel!
    @IBOutlet var playerMPLabel:UILabel!
    @IBOutlet var playerTPLabel:UILabel!
    
    @IBOutlet var enemyNameLabel:UILabel!
    @IBOutlet var enemyImageView:UIImageView!
    @IBOutlet var enemyHPLabel:UILabel!
    @IBOutlet var enemyMPLabel:UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var player:Character!
    var enemy:Character!
    
    var gameTimer:Timer!
    var isPlayerAttackAvailable:Bool=true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player=techMonManager.player
        enemy=techMonManager.enemy
        
        playerNameLabel.text=player.name
        playerImageView.image=player.image
        
        enemyNameLabel.text=enemy.name
        enemyImageView.image=enemy.image
        
        updateUI()
        
        gameTimer=Timer.scheduledTimer(timeInterval: 0.1,
                                       target: self,
                                       selector: #selector(updateGame),
                                       userInfo: nil,
                                       repeats: true)
        gameTimer.fire()


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @objc func updateGame(){
        player.currentMP += 1
        
        if player.currentMP >= player.maxMP{
            isPlayerAttackAvailable = true
            player.currentMP = player.maxMP
        }else{
            isPlayerAttackAvailable = false
        }
        
        enemy.currentMP += 1
        
        if enemy.currentMP >= enemy.maxMP{
            enemyAttack()
            enemy.currentMP = 0
        }

        updateUI()
    }
    
    func enemyAttack(){
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= enemy.attackPoint
        judgeBattle()
        
    }
    
    func finishBattle(vanishImageView:UIImageView,isPlayerWin:Bool){
        
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage:String = ""
        
        if isPlayerWin{
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "???????????????"
        }else{
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "???????????????..."
        }
        
        let alert=UIAlertController(title: "???????????????",
                                    message: finishMessage,
                                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: {_ in
                                        self.dismiss(animated: true, completion: nil)
                                      }))
        present(alert, animated: true, completion: nil)
        
        player.resetStatus()
        enemy.resetStatus()
    }
    
    @IBAction func attackAction(){
        if isPlayerAttackAvailable{
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            enemy.currentHP-=player.attackPoint
            
            player.currentTP += 10
            if player.currentTP >= player.maxTP{
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
            
            judgeBattle()
            }
        
        
    }
    
    @IBAction func tameruAction(){
        if isPlayerAttackAvailable{
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            if player.currentTP >= player.maxTP{
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
        }
    }
    
    @IBAction func fireAction(){
        if isPlayerAttackAvailable && player.currentTP >= 40{
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP -= 100
            
            player.currentTP -= 40
            if player.currentTP <= 0{
                player.currentTP = 0
            }
            player.currentMP = 0
            
            judgeBattle()
        }
    }
    
    func updateUI(){
        playerHPLabel.text = "\(player.currentHP)/\(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP)/\(player.maxMP)"
        playerTPLabel.text = "\(player.currentTP)/\(player.maxTP)"
        enemyHPLabel.text = "\(enemy.currentHP)/\(enemy.maxHP)"
        enemyMPLabel.text="\(enemy.currentMP)/\(enemy.maxMP)"
    }
    
    func judgeBattle(){
        if player.currentHP <= 0{
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }else if enemy.currentHP <= 0{
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
        
    }
    
    
    
}
