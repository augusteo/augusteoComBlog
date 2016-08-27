+++
author = ""
date = "2016-08-26T17:15:14+10:00"
description = "Tackling the classic algorithm with swift"
tags = ["Tech"]
title = "Binary Search Algorith with Recursion and Generics - Swift Tutorial"

+++
![](/blogFiles/photo-1463123081488-789f998ac9c4.jpeg)

Following through with my [last post](/swift-quick-sort-algorithm-with-recursion-and-generic), we will explore how to implement the [binary search](https://www.khanacademy.org/computing/computer-science/algorithms/binary-search/a/implementing-binary-search-of-an-array) algorithm in Swift. Of course it has to be generic too!

# Problem and assumption
This algorithm assumes that we have an array of comparable objects. That is to say, the compiler should know how to compare those objects. If your object is not a primitive type, then you can follow the [last post](/swift-quick-sort-algorithm-with-recursion-and-generic) on how to make the struct/class/enum conform to `Comparable` protocol.

lets say we have an array of numbers:

```swift
let arr = [4,1,78,34,666,23,0,999,3245,54]
```

We can't just apply binary search to this array because binary search assumes that the array is already sorted. So let's do it.

```swift
let arr = [4,1,78,34,666,23,0,999,3245,54].sort()
// [0, 1, 4, 23, 34, 54, 78, 666, 999, 3245]
```

Please remember to sort your array before applying the search, because it wouldn't return the correct result otherwise.

# Algorithm
Binary search is very simple. We pass and array and a search target, then it will return the index of the target inside the array to us. We will return an optional nil in the case of target not found.

The process in short, is as follow:

1. Check if midpoint of the array is our target, if yes, just return the index
2. If not, check if the target is greater than the midpoint
3. If yes, search from midpoint to end of array recursively
4. If not, search from start of array to midpoint recursively

That's it.

# Swift code
I have used generics in this code because this assumes you have read the last post about it :)

```swift
func binarySearch<T: Comparable>(array: [T], target: T, range: Range<Int> = 0..<arr.count) -> Int? { // interface
  guard range.startIndex < range.endIndex else { return nil } // 1

  let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2 // 2
  guard array[midIndex] != target else { return midIndex } // 3

  let newRange = array[midIndex] > target ? range.startIndex..<midIndex
    : midIndex.advancedBy(1)..<range.endIndex // 4

  return binarySearch(array, target: target, range: newRange) // 5
}
```

##### Interface
The function will take a generic type `T` which conforms to `Comparable` protocol. The array and target is of type T.

We have a `Range` of type `Int` and not `T` because a range just need to act as our index, which usually is `Int`. We have also added a default value for this param so user of this func doesn't need to specify the first range. The range is mostly for the recursion to work.

It returns an `Optional Int`. `Nil` for not found, and `Int` for index of target if found.

##### 1. Range checking
This is the first recursion exit point. If the start of the range is not smaller than the end range, that means we couldn't find the target. So just return nil

##### 2. Index on the middle of the array
We specify the `midIndex` of the array. We need to add the `startIndex +` at the start to accomodate the recursion that starts if the target number is larger than midpoint.

##### 3. Found the target!
The function will only proceed when the midpoint isn't the target. If it is, the function will exit and returns the target index.

##### 4. New range for recursion
When the midpoint is not the target, we have to find which half of the array to search. If the target is greater than midpoint, we will search the right side of the array and vice versa.

##### 5. Recursion trigger
This is where we invoke recursion to re-search the midpoint of the same array, but with the new range that we calculated on `// 4`. The recursion will keep going until either `// 1` hits, meaning the target isn't in the array or when `// 3` hits meaning we found the target and just returns the index.

# Testing
So now that we have a working search function, we can give it a try:

```swift
binarySearch(arr, target: 23)  // 3
binarySearch(arr, target: 999) // 8
binarySearch(arr, target: 213) // nil
binarySearch(arr, target: 54)  // 5
```

It worked!

But how do we really check if it work? We can either manually go through the array and count the index of the target, or we can employ the Swift assertion, like so:

```swift
assert(binarySearch(arr, target: 23)  == arr.indexOf(23))
assert(binarySearch(arr, target: 213) == arr.indexOf(213))
assert(binarySearch(arr, target: 4)   == arr.indexOf(4))
```
Here we employed the compiler assertion to check if our searching algorithm returns the same index as the standard library searching function. If the compiler doesn't complain, it means our work is done!

# Conclusion
Binary search is a classic divide and conquer method for a more efficient searching. There are many ways to do it, but recursion is one of the funnest way!
