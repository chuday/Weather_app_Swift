//
//  LoginViewController.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
// 

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    
    var interactiveAnimator: UIViewPropertyAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Авторизация"
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(recognizer)
        adjustInitialLoginPasswordPositions()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        passwordField.isSecureTextEntry = true
        
        adjustInitialLoginPasswordPositions()
    }
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case .began:
                interactiveAnimator?.startAnimation()
                
                interactiveAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                             dampingRatio: 0.5,
                                                             animations: {
                                                                self.loginButton.transform = CGAffineTransform(translationX: 0,
                                                                                                              y: 150)
                                                             })
                
                interactiveAnimator.pauseAnimation()
            case .changed:
                let translation = recognizer.translation(in: self.view)
                interactiveAnimator.fractionComplete = translation.y / 100
            case .ended:
                interactiveAnimator.stopAnimation(true)
                
                interactiveAnimator.addAnimations {
                    self.loginButton.transform = .identity
                }
                
                interactiveAnimator.startAnimation()
            default: return
        }
    }
    
    private func adjustInitialLoginPasswordPositions() {
        let offset = abs(self.loginTitleLabel.frame.midY - self.passwordTitleLabel.frame.midY)
        
        self.loginTitleLabel.transform = CGAffineTransform(translationX: 0, y: offset)
        self.passwordTitleLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
    }
    
    private func performLoginPasswordFieldsAnimation() {
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        
        let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.stiffness = 150
        scaleAnimation.mass = 2
        
        let animationsGroup = CAAnimationGroup()
        animationsGroup.duration = 1
        animationsGroup.beginTime = CACurrentMediaTime() + 1
        animationsGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationsGroup.fillMode = CAMediaTimingFillMode.backwards
        animationsGroup.animations = [fadeInAnimation, scaleAnimation]
        
        self.loginField.layer.add(animationsGroup, forKey: nil)
        self.passwordField.layer.add(animationsGroup, forKey: nil)
    }
    
    private func performLoginPasswordTitlesAnimation() {
        UIView.animateKeyframes(
            withDuration: 1,
            delay: 1,
            options: .calculationModeCubicPaced,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0,
                                   relativeDuration: 0.5,
                                   animations: {
                                    self.loginTitleLabel.transform = CGAffineTransform(translationX: 150, y: 50)
                                    self.passwordTitleLabel.transform = CGAffineTransform(translationX: -150, y: -50)
                                   })
                UIView.addKeyframe(withRelativeStartTime: 0.5,
                                   relativeDuration: 0.5,
                                   animations: {
                                    self.loginTitleLabel.transform = .identity
                                    self.passwordTitleLabel.transform = .identity
                                   })
            }, completion: nil
        )
    }
    
    private func performTitleLabelAnimation() {
        self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height / 2)
        let animator = UIViewPropertyAnimator(duration: 1,
                                              dampingRatio: 0.5,
                                              animations: {
                                                self.titleLabel.transform = .identity
                                              })
        animator.startAnimation(afterDelay: 1)
    }


    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performLoginButtonAnimations()
        performLoginPasswordTitlesAnimation()
        performLoginPasswordFieldsAnimation()
        performTitleLabelAnimation()
    }
    
    @IBAction func onButtonTapped(_ sender: Any) {
       
    }
    
    @IBAction func backToLogin(unwindSegue: UIStoryboardSegue) {}
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toMain" {
            if loginField.text == "admin",
               passwordField.text == "123456" {
                print("Password correct")
                return true
            } else {
                showErrorAlert()
                print("Access denied")
                return false
            }
        } else {
            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Неверные данные",
                                      preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK",
                               style: .cancel,
                               handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        let contentInsets = UIEdgeInsets(top: 0.0,
                                         left: 0.0,
                                         bottom: kbSize.height,
                                         right: 0.0)

        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
@objc func keyboardWillBeHidden(notification: Notification) {
    let contentInsets = UIEdgeInsets.zero
    scrollView?.contentInset = contentInsets
}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector:#selector(self.keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    private func performPasswordLabelAnimation() {
        passwordTitleLabel.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        UIView.animate(withDuration: 2, delay: 1, options: [ .curveLinear]) {
            self.passwordTitleLabel.transform = .identity
        } completion: { success in
            
        }
    }
    
    private func performLoginButtonAnimations() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.2
        animation.toValue = 1
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = .backwards
        animation.stiffness = 200
        animation.mass = 0.5
        animation.damping = 0.9
        loginButton.layer.add(animation, forKey: nil)
        
        let opacityAnamation = CABasicAnimation(keyPath: "opacity")
        opacityAnamation.fromValue = 0
        opacityAnamation.toValue = 1
        opacityAnamation.duration = 0.5
        opacityAnamation.beginTime = CACurrentMediaTime() + 1
        opacityAnamation.fillMode = .backwards
        loginButton.layer.add(opacityAnamation, forKey: nil)
    }
    
}
