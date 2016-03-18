////
////  IBIncludedThing.swift
////
////  Copyright 2016 Emily Ivie
//
////  Licensed under The MIT License
////  For full copyright and license information, please see http://opensource.org/licenses/MIT
////  Redistributions of files must retain the above copyright notice.


import UIKit

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
    
    /// The controller loaded during including the above storyboard or nib
    public weak var includedController: UIViewController?
    
    /// Typical initialization of IBIncludedThing when it is created during normal scene loading at run time.
    public override func awakeFromNib() {
        super.awakeFromNib()
        attachThing(toController: self, toView: nil)
    }
    
    public override func loadView() {
        super.loadView()
        attachThing(toController: nil, toView: self.view)
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        includedController?.prepareForSegue(segue, sender: sender)
        // The following code will run prepareForSegue in all child view controllers. 
        // This can cause unexpected multiple calls to prepareForSegue, so I prefer to be more cautious about which view controllers invoke prepareForSegue.
        // See IBIncludedThingDemo FourthController and SixthController for examples and options with embedded view controllers.
//        includedController?.findChildViewControllerType(UIViewController.self) { controller in
//            controller.prepareForSegue(segue, sender: sender)
//        }
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
        attachThing(toController: nil, toView: self)
    }
    
    // protocol conformance only (does not use):
    public weak var includedController: UIViewController?
}


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
    
    /// The controller loaded during including the above storyboard or nib
    public weak var includedController: UIViewController?
    
    /// An optional parent controller to use when this is being instantiated in code (and so might not have a hierarchy).
    /// This would be private, but the protocol needs it.
    public weak var parentController: UIViewController?
    
//    /// Convenience initializer for programmatic inclusion
//    public init?(incStoryboard: String? = nil, sceneId: String? = nil, incNib: String? = nil, nibController: String? = nil, intoView parentView: UIView? = nil, intoController parentController: UIViewController? = nil) {
//        self.incStoryboard = incStoryboard
//        self.sceneId = sceneId
//        self.incNib = incNib
//        self.nibController = nibController
//        self.parentController = parentController
//        super.init(frame: CGRectZero)
//        guard incStoryboard != nil || incNib != nil else {
//            return nil
//        }
//        // then also pin this IBIncludedSubThing to a parent view if so requested:
//        if let view = parentView ?? parentController?.view {
//            attachThingControllerView(self, toView: view)
//        }
//    }
//
//    public required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    /// Initializes the IBIncludedSubThing for preview inside Xcode.
    /// Does not bother attaching view controller to hierarchy.
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        attachThing(toController: nil, toView: self)
    }

    /// Typical initialization of IBIncludedSubThing when it is created during normal scene loading at run time.
    public override func awakeFromNib() {
        super.awakeFromNib()
        if parentController == nil {
            parentController = findParentViewController(activeViewController(topViewController()))
        }
        attachThing(toController: parentController, toView: self)
    }
    
    // And then we need all these to get parent controller:
    
    /// Grabs access to view controller hierarchy if possible.
    private func topViewController() -> UIViewController? {
        if let controller = window?.rootViewController {
            return controller
        } else if let controller = UIApplication.sharedApplication().keyWindow?.rootViewController {
            return controller
        }
        return nil
    }
    
    /// Locates the top-most currently visible controller.
    private func activeViewController(controller: UIViewController?) -> UIViewController? {
        guard let controller = controller else {
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
    
    /// Locates the view controller with this view inside of it (depth first, since in a hierarchy of view controllers the view would likely be in all the parentViewControllers of its view controller).
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

    /// Identifies if the IBIncludedSubThing view is equal to or under the view given.
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


/// This holds all the shared functionality of the IBIncludedThing variants.
public protocol IBIncludedThingLoadable: class {
    // defining properties:
    var incStoryboard: String? { get set }
    var sceneId: String? { get set }
    var incNib: String? { get set }
    var nibController: String? { get set }
    // reference:
    weak var includedController: UIViewController? { get set }
    // main:
    func attachThing(toController parentController: UIViewController?, toView parentView: UIView?)
    func detachThing()
    // supporting:
    func getThingController(inBundle bundle: NSBundle) -> UIViewController?
    func attachThingController(controller: UIViewController?, toParent parentController: UIViewController?)
    func attachThingControllerView(includedView: UIView?, toView view: UIView)
    // useful:
    func reloadWithNewStoryboard(incStoryboard: String, sceneId: String?)
    func reloadWithNewNib(incNib: String, nibController: String?)
}

extension IBIncludedThingLoadable {
    
    /// Main function to attach the included content.
    public func attachThing(toController parentController: UIViewController?, toView parentView: UIView?) {
        guard let includedController = includedController ?? getThingController(inBundle: NSBundle(forClass: self.dynamicType)) else {
            return
        }
        if let parentController = parentController {
            attachThingController(includedController, toParent: parentController)
        }
        if let parentView = parentView {
            attachThingControllerView(includedController.view, toView: parentView)
        }
    }
    
    /// Main function to remove the included content.
    public func detachThing() {
        includedController?.view.removeFromSuperview()
        includedController?.removeFromParentViewController()
        self.incStoryboard = nil
        self.sceneId = nil
        self.incNib = nil
        self.nibController = nil
    }
    
    /// Internal: loads the controller from the storyboard or nib
    public func getThingController(inBundle bundle: NSBundle) -> UIViewController? {
        var foundController: UIViewController?
        if let storyboardName = self.incStoryboard {
            // load storyboard
            let storyboardObj = UIStoryboard(name: storyboardName, bundle: bundle)
            let sceneId = self.sceneId ?? ""
            foundController = sceneId.isEmpty ? storyboardObj.instantiateInitialViewController() : storyboardObj.instantiateViewControllerWithIdentifier(sceneId)
        } else if let nibName = self.incNib {
            // load nib
            if let controllerName = nibController,
                appName = bundle.objectForInfoDictionaryKey("CFBundleName") as? String {
                // load specified controller
                let classStringName = "\(appName).\(controllerName)"
                if let ControllerType = NSClassFromString(classStringName) as? UIViewController.Type {
                    foundController = ControllerType.init(nibName: nibName, bundle: bundle) as UIViewController
                }
            } else {
                // load generic controller
                foundController = UIViewController(nibName: nibName, bundle: bundle)
            }
        }
        return foundController
    }
    
    /// Internal: inserts the included controller into the view hierarchy (this helps trigger correct view hierarchy lifecycle functions)
    public func attachThingController(controller: UIViewController?, toParent parentController: UIViewController?) {
        // save for later (do not explicitly reference view or you will trigger viewDidLoad)
        guard let controller = controller, parentController = parentController else {
            return
        }
        // save for later use
        includedController = controller
        // attach to hierarchy
        controller.willMoveToParentViewController(parentController)
        parentController.addChildViewController(controller)
        controller.didMoveToParentViewController(parentController)
    }
    
    /// Internal: inserts the included view inside the IBIncludedThing view. Makes this nesting invisible by removing any background on IBIncludedThing and sets constraints so included content fills IBIncludedThing.
    public func attachThingControllerView(includedView: UIView?, toView view: UIView) {
        guard let includedView = includedView else {
            return
        }
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
    
    /// Programmatic reloading of a storyboard inside the same IBIncludedSubThing view.
    /// parentController is only necessary when the storyboard has had no previous storyboard, and so is missing an included controller (and its parent).
    public func reloadWithNewStoryboard(incStoryboard: String, sceneId: String?) {
        let parentController = (self as? IBIncludedThing) ?? (self as? IBIncludedSubThing)?.parentController
        guard incStoryboard != self.incStoryboard || sceneId != self.sceneId,
            let parentView = (self as? IBIncludedSubThing) ?? parentController?.view else {
            return
        }
        // cleanup old stuff
        detachThing()
        self.includedController = nil
        // reset to new values
        self.incStoryboard = incStoryboard
        self.sceneId = sceneId
        self.incNib = nil
        self.nibController = nil
        // reload
        attachThing(toController: parentController, toView: parentView)
    }
    
    /// Programmatic reloading of a nib inside the same IBIncludedSubThing view.
    /// parentController is only necessary when the storyboard has had no previous storyboard, and so is missing an included controller (and its parent).
    public func reloadWithNewNib(incNib: String, nibController: String?) {
        let parentController = (self as? IBIncludedThing) ?? (self as? IBIncludedSubThing)?.parentController
        guard incNib != self.incNib || nibController != self.nibController,
            let parentView = (self as? IBIncludedSubThing) ?? parentController?.view else {
            return
        }
        // cleanup old stuff
        detachThing()
        self.includedController = nil
        // reset to new values
        self.incStoryboard = nil
        self.sceneId = nil
        self.incNib = incNib
        self.nibController = nibController
        // reload
        attachThing(toController: parentController, toView: parentView)
    }
    
}

extension UIViewController {
    
    /// A convenient utility for quickly running some code on a view controller of a specific type in the current view controller hierarchy.
    public func findChildViewControllerType<T: UIViewController>(controllerType: T.Type, apply: (T -> Void)) {
        for childController in childViewControllers {
            if let foundController = childController as? T {
                apply(foundController)
            } else {
                childController.findChildViewControllerType(controllerType, apply: apply)
            }
        }
        if let foundController = self as? T {
            apply(foundController)
        }
    }
}

extension UIWindow {

    static var isInterfaceBuilder: Bool {
        #if TARGET_INTERFACE_BUILDER
            return true
        #else
            return false
        #endif
    }

}
