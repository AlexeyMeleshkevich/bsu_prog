//
//  WrongLoginView.swift
//  tableSettigins
//
//  Created by Alexey Meleshkevich on 06.02.2020.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation
import UIKit

class WrongLoginView: UIView {
    
    let cancelButton = UIButton()
        let button = UIButton(frame: .zero)
        let image = UIImage(systemName: "xmark.square")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image!, for: .normal)
        button.sizeToFit()
    @IBOutlet weak var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func loadView()  -> UIView {
        let bundle = Bundle.init(for: type(of:self))
        let nib = UINib(nibName: "WrongLoginView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        return view
    }
    
    func setStyle() {
        
    }
}
