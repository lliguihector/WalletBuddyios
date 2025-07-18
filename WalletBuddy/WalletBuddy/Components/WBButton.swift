//
//  WBButton.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/10/25.
//

import UIKit

class WBButton: UIButton {

    
    
    
    
    override init(frame: CGRect){
     
        super.init(frame: frame)
            //Custome code 
            
        }
    
    //IF your view loads from a storyboard or XIB, you must also implement this initializer.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        //Custome Code
    }
    
    
    //Custome initializer
    init(backgroundColor: UIColor, title: String){
        
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
        
        
        
    }
    
    
    private func configure(){
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        self.setTitleColor(.white, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
  
    
    
    
    
    
    
    
    
    
    
    
}
