+++
title = "Reactive Way to Handle Dismissing Modal View Controller"
description = "Alternative to delegate pattern"
author = ""
tags = ["Tech"]
date = "2016-11-18T20:40:27+11:00"

+++
![](/blogFiles/f5bd8360.jpeg)

We use modal presentation very often in iOS. You must be familiar with:

```Swift
self.present(vc, animated: true, completion: nil)
```

Now lets say we want something to happen with our current VC when the modal VC is dismissed, there are several ways to do that.

The Cocoa way would be to use *delegate pattern* or *notification center*. To do either, you need to write quite a lot of boilerplate codes to make it work.

Lets go through each briefly.

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

## Notification pattern
With this, we need to get ParentVC to observe the modal dismissed notification.

```Swift
class ParentVC: UIViewController {
  override func viewDidLoad {
    super.viewDidLoad()
```

## Reactive pattern
When you use ReactiveCocoa/ReactiveSwift, you could easily do that in several lines of codes in the presenting VC.

```Swift
let onboardNav = OnboardingNavigationController()

onboardNav.reactive
  .trigger(for: #selector(onboardNav.viewDidDisappear(_:)))
  .observe { _ in self.load() }

presentAlertVC( onboardNav, animated: false, completion: nil)
```
