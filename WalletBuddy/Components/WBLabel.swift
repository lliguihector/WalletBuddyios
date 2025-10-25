//
//  WBLabel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/22/25.
//

import UIKit

class WBLabel: UILabel {

    
    override init(frame: CGRect){
        
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(title: String){
        super.init(frame: .zero)
        self.text = title
        
        configure()
    }
    
    
    private func configure(){
        
        // Use system font, size 14, medium weight (common for form labels)
           self.font = UIFont.systemFont(ofSize: 14, weight: .medium)
           
           // Dark gray text color (can be adjusted to your app's theme)
           self.textColor = UIColor.darkGray
           
           // Single line label, no shrinking font size
           self.numberOfLines = 1
           self.adjustsFontSizeToFitWidth = false
           
           // Optional: Uppercase text style if you want
           // self.text = self.text?.uppercased()
           
           // Optional: Slight letter spacing (kerning)
           let attributedText = NSMutableAttributedString(string: self.text ?? "")
           attributedText.addAttribute(.kern, value: 0.5, range: NSRange(location: 0, length: attributedText.length))
           self.attributedText = attributedText
           
           // Align left
           self.textAlignment = .left
           
           // Disable autoresizing mask for use with Auto Layout
           self.translatesAutoresizingMaskIntoConstraints = false
        
        
    }

}
