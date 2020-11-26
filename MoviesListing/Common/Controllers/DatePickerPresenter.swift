//
//  DatePickerViewer.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 04/05/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import UIKit
import RxSwift

class DatePickerPresenter: UIControl {
    let dateDidSelectSubject = PublishSubject<Date>()
    
    private var selectedDate: Date = Date()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker  = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var accessoryView: UIView = {
        //create buttons for toolbars
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone(sender:)))
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel(sender:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //create toolbar and configure with buttons
        let view = UIToolbar()
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.setItems([doneBarButton,flexibleSpace,cancelBarButton], animated: false)
        
        return view
    }()
    
    
    func present(into source: UIView) {
        source.addSubview(self)
        becomeFirstResponder()
    }
    
    func hide() {
        removeFromSuperview()
        resignFirstResponder()
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputView: UIView? {
        return datePicker
    }
    
    override var inputAccessoryView: UIView? {
        return accessoryView
    }
    
    //MARK:- Actions
    
    @objc func didTapDone(sender: UIButton) {
        hide()
        dateDidSelectSubject.onNext(selectedDate)
    }
    
    @objc func didTapCancel(sender: UIButton) {
        hide()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
}

