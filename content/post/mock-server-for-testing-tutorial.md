+++
description = "Why, What and How"
author = ""
tags = ["Tech"]
date = "2016-10-27T13:05:19+11:00"
title = "Easy Functional and Integration Testing with Mock Server | Tutorial and Example"

+++
![](/blogFiles/mockingbird.jpg)

This blog post accompanies the talk I did with [Mobile Melbourne Meetup November.](https://www.meetup.com/MelbourneMobile/events/227028464/)

You can download the [presentation slides here.](/blogFiles/MockServerPresenation.pdf)

# Basic Testing
Increasingly, more and more mobile apps rely on some kind of api/backend server to work. Be it to save user data, fetch new data, or syncing live chat. Testing api integration usually require [mocking/stubbing](http://martinfowler.com/articles/mocksArentStubs.html) the network calls.

There are three basic layers of testing:

1. **Unit test** - making sure each function/unit of code works as expected
2. **Functional test** - making sure units interact with each other as expected
3. **Integration test** - making sure our app integrate with other app/api/services as expected

Mock server helps with all layers of tests, although it is particularly useful for functional and integration.

# Why Use Mock Server
### 1. Reuse
Practically everyone deploys on multiple platform nowadays. Java on Android, JS on web, Swift on iOS and unless you do full hybrid like Xamarin or React Native, you will need to mock the web services for testing in each and every separate languages.

Mock server promotes sharing and code reuse, write once and use to test ios/android/web app. No need to write mock several times for different platform. You can just connect each app to the mock server and done.

### 2. Reducing Dependency of API
In the times when the API team is delayed/not in sync with the front end team's sprint, mock server allows us to write our app and test agaisnt the mock server. This also applies when API server is down for whatever reason.

This reduces dependency on each other and reduces coupling, which is always a good thing.

### 3. Debugging
Sometimes it is hard to reproduce a bug, especially when the bug is triggered by a specific response from the server. You could either modify your code temporarily to mimic that incoming response, or you could just make the mock server return a specific bug-causing response.

### 4. Predictability and Consistency
When you use remote server to test, and it comes back with error or high latency, it is very hard to determine what's wrong. How do you know the fault lies with the network connection or with the server?

Since mock server lives on your local machine, it is very easy see if it isn't working properly.

# What is Mock Server
Mock server is just a web server that will give us consistent response for particular request, that's it. The only requirement is that the request and response format need to be consistent with the production server so that our test wouldn’t be able to tell the difference.

The main benefit is that the mock server is operated and maintained for the benefit of the development team, so you can make it as simple or as complex as you need it to.

It is just another tool in our toolbox. A very helpful one.

# How to Use Mock Server
There are several existing solutions that's quite popular. If you Google 'mock server', you will find:

- [Mock Server](http://www.mock-server.com/)
- [Wiremock](http://wiremock.org/)
- [Mocky](http://www.mocky.io/)

If you love Objective-C, there is an embedded web server called [GCDWebServer](https://github.com/swisspol/GCDWebServer) that will run on your Mac.

You should use whichever stack that your team is familiar with or the stack that the backend team uses. When you have some problem, you could always give them a shout!

For our tutorial, we will just write one from scratch using a combination of: 

- [Node](https://nodejs.org/en/) to run the server 
- [Express](http://expressjs.com/) to route the requests
- [Morgan](https://github.com/expressjs/morgan) to log the requests

# Basic Node & Express
Make sure that you have installed Node from the link above. For this tutorial, also please install [Yarn](https://yarnpkg.com/en/docs/install).

Open up your terminal and start by making an empty directory and going into it.

```bash
$ mkdir mock
$ cd mock
```

Now we can initialize an empty app. When it asks question, you can either enter your app detail, or just keep pressing `enter` key to use the default value.

```bash
$  yarn init
yarn init v0.16.1
question name (mock2):
question version (1.0.0):
question description:
question entry point (index.js):
question git repository:
question author:
question license (MIT):
success Saved package.json
✨  Done in 59.45s.
```

Now when you list the files with `ls`, you should see only one `package.json` file in the directory. Let continue by installing Express and Morgan.

```bash
$ yarn add express morgan
```

After a while, it should download and install both packages. You can check by listing the files. Now we can start writing our basic Express app.

Let's create a new file called `app.js` and open with with your favourite text editor. I will give example using Vim:

```bash
$ vim app.js
```

Inside the file, copy paste this block:

```javascript
// 1
const express = require('express'), 
app = express(),
morgan = require('morgan');

// 2
app.use(morgan('dev'));

// 3
app.get('/', function (req, res) {
  res.send('Hello World!');
});

// 4
app.listen(5678, function () {
   console.log('listening on port 5678!');
});
```

1. Here we tell Node that we require Express and Morgan, and that we assign `app` constant to the express module
2. We tell Express to use Morgan with the profile `'dev'`
3. We tell Express to send `'Hello World!'` when a GET request is sent to `'/'`
4. Lastly we tell Express to listen to port `5678` and prints a console log with that message

To test this, just run `node app.js` in the folder, and you should get `listening on port 5678!` message printed. To test this, you can open [http://localhost:5678/](http://localhost:5678/) in your web browser to see 'Hello World!' printed.

Congrats, your have just built your first Node + Express app!

Now if you check out the terminal window where you run the app, you should see:

```
GET / 200 2.518 ms - 12
```

That message is from Morgan and it serves just a logging purposes to tell us when our server get hit by requests.

We will revisit the mock server later, now we will have a look at the sample app that we are going to test.

# Favourite Food app
![](/blogFiles/Screenshot2016-11-1211.42.10.jpg)

You can clone [this repo](https://github.com/augusteo/FavouriteFood) to get a quick start.

This is a very simple app that will return the name of your favourite food when you put your name on. Right now the app only supports 'foo' and 'bar'.

There are only two noteworthy file in the project: `ViewController.swift` and `Favourite_FoodUITests.swift`.

The `ViewController` manages the network request and UI interaction while the test file, well, manages the UI Test.

There are two schemes; One to hit production remote API, and the other to hit mock server.

![](/blogFiles/Screenshot2016-11-1211.59.25.jpg)

Lets run the app using the `Favourite Food` scheme for now on the simulator. When it run, you can type `foo` as name and press `calculate`, it should return `Pizza`.

It should return `Roast Pork Knucle` when you enter `bar` as name.

Now if you rerun the app with `FF-Mock` scheme, it will crash when you press `calculate` because our mock server doesn't know how to handle the request. Let's fix that.

We will cover the multiple scheme for multiple api in another post.

# Mock server for Favourite Food
lets open the `app.js` of our mock server again.

add this code block just above the `app.listen` line.

```javascript
app.get('/3l2z2', function (req, res) {
  let favJson = {
    "foo": "Pizza",
    "bar": "Roast Pork Knuckle"
  };
  res.send(favJson);
});
```

So your `app.js` file should look like this now:

```javascript
const express = require('express'), 
app = express(),
morgan = require('morgan');

app.use(morgan('dev'));

app.get('/', function (req, res) {
  res.send('Hello World!');
});

app.get('/3l2z2', function (req, res) {
  let favJson = {
    "foo": "Pizza",
    "bar": "Roast Pork Knuckle"
  };
  res.send(favJson);
});

app.listen(5678, function () {
  console.log('listening on port 5678!');
});
```

All this block of code does, it to tell Express to return `favJson` object when `/3l2z2` is hit by request. Simple.

Now lets kill the previous node instance and rerun it again. to do this, just go to the terminal window where you run `node app.js` before and press `ctrl+c` to cancel it. Then rerun `node app.js`.

To confirm that the new json is up, open [http://localhost:5678/3l2z2](http://localhost:5678/3l2z2) on your web browser to check. you should see:

```json
{"foo":"Pizza","bar":"Roast Pork Knuckle"}
```

Awesome. Now if you run the iOS project with `FF-Mock` scheme, you should be getting Pizza and Roast Pork Knuckle successfully.

# Intro to UI Test
Lets get back to Xcode and set the scheme to `FavouriteFood`. Then press `cmd+u` to run the tests. You will see that the simulator would launch and the app would run by itself.

To see what's happening, lets open the `Favourite_FoodUITests.swift` file and take a look at one of the function:

```swift
func testFoo() {
  let textField = app.textFields["tf"]  // 1
  textField.tap()                       // 2
  textField.typeText("foo")             // 3
  app.buttons["Calculate"].tap()        // 4
  expectation(for: exists, evaluatedWith: app.staticTexts["Pizza"], handler: nil)
  waitForExpectations(timeout: 3, handler: nil) //5
}
```

Explanation:

1. Find the text field with accesibility label `tf`
2. Taps the field to bring up keyboard
3. Types `foo`
4. Taps the calculate button
5. Waits for 3 second for the app to show `Pizza` text

As you can see it is quite simple to write and run UI Test.

Now since our mock server is up and running, we can change the scheme to `FF-Mock` and press `cmd+u` to test it against the mock server. You should see that it is running correctly.

# Simple Express Refactor
This express app works well because we only have one endpoint request. Imagine if we have 300 endpoints to take care of, we couldn't just fit everything into `app.js`. To make things cleaner, we will refactor the app to different files.

First lets create a new directory instead of your `mock` directory, then make a file named `fav.js`

```
$ mkdir controllers
$ cd controllers
$ touch fav.js
```

Then open `fav.js` with your favourite editor and paste this block:

```javascript
exports.index = (req, res) => {
  let favJson = {
    "foo": "Pizza",
    "bar": "Roast Pork Knuckle"
  };
  res.send(favJson);
};
```

All this does is exporting a function called `index` that returns `favJson` as response. Very similar to the one in `app.js`

Save this file. Then open up `app.js` and replace this block:

```javascript
app.get('/3l2z2', function (req, res) {
  let favJson = {
    "foo": "Pizza",
    "bar": "Roast Pork Knuckle"
  };
  res.send(favJson);
});
```

With this:

```javascript
const favController = require('./controllers/fav');

app.get('/3l2z2', favController.index);
```

This replacement simply tells Express to ask `fav.js` to perform `index` function when a GET request is sent to `/3l2z2`.

If you have more parts in the mock server, such as user management or adding new food, feel free to create new controllers and use the same `require` syntax.

# Summary
We have learned:

- Why, What, How of mock server
- UITest in iOS
- Node + Express app to act as mock server
- Refactor Express

What was covered in the talk but didn't make it to this post:

- Using schemes in Xcode to manage multiple URLs
- Using [Fastlane](https://fastlane.tools/) to run tests against mock server on CI server

Those topics are better served by their own dedicated post.
