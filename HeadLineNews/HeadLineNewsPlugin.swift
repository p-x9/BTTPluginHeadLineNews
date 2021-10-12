//
//  HeadLineNewsPlugin.swift
//  HeadLineNews
//
//  Created by p-x9 on 2021/10/13.
//  
//

import Foundation

@objc
class HeadLineNewsPlugin: NSObject, BTTPluginInterface {

    weak var delegate: BTTTouchBarPluginDelegate?

    lazy var customVC: ViewController = {
        let viewController = ViewController()
        return viewController
    }()

    var configurationValues: [AnyHashable: Any] = [:]

    class func configurationFormItems() -> BTTPluginFormItem? {
        let group = BTTPluginFormItem()
        group.formFieldType = BTTFormTypeFormGroup

        let preferences = Preferences.shared

        let item = BTTPluginFormItem()
        item.formFieldType = BTTFormTypeTextArea
        item.formLabel1 = "RSS URLs \n (separater is ',')"
        item.formFieldID = "rssURLs"
        item.dataType = BTTFormDataString
        item.defaultValue = preferences.rssUrls.joined(separator: ",")

        let item1 = BTTPluginFormItem()
        item1.formFieldType = BTTFormTypeSlider
        item1.formLabel1 = "Text Speed"
        item1.formFieldID = "textSpeed"
        item1.minValue = 0
        item1.maxValue = 2
        item1.defaultValue = preferences.textSpeed

        let item2 = BTTPluginFormItem()
        item2.formFieldType = BTTFormTypeColorPicker
        item2.formLabel1 = "Text Color"
        item2.formFieldID = "textColor"
        item2.defaultValue = NSColor(rgba: preferences.textColor)

        let item3 = BTTPluginFormItem()
        item3.formFieldType = BTTFormTypeTextField
        item3.formLabel1 = "Font Name"
        item3.formFieldID = "fontName"
        item3.dataType = BTTFormDataString
        item3.defaultValue = preferences.fontName

        let item4 = BTTPluginFormItem()
        item4.formFieldType = BTTFormTypeSlider
        item4.formLabel1 = "Font Size"
        item4.formFieldID = "fontSize"
        item4.minValue = 10
        item4.maxValue = 40
        item4.defaultValue = preferences.fontSize

        let item5 = BTTPluginFormItem()
        item5.formFieldType = BTTFormTypeColorPicker
        item5.formLabel1 = "Background Color"
        item5.formFieldID = "backgroundColor"
        item5.defaultValue = NSColor(rgba: preferences.backgroundColor)

        group.formOptions = [item, item1, item2, item3, item4, item5]

        return group
    }

    override init() {
        super.init()
    }

    func touchBarViewController() -> NSViewController? {
        self.customVC
    }

    @objc
    func didReceiveNewConfigurationValues(_ configurationValues: [AnyHashable: Any]) {
        self.configurationValues = configurationValues

        Preferences.shared.update(with: configurationValues)
    }

    @objc
    func executeAssignedBTTActions() {
        self.delegate?.executeAssignedBTTActions(self)
    }

}
