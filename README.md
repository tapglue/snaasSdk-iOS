# Tapglue iOS SDK

This will help you get started with Tapglue on iOS step by step guide.

A more detailed documentation can be found on our [documentation](http://developers.tapglue.com/docs/ios) website.

If you're interested in the iOS SDK Reference Documentation visit our docs on [CocoaPods](http://cocoadocs.org/docsets/Tapglue/).

## Get started

To start using the Tapglue API you need an `APP_TOKEN`. Visit our [Dashboard](https://dashboard.tapglue.com) and login with your credentials or create a new account.

## Sample App

Our [Sample app](https://github.com/tapglue/ios_sample) covers most of the concepts in our SDK and is a great showcase if you want to check implementation details.

# Installing the SDK

This page will help you get started with Tapglue on iOS step by step guide.

## Installing with CocoaPods

To install Tapglue with [CocoaPods](http://cocoapods.org/):

1. Install CocoaPods with `gem install cocoapods`
2. Run `pod setup` to create a local CocoaPods spec mirror, if this is the first time using CocoaPods.
3. Create a `Podfile` in your Xcode project and add:

```
pod 'Tapglue'
```

4. Run `pod install` in your project directory and Tapglue will be downloaded and installed.
5. Restart your Xcode project

 ## Installing with Carthage

To install Tapglue with [Carthage](https://github.com/Carthage/Carthage):

1. Install Carthage with `brew update` followed by `brew install Carthage`
2. Create a Cartfile in the root of your project
3. Add the following line to your Cartfile: `github "Tapglue/ios_sdk" ~> 2.0`
4. Run Carthage update
5. Copy binaries into your project, for RxSwift you only need the RxSwift framework file (not RxTest and RxBlocking)

## Manual Installation

If you don't want to use CocoaPods you download the latest version of [Tapglue from Github](https://github.com/tapglue/ios_sdk/releases) and copy it into your project.

1. Clone the SDK with `git clone https://github.com/tapglue/ios_sdk.git`
2. Copy the SDK into your Xcode project's folder
3. Import all dependencies

## Initialise the library

To start using Tapglue, you must initialise our SDK with your app token first. You can find your app token in the [Tapglue dashboard](https://dashboard.tapglue.com).

To instatiate Tapglue, simply call the constructor and pass in a Configuration instance with your settings. We recommend having the configuration set at a central place and reuse it, for example in the app delegate.

If you plan to use SIMS, please refer to the SIMS integration guide. 

## SDK Configuration

If you want to initialise SDK with a custom configuration you can specify following attributes:

- `baseUrl`
- `appToken`
- `log`

The following example showcases usage of the configuration and instantiation of Tapglue.

```swift
import Tapglue

let configuration = Configuration()
configuration.baseUrl = "https://api.tapglue.com"
configuration.appToken = "your app token"
// setting this to true makes the sdk print http requests and responses
configuration.log = true

let tapglue = Tapglue(configuration: configuration)
let rxTapglue = RxTapglue(configuration: configuration)
```

We offer two implementations of Tapglue, a default one with callbacks and one that returns RxSwift Observables.

## Compatibility

The framework is compatible with iOS 8.0 and up

# RxSwift or callbacks??

The SDK offers two interfaces with the exact same functionality. One of them uses callbacks to return results, the other uses RxSwift Observables. If you want to learn more about RxSwift you can read more about it [here](https://github.com/ReactiveX/RxSwift)

If you're familiar to RxSwift and FRP the interactions with the Rx interface are obvious. For the callbacks we always have a similar way of expressing it, for API calls that return entities (users, posts, etc) the methods expect a block with the signature:


```swift
(entity: Entity?, error: ErrorType?) -> ()
```

When the API request doesn't return an entity the signature will look like:

```swift
(success: Bool, error: ErrorType?) -> ()
```

# Create users

After installing Tapglue into your iOS app, creating users is usually the first thing you need to do, to build the basis for your news feed.

```swift
let user = User()
user.username = "some username"
user.password = "some password"

tapglue.createUser(user) { user, error in

}

//RxSwift
tapglue.createUser(user).subscribe()
```

## login users

There are two ways to login a user: by username or by email. Here's an example of loging in with a username:

```swift
tapglue.loginUser("username", password: "password") { user, error in

}

//RxSwift
tapglue.loginUser("username", password: "password").subscribe()
```

### Note: migrating from v1

Creating a user no longer will log the user in.

## Logout users

To logout the current user call `logout`.

```swift
tapglue.logout() { success, error in
  
}

//RxSwift
tapglue.logout().subscribe()
```
## Current User

When you successfully login a user, we store it as the `currentUser` by default. The current user is a property on the `Tapglue` and `RxTapglue` instances. Once logged in it is persisted and can be refreshed by calling `refreshCurrentUser()`

```swift
var currentUser = tapglue.currentUser

//refreshing the current user
tapglue.refreshCurrentUser() {user, error in
  if let user = user {
    currentUser = user
  }
}

//refreshing the current user in RxSwift
tapglue.refreshCurrentUser().subscribeNext {user in
  currentUser = user
}
```
## Update Current User

To update the current user call `updateCurrentUser(user: User)`.

```swift
let user = tapglue.currentUser
user.email = "new@email.com"
tapglue.updateCurrentUser(user) {user, error in
}

//RxSwift
tapglue.updateCurrentUser(user).subscribe()
```

## Delete Current User

This will delete the user from Tapglue. The user cannot be retrieved again after this actions.

```swift
tapglue.deleteCurrentUser() { success, error in
}

//RxSwift
tapglue.deleteCurrentUser().subscribe()
```

# Search Users

Connecting users and building a social graph is one of the most challenging parts of building a social experience. We provide three simple ways to help you get started.

## Search single users

One way to create connections between users within your app is to do a search. This can be achieved with the following:

```swift
tapglue.searchUsersForTerm("searchTerm") {users, error in
}

//RxSwift
tapglue.searchUsersForTerm("searchTerm").subscribeNext { users in
}
```

This will search for the provided term in the `username`, `firstName`, `lastName` and `email`.

## E-Mails search

If you want to search for multiple e-mails and get back a list of users. This is usually the case when you want to sync users from a source like the address-book. To do so use the following:

```swift
tapglue.searchEmails(emails) {users, error in
}

//RxSwift
tapglue.searchEmails(emails).subscribeNext {users in
}
```
## SocialIds search

A similar behaviour can be achieved if you want to sync users from another network like Facebook or Twitter.

```swift
let ids = ["id1", "id2"]
tapglue.searchSocialIds(ids, onPlatform: "facebook") { users, error in
}

//RxSwift
tapglue.searchSocialIds(ids, onPlatform: "facebook").subscribeNext { users in
}
```

# Connect Users

To connect users you have to create a Connection entity. The connection entity consists of a `userId` a `ConnectionType` and a `ConnectionState`. The user id represents who the connection is to, the `ConnectionType` can be of type `Follow` or `Friend` and the `ConnectionState` can be either `Pending` for when a request has to be accepted by the other party, `Confirmed` if it does not need to be accepted, or `Rejected` if the other party rejected the request. 

When a `Connection` request is received from another user in a `Pending` state, you can then respond by setting the `ConnectionState` to `Confirmed`

## Follow or Friend a user

```swift
let connection = Connection(toUserId: "userId", type: .Follow, state: .Confirmed)

tapglue.createConnection(connection) { connection, error in
}

//RxSwift
tapglue.createConnection(connection).subscribeNext { connection in
}
```

## Delete connections

```swift
tapglue.deleteConnection(toUserId: "123", type: .Follow) { success, error in 
}

//RxSwift
tapglue.deleteConnection(toUserId: "123", type: .Follow).subscribeNext { _ in
}
```

You can learn more about [deleting connections](doc:delete-connection) etc. in the reference documentation below.

# Create Posts

Events are very powerful to build Notification centers or activity feeds. However, if you wan't to include user generated content to build a proper news feed we provide a much more powerful entity for you: `Posts`.

## Post Dependencies

To create a post you need to specify two things first: Visibility and attachments. The possible values for visibility are `.Private` (only visible for the creator), `.Connections` (only visible for the connections of the creator and the creator), and `.Public` (visible for everybody).

## Attachments

Each post can have multiple attachments. An attachments of a post can currently be of type text or a url. A text can be used to represent the user generated text. A url is useful for different use-case such as a reference to an image or video. Furthermore you can specify a name for each attachments to add more context to the post.

The contents property of the Attachment entity is a dictionary where the key represents a BCP47 encoded language and the value the content (text, url or image)

```swift
let attachment = Attamchment(contents: ["en":"some content"], name: "my attachment", type: .Text)
```

## Creating a Post

So putting the last couple of concepts creating a post is pretty straight forward:

```swift
let attachment = Attamchment(contents: ["en":"some content"], name: "my attachment", type: .Text)

let post = Post(visibility: .Connections, attachments: [attachment])

tapglue.createPost(post) { post, error in
}

//RxSwift
tapglue.createPost(post).subscribeNext { post in
}
```
# Comments and Likes

Posts are the core entity of a news feed. To provide a richer and more engaging experiences, Tapglue enables you to comment or like posts

## Create comments

A comment consists of a dictionary of content, where the keys are BCP47 encoded languages and the values the text (similar to the attachments), and a `postId`. To create a comment first you need to create a comment entity and then create it on tapglue.

```swift
let comment = Comment(contents: ["en":"my comment"], postId: "postId")

tapglue.createComment(comment) { comment, error in
}

//RxSwift
tapglue.createComment(comment).subscribeNext { comment in
}
```

## Retrieve comments

To retrieve comments on a post:

```swift
tapglue.retrieveComments("postId") { comments, error in
}

//RxSwift
tapglue.retrieveComments("postId").subscribeNext { comments in
}
```
## Update comments

To update or delete a comment you can use:

- `updateComment`
- `deleteComment`

You can learn more about [deleting comments](doc:delete-comment) etc. in the reference documentation below.

## Like posts

To like a post you simply have to call `createLike` with a post id:

```swift
tapglue.createLike(forPostId: "postId") { like, error in
}

//RxSwift
tapglue.createLike(forPostId: "postId").subscribeNext { like in
}
```

## Retrieve likes

To retrieve likes on a post simply call `retrieveLikes` with the post id.

## Unlike posts

If a user unlikes a post again, use following method:

```objective-c
[Tapglue deleteLike:post withCompletionBlock:^(BOOL success, NSError *error) {
		if (success) {
			// Success handling
		}
		else {
			// Error handling
		}
}];
```

# Display feeds

In general there are three different types of feeds that Tapglue provides:

- News Feed
- Posts Feed
- Events Feed

The News Feed contains both: Posts and Events that have been created in the users social graph.
The Posts- and Events Feeds only contain entries of their associated type.

Additionally Tapglue provides lists of Posts and Events for a single user.

- User posts
- User events

Eventually, there is also the opportunity to query the feeds to only get certain types of events.

## News Feed

When retrieving the news feed you will get to lists: `posts` and `events` to do so run:

```objective-c
[Tapglue retrieveNewsFeedForCurrentUserWithCompletionBlock:^(NSArray *posts, NSArray *events, NSError *error) {
if (posts && events && !error) {
      	// Success handling
    } else {
    		// Error handling
    }
}];
```

## Posts Feed

To retrieve a Posts Feed there is following method:

```objective-c
[Tapglue retrievePostsFeedForCurrentUserWithCompletionBlock:^(NSArray *posts, NSError *error) {
  	if (posts && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

## Events Feed

Similar to the examples above, you can retrieve an events feed as shown in the example below:

```objective-c
[Tapglue retrieveEventsFeedForCurrentUserWithCompletionBlock:^(NSArray *events, NSInteger unreadCount, NSError *error) {
  	if (events && !error) {
      	// Update UI with events
    } else {
    		// Error handling
    }
}];
```

Sometimes the users will be offline and it would be bad to have an empty feed. Therefore we provide you a cached feed that provides the items from the latest events feed fetch.

### Cached events feed

```objective-c
NSArray *events;
events = [Tapglue cachedEventsFeedForCurrentUser];
```

### Unread events feed

To retrieve only the latest events that have not been read by the user you can call `` to save bandwidth.

```objective-c
[Tapglue retrieveUnreadEventsFeedForCurrentUserWithCompletionBlock:^(NSArray *events, NSError *error) {
  if (events && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

### Count of unread events

Sometimes you just want to know how many new events exists to display for a user. You can use that information and display in a badge over an icon. You can retrieve the count with `retrieveUnreadEventsCountForCurrentWithCompletionBlock`.

```objective-c
[Tapglue retrieveUnreadEventsCountForCurrentWithCompletionBlock:^(NSInteger unreadCount, NSError *error) {
  if (unreadCount && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

## User posts

You can also retrieve the posts of a single user and display them under a profile screen for example. There are two methods to achieve this:

- `retrievePostsForCurrentUser`
- `retrievePostsForUser`
- `retrievePostsForUserWithId`

The first option will retrieve the currentUsers posts. The other two for a user object or id that you pass.

```objective-c
[Tapglue retrievePostsForUser:user withCompletionBlock:^(NSArray *posts, NSError *error) {
  	if (posts && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

## User events

For retrieving a single users events there are following methods:

- `retrieveEventsForCurrentUser`
- `retrieveEventsForUser`

The first option will retrieve the currentUsers events. The second one will retrieve events for a user object that you pass.

```objective-c
[Tapglue retrieveEventsForUser:user withCompletionBlock:^(NSArray *events, NSError *error) {
  	if (events && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

## Queries

For all feeds there is the possibility to specify a query object to narrow down the results. These methods are:

- `retrieveNewsFeedForCurrentUserWithQuery`
- `retrieveEventsFeedForCurrentUserWithQuery`
- `retrieveEventsForCurrentUserWithQuery`
- `retrieveEventsWithQuery`

```objective-c
// Create Query Object
TGQuery *query = [TGQuery new];
[query addEventObjectWithIdEquals:objectId];
[query addTypeEquals:eventType];

// Retrieve Events with Query
[Tapglue retrieveEventsWithQuery:query andCompletionBlock:^(NSArray *events, NSError *error) {
 		if (events && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

For convenience we also created some methods if you only want to retrieve certain event types of events for a specific objectId. These are:

- `retrieveNewsFeedForCurrentUserForEventTypes`
- `retrieveEventsFeedForCurrentUserForEventTypes`
- `retrieveEventsForCurrentUserForEventTypes``

These methods expect an array that define a set of events, as shown in the example below:

```objective-c
[Tapglue retrieveEventsForCurrentUserForEventTypes:types withCompletionBlock:^(NSArray *events, NSError *error) {
  	if (events && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

# Friends and Follower Lists

You might want to show friends, follower and following lists to user in your app. Our SDK provides three methods to do so:

- `retrieveFollowersForCurrentUserWithCompletionBlock`
- `retrieveFollowsForCurrentUserWithCompletionBlock`
- `retrieveFriendsForCurrentUserWithCompletionBlock`

These methods can also be applied to other users with:

- `retrieveFollowsForUser:withCompletionBlock`
- `retrieveFollowersForUser:withCompletionBlock`
- `retrieveFriendsForUser:withCompletionBlock`

## Retrieve Follower

Here is an example to retrieve all follower of the currentUser:

```objective-c
[Tapglue retrieveFollowersForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
    if (users && !error) {
        // Update UI with users
    } else {
        // Error handling
    }
}];
```

# Debugging and Logging

You can turn on Tapglue logging by initialising the SDK with a custom configuration and setting enabling the logging there.

```objective-c
// Create config object
TGConfiguration *customConfig = [TGConfiguration defaultConfiguration];

// Configure custom settings
customConfig.loggingEnabled = true;
```

Setting `loggingEnabled = true` will cause the Tapglue library to log the users, queuing, and uploading of events, and other fine-grained info that's useful for understanding what the library is doing.

# Error handling

Error handling is an important area when building apps. To always provide the best user-experience to your users we defined custom errors that might happen when implementing Tapglue.

Most methods will provide you either a value or an error. We recommend to always check the `success` or value first and handle errors in case they occur. Each error will contain a `code` and a `message`. You can use the codes do define the behaviour on certain errors. The following example shows an error if the user already exists.

```objective-c
[Tapglue createAndLoginUserWithUsername:@"username" andPassword:@"password" withCompletionBlock:^(BOOL success, NSError *error) {
    if (error.code == kTGErrorUserAlreadyExists) {
        // Error handling
    } else {
        // Something else
    }
}];
```

# License

This SDK is provided under Apache 2.0 license. For the full license, please see the [LICENSE](LICENSE) file that
ships with this SDK.

# PR

TODO: Implement Comments & Likes on external objects
