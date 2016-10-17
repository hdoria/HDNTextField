//
//  HDNTextField.swift
//  HDNTextField
//
//  Created by Hugo Doria on 07/07/16.
//  Copyright © 2016 Hugo Doria. All rights reserved.
//

import UIKit

@IBDesignable open class HDNTextField: UITextField {

    // MARK: Placeholder Properties

    /*
     UILabel that holds all the placeholder information
    */
    open let placeholderLabel = UILabel()

    /**
     The insets for the placeholder.

     This property applies a padding to the placeholder. Ex: CGPoint(x: 10, y: 0).
     */
    @IBInspectable dynamic open var placeholderInsets: CGPoint = CGPoint(x: 10, y: 0) {
        didSet {
            updatePlaceholder()
        }
    }

    /**
     The color for the placeholder when the Textfield is inactive.

     This property applies a color for the placeholder when the Textfield is inactive.
     */
    @IBInspectable dynamic open var placeholderInactiveColor: UIColor = .lightGray {
        didSet {
            updatePlaceholder()
        }
    }

    /**
     The color for the placeholder when the Textfield is active.

     This property applies a color for the placeholder when the Textfield is active.
     */
    @IBInspectable dynamic open var placeholderActiveColor: UIColor = .blue {
        didSet {
            updatePlaceholder()
        }
    }

    /**
     The background color for the placeholder.

     This property applies a background color to the placeholder.
     */
    @IBInspectable dynamic open var placeholderBackgroundColor: UIColor = .clear {
        didSet {
            updatePlaceholder()
        }
    }

    /*
     The placeholder text.
     */
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    // MARK: TextField Properties

    /**
     The background color for the textfield when it's active.

     This property applies a background color to the textfield when it's active.
     */
    @IBInspectable dynamic open var textFieldActiveBackgroundColor: UIColor = .clear {
        didSet {
            updatePlaceholder()
        }
    }

    /**
     The background color for the textfield when it's inactive.

     This property applies a background color to the textfield when it's inactive.
     */
    @IBInspectable dynamic open var textFieldInactiveBackgroundColor: UIColor = .clear {
        didSet {
            updatePlaceholder()
        }
    }

    // MARK: Text Properties

    /**
     The color for the text when the textfield is inactive.

     This property applies a color to the text when the textfield is inactive.
     */
    @IBInspectable dynamic open var textInactiveColor: UIColor = .black {
        didSet {
            updateTextColor()
        }
    }

    /**
     The color for the text when the textfield is active.

     This property applies a color to the text when the textfield is active.
     */
    @IBInspectable dynamic open var textActiveColor: UIColor = .black {
        didSet {
            updateTextColor()
        }
    }

    /**
     The corner radius for the textfield as a whole.

     This property applies a rounded corner to the textfield.
     */
    @IBInspectable dynamic open var textFieldCornerRadius: CGFloat = 3.0

    /**
     This property defines the size of the editable area.

     This property defines the size of the editable area. Ex: CGPoint(x: 10, y: 0).
     */
    @IBInspectable dynamic open var textFieldInsets: CGPoint = CGPoint(x: 10, y: 0)

    // MARK: Border Properties

    /**
     The color of the border when the textfield is not active.

     This property applies a border to the textfield when it's inactive.
     The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderInactiveColor: UIColor = UIColor.lightGray {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }

    /**
     The color of the border when it is active.

     This property applies a border to the textfield when it's active (editing mode).
     */
    @IBInspectable dynamic open var borderActiveColor: UIColor = UIColor.blue {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }

    // MARK: Colors when the textfield is inactive but have content
    /**
     The color of the border when the textfield is not active but have content.

     This property applies a border to the textfield when it's inactive and have content inside.
     The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var notEmptyBorderInactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }

    /**
     The color for the text when the textfield is inactive and have content inside.

     This property applies a color to the text when the textfield is inactive and have content inside.
     */
    @IBInspectable dynamic open var notEmptyTextInactiveColor: UIColor? {
        didSet {
            updateTextColor()
        }
    }

    /**
     The color for the text when the textfield is inactive and have content inside.

     This property applies a color to the text when the textfield is inactive and have content inside.
     */
    @IBInspectable dynamic open var notEmptyPlaceholderInactiveColor: UIColor? {
        didSet {
            updatePlaceholder()
        }
    }

    // MARK: Private vars
    fileprivate let borderLayer = CAShapeLayer()

    // MARK: Overrides
    override open var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }

    override open func draw(_ rect: CGRect) {
        textAlignment = .right

        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        let nc = NotificationCenter.default
        if newSuperview != nil {
            nc.addObserver(self,
                           selector: #selector(textFieldDidBeginEditing),
                           name: NSNotification.Name.UITextFieldTextDidBeginEditing,
                           object: self)
            nc.addObserver(self,
                           selector: #selector(textFieldDidEndEditing),
                           name: NSNotification.Name.UITextFieldTextDidEndEditing,
                           object: self)
        } else {
            nc.removeObserver(self)
        }
    }

    override open func drawPlaceholder(in rect: CGRect) {
        // Override so the default placeholder does not appear
    }

    // MARK: Interface Build
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        drawViewsForRect(frame)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return getRectForText(bounds)
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return getRectForText(bounds)
    }

    // MARK: Textfield Delegate

    /**
     The textfield has started an editing session.
     */
    open func textFieldDidBeginEditing() {
        updateBorder()
        updatePlaceholder()
        textColor = textActiveColor
    }

    /**
     The textfield has ended an editing session.
     */
    open func textFieldDidEndEditing() {
        updateBorder()
        updatePlaceholder()
        updateTextColor()
    }

    // MARK: Helper Methods
    fileprivate func updateBorder() {
        var inactiveBorderColor = borderInactiveColor

        if let notEmptyBorderColor = notEmptyBorderInactiveColor , !text!.isEmpty {
            inactiveBorderColor = notEmptyBorderColor
        }

        let rect = self.bounds
        let corderRadii = CGSize(width: textFieldCornerRadius, height: textFieldCornerRadius)
        let corners = UIRectCorner.allCorners
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: corderRadii)

        borderLayer.path = path.cgPath
        borderLayer.lineWidth = 2
        borderLayer.fillColor = (self.isEditing ? textFieldActiveBackgroundColor.cgColor : textFieldInactiveBackgroundColor.cgColor)
        borderLayer.strokeColor = (self.isEditing ? borderActiveColor.cgColor : inactiveBorderColor.cgColor)
        borderLayer.lineCap = kCALineCapSquare

        layer.cornerRadius = textFieldCornerRadius
    }

    fileprivate func updatePlaceholder() {
        var inactivePlaceholderColor = placeholderInactiveColor

        if let notEmptyPlaceholderColor = notEmptyPlaceholderInactiveColor , !text!.isEmpty {
            inactivePlaceholderColor = notEmptyPlaceholderColor
        }

        placeholderLabel.text = placeholder
        placeholderLabel.textColor = (self.isEditing ? placeholderActiveColor : inactivePlaceholderColor)
        placeholderLabel.sizeToFit()
        placeholderLabel.backgroundColor = placeholderBackgroundColor
        placeholderLabel.textAlignment = .right
        layoutPlaceholderInTextRect()
    }

    fileprivate func updateTextColor() {
        var inactiveTextColor = textInactiveColor

        if let notEmptyTextColor = notEmptyTextInactiveColor , !text!.isEmpty {
            inactiveTextColor = notEmptyTextColor
        }

        textColor = (self.isEditing ? textActiveColor : inactiveTextColor)
    }

    fileprivate func layoutPlaceholderInTextRect() {

        let center = CGPoint(x: self.bounds.midX,
                             y: self.bounds.midY + placeholderInsets.y)
        placeholderLabel.center = center
        placeholderLabel.frame = CGRect(x: placeholderInsets.x,
                                        y: placeholderLabel.frame.origin.y,
                                        width: placeholderLabel.bounds.width,
                                        height: placeholderLabel.bounds.height)

    }

    fileprivate func getRectForText(_ bounds: CGRect) -> CGRect {
        let placeHolderEndPosition = placeholderLabel.frame.origin.x + placeholderLabel.frame.size.width
        let editingWidth = bounds.size.width - (placeHolderEndPosition + textFieldInsets.x + 10)
        let origin = CGPoint(x: placeHolderEndPosition + textFieldInsets.x, y: 0)
        let frame = CGRect(origin: origin, size: CGSize(width: editingWidth, height: bounds.size.height))
        return frame
    }

    // MARK: - Interface Builder
    open func drawViewsForRect(_ rect: CGRect) {
        updateBorder()
        updatePlaceholder()

        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)
    }
}
