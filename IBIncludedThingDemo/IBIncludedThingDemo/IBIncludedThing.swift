////
////  IBIncludedThing.swift
////
////  Copyright 2016 Emily Ivie
//
////  Licensed under The MIT License
////  For full copyright and license information, please see http://opensource.org/licenses/MIT
////  Redistributions of files must retain the above copyright notice.


import UIKit

/// Can be used identically to IBIncludedThing, but for subviews inside scenes rather than an entire scene. The major difference is that IBIncludedSubThing views, unfortunately, cannot be configured using prepareForSegue, because they are loaded too late in the view controller lifecycle.
@IBDesignable
public class IBIncludedSubThing: UIView, IBIncludedThingLoadable {

    @IBInspectable
    public var incStoryboard: String?
    @IBInspectable
    public var sceneId: String?
    @IBInspectable
    public var incNib: String?
    @IBInspectable
    public var nibController: String?
    
    weak var includedController: UIViewController?
    var didLoad = false
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        
        if let includedController = getThingController(inBundle: bundle) {
            attachControllerView(controller: includedController, toView: self)
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        guard !didLoad else { return }
        
        let bundle = NSBundle(forClass: self.dynamicType)
        
        if let includedController = getThingController(inBundle: bundle) {
        
            if let parentController = findParentViewController(activeViewController(topViewController())) {
                includedController.willMoveToParentViewController(parentController)
                parentController.addChildViewController(includedController)
                includedController.didMoveToParentViewController(parentController)
            }
            
            attachControllerView(controller: includedController, toView: self)
        }
        
        didLoad = true
    }
    
    // And then we need all these because nibs are hard:
    
    private func topViewController() -> UIViewController? {
        if let controller = window?.rootViewController {
            return controller
        } else if let controller = UIApplication.sharedApplication().keyWindow?.rootViewController {
            return controller
        }
        return nil
    }
    
    private func activeViewController(controller: UIViewController!) -> UIViewController? {
        if controller == nil {
            return nil
        }
        if let tabController = controller as? UITabBarController, let nextController = tabController.selectedViewController {
            return activeViewController(nextController)
        } else if let navController = controller as? UINavigationController, let nextController = navController.visibleViewController {
            return activeViewController(nextController)
        } else if let nextController = controller.presentedViewController {
            return activeViewController(nextController)
        }
        return controller
    }
    
    private func findParentViewController(topController: UIViewController!) -> UIViewController? {
        if topController == nil {
            return nil
        }
        for viewController in topController.childViewControllers {
            // first try, deep dive into child controllers
            if let parentViewController = findParentViewController(viewController) {
                return parentViewController
            }
        }
        // second try, top view controller (most generic, most things will be in this view)
        if let topView = topController?.view where findSelfInViews(topView) {
            return topController
        }
        return nil
    }

    private func findSelfInViews(topView: UIView) -> Bool {
        if topView == self || topView == self.superview {
            return true
        } else {
            for view in topView.subviews {
                if findSelfInViews(view ) {
                    return true
                }
            }
        }
        return false
    }
}

/// Allows for removing individual scene design from the flow storyboards and into individual per-controller storyboards, which minimizes git merge conflicts.
public class IBIncludedThing: UIViewController, IBIncludedThingLoadable {

    @IBInspectable
    public var incStoryboard: String?
    @IBInspectable
    public var sceneId: String?
    @IBInspectable
    public var incNib: String?
    @IBInspectable
    public var nibController: String?
    
    weak var includedController: UIViewController?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        
        if let includedController = getThingController(inBundle: bundle) {
            includedController.willMoveToParentViewController(self)
            addChildViewController(includedController)
            includedController.didMoveToParentViewController(self)
            
            // save for later (do not explicitly reference view or you will trigger viewDidLoad)
            self.includedController = includedController
        }
    }
    
    public override func loadView() {
        super.loadView()
        
        if let includedController = includedController {
            attachControllerView(controller: includedController, toView: view)
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        includedController?.prepareForSegue(segue, sender: sender)
        runOnAllChildControllers { controller in
            controller.prepareForSegue(segue, sender: sender)
        }
    }
    
    private func runOnAllChildControllers(controller: UIViewController? = nil, apply: (UIViewController -> Void)) {
        let controller = controller ?? self
        for childController in controller.childViewControllers {
            apply(childController)
            runOnAllChildControllers(childController, apply: apply)
        }
    }
}



/// Because UIViewController does not preview in Interface Builder, this is an Interface-Builder-only companion to IBIncludedThing. Typically you would set the scene owner to IBIncludedThing and then set the top-level view to IBIncludedThingPreview, with identical IBInspectable values.
@IBDesignable
public class IBIncludedThingPreview: UIView, IBIncludedThingLoadable {

    @IBInspectable
    public var incStoryboard: String?
    @IBInspectable
    public var sceneId: String?
    @IBInspectable
    public var incNib: String?
    @IBInspectable
    public var nibController: String?

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        
        if let includedController = getThingController(inBundle: bundle) {
            attachControllerView(controller: includedController, toView: self)
        }
    }
}


/// This holds all the shared functionality of the IBIncludedThing variants.
public protocol IBIncludedThingLoadable {
    var incStoryboard: String? { get }
    var sceneId: String? { get }
    var incNib: String? { get }
    var nibController: String? { get }
    func getThingController(inBundle bundle: NSBundle) -> UIViewController?
    func attachControllerView(controller controller: UIViewController, toView view: UIView)
}
extension IBIncludedThingLoadable {
    
    public func getThingController(inBundle bundle: NSBundle) -> UIViewController? {
        if let storyboardName = self.incStoryboard {
            let storyboardObj = UIStoryboard(name: storyboardName, bundle: bundle)
            let sceneId = self.sceneId ?? ""
            if let controller = sceneId.isEmpty ? storyboardObj.instantiateInitialViewController() : storyboardObj.instantiateViewControllerWithIdentifier(sceneId) {
                
                return controller
            }
        } else if let nibName = self.incNib {
            if let controllerName = nibController,
                appName = bundle.objectForInfoDictionaryKey("CFBundleName") as? String {
                let classStringName = "\(appName).\(controllerName)"
                if let ControllerType = NSClassFromString(classStringName) as? UIViewController.Type {
                    let controller = ControllerType.init(nibName: nibName, bundle: bundle) as UIViewController
                    
                    return controller
                }
            } else {
                let controller = UIViewController(nibName: nibName, bundle: bundle)
                
                return controller
            }
        }
        return nil
    }
    
    public func attachControllerView(controller controller: UIViewController, toView view: UIView) {
        let includedView = controller.view
        view.addSubview(includedView)
        
        //clear out top-level view visibility, so only subview shows
        view.opaque = false
        view.backgroundColor = UIColor.clearColor()
        
        //tell child to fit itself to the edges of wrapper (self)
        includedView.translatesAutoresizingMaskIntoConstraints = false
        includedView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        includedView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        includedView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        includedView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
    }
}

extension UIViewController {
    
    /// A convenient utility for quickly running some code on a view controller of a specific type in the current view controller hierarchy.
    public func findChildViewControllerType<T: UIViewController>(controllerType: T.Type, inController: UIViewController? = nil, apply: (T -> Void)) {
        let controller = inController ?? self
        for childController in controller.childViewControllers {
            if let foundController = childController as? T {
                apply(foundController)
            } else {
                childController.findChildViewControllerType(controllerType, apply: apply)
            }
        }
    }
    
}
