# IBIncludedThing

**An iOS Swift class to embed storyboards and nibs and preview them in Interface Builder**

Storyboards can easily get too large and they are slow and difficut to collaborate on without conflicts. IBIncludedStoryboard allows developers to break up their application into sensible chunks and link the storyboards visually. It also allows for embedding of nibs and storyboards inside other content, and provides a mechanism for easily locating child controllers to configure data.

## Including in Your App

To use, simply add the IBIncludedThing.swift file to your project and start dividing your storyboards into flows and pages. A flow contains many IBIncludedThing scenes, all linked out to individual storyboard pages and their controllers. See the demo for examples.

To configure a storyboard flow scene (assuming you have already made a page storyboard to include):

1. Select the scene's root controller (the left-most of the top buttons, currently a yellow circle in Xcode).
2. Change the root controller's class name to **IBIncludedThing**.
3. Identify the page storyboard or nib in the Interface Builder Attributes Inspector, under IBIncludedThing. There are four fields shown. Either the **Inc Storyboard** or **Inc Nib** field must be filled in. The (optional) **Scene Id** field allows for linking to scenes that are not checked as Initial View Controller. The (optional) **Nib Controller** field allows for linking a nib to an associated owner view controller.
4. Repeat these steps for the placeholder's root view, changing the class name to **IBIncludedThingPreview**. *(This duplication is unfortunately necessary due to the fickleness of @IBDesignable and view controllers.)*
4. The chosen scene from your page storyboard or nib should appear in the flow storyboard. *(It may be slid under the top navigation bar if you have one - don't worry: it will adjust its insets properly at load time.)*

That's it! 

You can also embed subviews using **IBIncludedSubThing** and the same steps, which makes it easy to bring page components together.

## Creating Segues

Because IBIncludedThing's included content is a *child* view controller of the main storyboard scene, invoking segues can get tricky. I have just got into the habit of invoking all segues from IBAction functions.

1. Create the segue from the flow storyboard scene's parent controller (the yellow circle) to the new scene and give it a unique identifier.
2. Wire up an element in the child controller to code that directly invokes the segue by its identifier:

```swift
@IBAction func clickedButton(sender: UIButton) {
    parentViewController?.performSegueWithIdentifier("SEGUE NAME", sender: sender)
}
```

*Note: if you are embedded multiple levels down (say, by using IBIncludedSubThing, or by trying to call a segue in Flow1 from Flow2), you may need to chain multiple parentViewControllers to get to the one you want.*

## Using prepareForSegue

Often, prepareForSegue is used to share data between view controllers. Because IBIncludedThing's included content is a child view of the root, it is not immediately accessible in prepareForSegue. But it just takes a bit more code to locate and share data with the included content.

```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        findChildViewControllerType(SecondController.self, inController: segue.destinationViewController) { controller in
            controller.sentValue = self.textField?.text
        }
    }
```

*Note: prepareForSegue does not work for IBIncludedSubThing, because only the root controller of a scene is available at the time prepareForSegue is called.*