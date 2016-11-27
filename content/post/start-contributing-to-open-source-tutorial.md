+++
tags = ["Tech"]
title = "Start Contributing to Open Source - Tutorial"
description = "Help them to help yourself"
author = ""
date = "2016-11-27T12:54:11+11:00"

+++
![](/blogFiles/s00f6-w_oq8-joshua-earle.jpg)

Just recently my first [PR to ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa/pull/3307) has been merged and I'm still excited. I felt like a kid who got praised by teacher in front of the whole class!

I have been using ReactiveCocoa/ReactiveSwift since the start of 2016 and enjoying it very much. The learning curve is not easy, but once you grok it, its incredible.

This brings us to contributing to open source. IMO the easiest way would be:

1. Use open source codes
2. Find functionality that you wanted but is lacking
3. Fork the repo and make a new branch with the changes along with the tests
4. Submit Pull Request with you new branch
5. Action the change requests and code styling that many repo enforces
6. Voila!

That's what I did in the ReactiveCocoa PR. I wanted to bind `attributedText` of a `UITextView` from a `MutableProperty<NSAttributedString>` but the framework doesn't support that. 

```Swift
textView.reactive.attributedText <~ attributedStringProperty
  .producer
  .map { 
    // whatever 
  }
```

Without the binding, I have to use `didSet { }` on the property change, which isn't that bad, but could be better.

So my colleague suggested to submit PR with the changes that I wanted, and I did!

## Further resources
There are several guides for open source newbies (like myself):

[First Timers Only](http://www.firsttimersonly.com/)

[Github Guide](https://help.github.com/articles/where-can-i-find-open-source-projects-to-work-on/)

[Another Github Guide](https://guides.github.com/activities/contributing-to-open-source/)

Good luck!
