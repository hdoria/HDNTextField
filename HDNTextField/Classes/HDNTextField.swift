//
//  HDNTextField.swift
//  HDNTextField
//
//  Created by Hugo Doria on 07/07/16.
//  Copyright © 2016 Hugo Doria. All rights reserved.
//

import UIKit

@IBDesignable public class HDNTextField: UITextField {

    // MARK: Placeholder Properties

    /*
     UILabel that holds all the placeholder information
    */
    public let placeholderLabel = UILabel()

    /**
     The insets for the placeholder.

     This property applies a padding to the placeholder. Ex: CGPoint(x: 10, y: 0).
     */
    @IBInspectable dynamic public var placeholderInsets: CGPoint = CGPoint(x: 10, y: 0) {
        didSet {
            updatePlaceholder()
        }
    }

    /**
     The color for the placeholder when the Textfield is inactive.

     This property applies a color for the placeholder when the Textfield is inactive.
     */
    @IBInspectable dynamic public var placeholderInactiveColor: UIColor = .lightGrayColor() {
        didSet {
            updatePlaceholder()
        }
    }

    /**
     The color for the placeholder when the Textfield is active.

     This property applies a color for the placeholder when the Textfield is active.
     */
    @IBInspectable dynamic public var placeholderActiveColor: UIColor = .blueColor() {
        didSet {
            updatePlaceholder()
        }
    }

    /**
     The background color for the placeholder.

     This property applies a background color to the placeholder.
     */
    @IBInspectable dynamic public var placeholderBackgroundColor: UIColor = .clearColor() {
        didSet {
            updatePlaceholder()
        }
    }

    /*
     The placeholder text.
     */
    override public var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    // MARK: TextField Properties

    /**
     The background color for the textfield when it's active.

     This property applies a background color to the textfield when it's active.
     */
    @IBInspectable dynamic public var textFieldActiveBackgroundColor: UIColor = .clearColor() {
        didSet {
            updatePlaceholder()
        }
    }

    /**
     The background color for the textfield when it's inactive.

     This property applies a background color to the textfield when it's inactive.
     */
    @IBInspectable dynamic public var textFieldInactiveBackgroundColor: UIColor = .clearColor() {
        didSet {
            updatePlaceholder()
        }
    }

    // MARK: Text Properties

    /**
     The color for the text when the textfield is inactive.

     This property applies a color to the text when the textfield is inactive.
     */
    @IBInspectable dynamic public var textInactiveColor: UIColor = .blackColor() {
        didSet {
            updateTextColor()
        }
    }

    /**
     The color for the text when the textfield is active.

     This property applies a color to the text when the textfield is active.
     */
    @IBInspectable dynamic public var textActiveColor: UIColor = .blackColor() {
        didSet {
            updateTextColor()
        }
    }

    /**
     The corner radius for the textfield as a whole.

     This property applies a rounded corner to the textfield.
     */
    @IBInspectable dynamic public var textFieldCornerRadius: CGFloat = 3.0

    /**
     This property defines the size of the editable area.

     This property defines the size of the editable area. Ex: CGPoint(x: 10, y: 0).
     */
    @IBInspectable dynamic public var textFieldInsets: CGPoint = CGPoint(x: 10, y: 0)

    // MARK: Border Properties

    /**
     The color of the border when the textfield is not active.

     This property applies a border to the textfield when it's inactive.
     The default value for this property is a clear color.
     */
    @IBInspectable dynamic public var borderInactiveColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }

    /**
     The color of the border when it is active.

     This property applies a border to the textfield when it's active (editing mode).
     */
    @IBInspectable dynamic public var borderActiveColor: UIColor = UIColor.blueColor() {
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
    @IBInspectable dynamic public var notEmptyBorderInactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }

    /**
     The color for the text when the textfield is inactive and have content inside.

     This property applies a color to the text when the textfield is inactive and have content inside.
     */
    @IBInspectable dynamic public var notEmptyTextInactiveColor: UIColor? {
        didSet {
            updateTextColor()
        }
    }

    /**
     The color for the text when the textfield is inactive and have content inside.

     This property applies a color to the text when the textfield is inactive and have content inside.
     */
    @IBInspectable dynamic public var notEmptyPlaceholderInactiveColor: UIColor? {
        didSet {
            updatePlaceholder()
        }
    }

    // MARK: Private vars
    private let borderLayer = CAShapeLayer()

    // MARK: Overrides
    override public var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }

    override public func drawRect(rect: CGRect) {
        textAlignment = .Right

        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)
    }

    override public func willMoveToSuperview(newSuperview: UIView?) {
        let nc = NSNotificationCenter.defaultCenter()
        if newSuperview != nil {
            nc.addObserver(self,
                           selector: #selector(textFieldDidBeginEditing),
                           name: UITextFieldTextDidBeginEditingNotification,
                           object: self)
            nc.addObserver(self,
                           selector: #selector(textFieldDidEndEditing),
                           name: UITextFieldTextDidEndEditingNotification,
                           object: self)
        } else {
            nc.removeObserver(self)
        }
    }

    override public func drawPlaceholderInRect(rect: CGRect) {
        // Override so the default placeholder does not appear
    }

    // MARK: Interface Build
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        drawViewsForRect(frame)
    }

    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return getRectForText(bounds)
    }

    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return getRectForText(bounds)
    }

    // MARK: Textfield Delegate

    /**
     The textfield has started an editing session.
     */
    public func textFieldDidBeginEditing() {
        updateBorder()
        updatePlaceholder()
        textColor = textActiveColor
    }

    /**
     The textfield has ended an editing session.
     */
    public func textFieldDidEndEditing() {
        updateBorder()
        updatePlaceholder()
        updateTextColor()
    }

    // MARK: Helper Methods
    private func updateBorder() {
        var inactiveBorderColor = borderInactiveColor

        if let notEmptyBorderColor = notEmptyBorderInactiveColor where !text!.isEmpty {
            inactiveBorderColor = notEmptyBorderColor
        }

        let rect = self.bounds
        let corderRadii = CGSize(width: textFieldCornerRadius, height: textFieldCornerRadius)
        let corners = UIRectCorner.AllCorners
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: corderRadii)

        borderLayer.path = path.CGPath
        borderLayer.lineWidth = 2
        borderLayer.fillColor = (self.editing ? textFieldActiveBackgroundColor.CGColor : textFieldInactiveBackgroundColor.CGColor)
        borderLayer.strokeColor = (self.editing ? borderActiveColor.CGColor : inactiveBorderColor.CGColor)
        borderLayer.lineCap = kCALineCapSquare

        layer.cornerRadius = textFieldCornerRadius
    }

    private func updatePlaceholder() {
        var inactivePlaceholderColor = placeholderInactiveColor

        if let notEmptyPlaceholderColor = notEmptyPlaceholderInactiveColor where !text!.isEmpty {
            inactivePlaceholderColor = notEmptyPlaceholderColor
        }

        placeholderLabel.text = placeholder
        placeholderLabel.textColor = (self.editing ? placeholderActiveColor : inactivePlaceholderColor)
        placeholderLabel.sizeToFit()
        placeholderLabel.backgroundColor = placeholderBackgroundColor
        placeholderLabel.textAlignment = .Right
        layoutPlaceholderInTextRect()
    }

    private func updateTextColor() {
        var inactiveTextColor = textInactiveColor

        if let notEmptyTextColor = notEmptyTextInactiveColor where !text!.isEmpty {
            inactiveTextColor = notEmptyTextColor
        }

        textColor = (self.editing ? textActiveColor : inactiveTextColor)
    }

    private func layoutPlaceholderInTextRect() {

        let center = CGPoint(x: CGRectGetMidX(self.bounds),
                             y: CGRectGetMidY(self.bounds) + placeholderInsets.y)
        placeholderLabel.center = center
        placeholderLabel.frame = CGRect(x: placeholderInsets.x,
                                        y: placeholderLabel.frame.origin.y,
                                        width: placeholderLabel.bounds.width,
                                        height: placeholderLabel.bounds.height)

    }

    private func getRectForText(bounds: CGRect) -> CGRect {
        let placeHolderEndPosition = placeholderLabel.frame.origin.x + placeholderLabel.frame.size.width
        let editingWidth = bounds.size.width - (placeHolderEndPosition + textFieldInsets.x + 10)
        let origin = CGPoint(x: placeHolderEndPosition + textFieldInsets.x, y: 0)
        let frame = CGRect(origin: origin, size: CGSize(width: editingWidth, height: bounds.size.height))
        return frame
    }

    // MARK: - Interface Builder
    public func drawViewsForRect(rect: CGRect) {
        updateBorder()
        updatePlaceholder()

        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)
    }
}
