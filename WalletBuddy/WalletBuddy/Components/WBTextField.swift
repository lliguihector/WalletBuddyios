//
//  WBTextField.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/9/25.
//

import UIKit

    class WBTextField: UITextField {
        
        enum FieldType {
            case username
            case password
        }
        
        private var visibilityToggleButton: UIButton?
        
        init(type: FieldType, iconName: String? = nil) {
            super.init(frame: .zero)
            
            
            configure(for: type, iconName: iconName)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configure(for type: FieldType, iconName: String?) {
            translatesAutoresizingMaskIntoConstraints = false
            layer.cornerRadius = 8   //👈 Corener Radius
            layer.borderWidth  = 1   //👈 Border Width
            layer.borderColor  = UIColor.black.cgColor //👈 Border Color
            
            textColor = .label
            tintColor = .label
            
            textAlignment = .left       //Text Alignement
            font = UIFont.preferredFont(forTextStyle: .title2)  //Text Font
            adjustsFontSizeToFitWidth = true
            minimumFontSize = 12
            backgroundColor = .tertiarySystemBackground
            autocorrectionType = .no     //Auto correction OFF
            
            autocapitalizationType = .none //Auto Capitalization OFF
            
            switch type {
            case .username:
                placeholder = "Username"
                isSecureTextEntry = false
                keyboardType = .default
                returnKeyType = .next
                
            case .password:
                placeholder = "Password"
                isSecureTextEntry = true
                keyboardType = .default
                returnKeyType = .go
                addPasswordToggleIcon()
            }
            
            
            
            if let iconName = iconName {
                setLeftIcon(named: iconName)
            }
        }
        
        
        private func setLeftIcon(named systemName: String){
            let iconView = UIImageView(image: UIImage(systemName: systemName))
 

            iconView.tintColor = .gray  //👈 Icon Color 
            iconView.contentMode = .scaleAspectFit
            iconView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 24))
            containerView.addSubview(iconView)
            iconView.center = containerView.center
            
            leftView = containerView
            leftViewMode = .always

        }
        
        private func addPasswordToggleIcon(){
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            button.tintColor = .darkGray
            button.frame = CGRect(x: 0,y:0,width:24, height:24)
            
            
            //Toggle visibility on top
            button.addTarget(self, action: #selector(tooglePasswordVisibility), for: .touchUpInside)
            
            
            //Wrap the button in a container view to add padding
            let containerView = UIView(frame: CGRect( x: 0, y: 0, width: 40, height: 24))
            button.center = containerView.center
            containerView.addSubview(button)
            
            
            rightView = containerView
            rightViewMode = .always
           visibilityToggleButton = button
            
        }
        
        
        @objc private func tooglePasswordVisibility(){
            
            animateCircleBehindIcon()
            
            isSecureTextEntry.toggle()
            
            //Update icon with animation
            let iconName = isSecureTextEntry ? "eye.slash" : "eye"
            UIView.transition(with: visibilityToggleButton ?? UIButton(), duration: 0.2, options: .transitionCrossDissolve, animations: {
                
                self.visibilityToggleButton?.setImage(UIImage(systemName: iconName), for: .normal)
                
            })
            
            //Fix for blinking cursor/reset bug
            if let existingText = text{
                text = ""
                insertText(existingText)
            }
            
            
        }
        
        
        private func animateCircleBehindIcon() {
            guard let button = visibilityToggleButton else { return }

            let circle = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
            circle.center = button.center
            circle.layer.cornerRadius = 20
            circle.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            circle.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            circle.alpha = 0

            // Add to button's superview
            if let superview = button.superview {
                superview.insertSubview(circle, belowSubview: button)

                UIView.animate(withDuration: 0.1, animations: {
                    circle.transform = .identity
                    circle.alpha = 1
                }) { _ in
                    UIView.animate(withDuration: 0.1, animations: {
                        circle.alpha = 0
                    }) { _ in
                        circle.removeFromSuperview()
                    }
                }
            }
        }

        
    }
