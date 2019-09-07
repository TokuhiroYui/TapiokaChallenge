//
//  ViewController.swift
//  TapiokaChallenge
//
//  Created by 徳弘佑衣 on 2019/09/07.
//  Copyright © 2019 徳弘佑衣. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    // MotionManager
    let motionManager = CMMotionManager()
    var speedX : CGFloat = 0.0
    var speedY : CGFloat = 0.0
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let image = UIImage.init(named: "tapioka1")
        imageView = UIImageView.init(image: image)
        imageView.center = self.view.center
        // タッチ操作を enable
        imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
        
        if motionManager.isAccelerometerAvailable {
            // 加速度センサーの値取得間隔
            motionManager.accelerometerUpdateInterval = 0.1
            
            // motionの取得を開始
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { (data, error) in
                // 取得した値をコンソールに表示
                print("x: \(String(describing: data?.acceleration.x)) y: \(String(describing: data?.acceleration.y)) z: \(String(describing: data?.acceleration.z))")
                
                self.getAcceleration(x:(data?.acceleration.x)! , y:(data?.acceleration.y)!)
            })
        }
    }
    func getAcceleration(x:Double,y:Double){
        speedX += CGFloat(x)
        speedY += CGFloat(y)
        var posX :CGFloat = imageView.center.x + speedX
        var posY :CGFloat = imageView.center.y + speedX
        
        //端にあたったら跳ね返る処理
        if (posX < 0.0) {
            posX = 0.0;
            
            //左の壁にあたったら0.4倍の力で跳ね返る
            speedX *= -0.4;
        } else if (posX > self.view.bounds.size.width) {
            posX = self.view.bounds.size.width;
            
            //右の壁にあたったら0.4倍の力で跳ね返る
            speedX *= -0.4;
        }
        if (posY < 0.0) {
            posY = 0.0;
            
            //上の壁にあたっても跳ね返らない
            speedY = 0.0;
        } else if (posY > self.view.bounds.size.height) {
            posY = self.view.bounds.size.height;
            
            //下の壁にあたったら1.5倍の力で跳ね返る
            speedY *= -1.5;
        }
        imageView.center = CGPoint(x:posX, y:posY)
    }
    
    // 画面にタッチで呼ばれる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        
    }
    //　ドラッグ時に呼ばれる
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチイベントを取得
        let touchEvent = touches.first!
        
        // ドラッグ前の座標, Swift 1.2 から
        let preDx = touchEvent.previousLocation(in: self.view).x
        let preDy = touchEvent.previousLocation(in: self.view).y
        
        // ドラッグ後の座標
        let newDx = touchEvent.location(in: self.view).x
        let newDy = touchEvent.location(in: self.view).y
        
        // ドラッグしたx座標の移動距離
        let dx = newDx - preDx
        print("x:\(dx)")
        
        // ドラッグしたy座標の移動距離
        let dy = newDy - preDy
        print("y:\(dy)")
        
        // 画像のフレーム
        var viewFrame: CGRect = imageView.frame
        
        // 移動分を反映させる
        viewFrame.origin.x += dx
        viewFrame.origin.y += dy
        
        imageView.frame = viewFrame
        
        self.view.addSubview(imageView)
        
    }
    
}
