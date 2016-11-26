+++
title = "Reactive Way to Handle Dismissing Modal View Controller"
description = "Alternative to common Cocoa patterns"
author = ""
tags = ["Tech"]
date = "2016-11-18T20:40:27+11:00"

+++
![](/blogFiles/f5bd8360.jpeg)

We use modal presentation quite often in iOS. You must be familiar with:

```Swift
self.present(vc, animated: true, completion: nil)
```

Now lets say we want something to happen with our current VC when the modal VC is dismissed, there are several ways to do that.

The Cocoa way would be to use *presenting view controller*, *delegate pattern* or *notification center*.

Lets go through each briefly.

## Presenting view controller
This option is the worst because the child/presented VC needs to know quite a lot of detail about the parent/presenting VC. That should almost never be the case. The child should know as little about the parent as possible. Therefore lets avoid this:

```Swift
class ModalVC: UIViewController {
  func someFunc() {
    dismiss(animated: true, completion: {
      if let parent = self.presentingViewController {
        parent.doSomething()
      }
    })
  }
}
```

The next pattern is a direct improvement over `presentingViewController`.

## Delegate pattern
Create a protocol with a void method and get the parent VC to conform to it.

```Swift
protocol ModalHandler {
  func modalDismissed()
}

class ParentVC: UIViewController, ModalHandler {
  func modalDismissed() {
    // do something
  }
}
```

Then set the ParentVC as delegate of ModalVC before presentation and call the method during dismissal.

```Swift
class ModalVC: UIViewController {
  func someFunc() {
    dismiss(animated: true, completion: {
      delegate.modalDismissed()
    })
  }
}
```

This way is better that using `presentingViewController` because the child doesn't know about the parent, but only the protocol/interface as a layer of abstraction. I recommend using this pattern in a non reactive projects.

## Notification pattern
With this, we need to get ParentVC to observe the modal dismissed notification.

```Swift
class ParentVC: UIViewController {
  override func viewDidLoad() {
    NotificationCenter.default.addObserver(self, selector: #selector(ParentVC.handleModalDismissed), name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil) 
  }

  func handleModalDismissed() {
    // Do something
  }
}

class ModalVC: UIViewController {
  func someFunc() {
    dismiss(animated: true, completion: {
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
    })
  }
}
```

I don't like notifications because both parent and modal VC needs to know the notification name to work.

## Reactive pattern
When you use ReactiveCocoa/ReactiveSwift, you could easily handle modal dismissal with several lines of codes in the presenting VC. This is my preferred way because the child doesn't even need to do any extra work. All the heavy lifting is done by `ReactiveCocoa`.

```Swift
class ParentVC: UIViewController {
  override func viewDidLoad() {
    let modalVC = ModalVC()

    modalVC.reactive
      .trigger(for: #selector(onboardNav.viewDidDisappear(_:)))
      .observe { _ in self.handleModalDismissed() }

    present(modalVC, animated: false, completion: nil)
  }

  func handleModalDismissed() { }
}
```

In here, the ParentVC will observe modalVC before presenting. When modalVC calls `viewDidDisappear(_:)`, ParentVC will call `self.handleModalDismissed()`.

As you can see, it is very clean and quite easy to understand even if you aren't as familiar with reactive concepts.
