
# 438finalproject

438 Final Project

  

  

create branches instead pushing directly to the main branch


## how to use db functions

Mongo kitten is the db package used to communicate between MongoDB Atlas and our app. I have wrote several functions to facilitate the use of crud operations from the database. 

  

There are two directories in the project root: <code>model</code> and <code>database</code>. <code>model</code> is used for all the database collection schemas, as a codable form to be easily used in other parts of the app. <code>database</code> only has one file called <code>MongoTest</code>, this file contains all functions you need to interact with the database. It may or may not change its name in the future. 

Below you will find how to use these functions:

**Note: all these functions use try await, be sure to wrap a <code>Task{}</code> and <code>do</code> block around them.**

Example:
```
Task{
    do{
        let client = try await dbManager.connect(uri: URI)
    }
    catch {
        print("An error occurred: \(error)")
    }
}
```

### Initiation
To interact with the database, initiate a database object:
```
let dbManager = MongoTest()
```
this does nothing but initiate a manager, you shouldn't have more than one manager per instance. 

### Connecting to the database

After initiating the database manager, establish a connection with the database itself.
```
let client = try await dbManager.connect(uri: URI)
```
replace URI with our URI. the <code>client</code> object currently does nothing, since you will be interacting with <code>dbManager</code> for all interactions. 

### Inserting a user
To insert a user, you need to create a <code>User</code> object first. 
```
let user = User(username: "user1", password: "password")
```

Then, you need to insert the user into the database by doing:
```
let insertResponse = try await dbManager.insertUser(user: user)
```
<code>insertUser()</code> returns a <code>Boolean</code> value. 

### Getting all users
To get all users, do this:
```
let userList = try await dbManager.getUsers()
```
userList will be a list of <code>User</code> objects, you can access individual users and its information by: 
```
let user1 = userList[0]

user1._id
user1.username
user1.password
```
**Beware: getUsers() might sometimes return <code>nil</code>. So be sure to do a null check before working on the list**

### Deleting a user
The process of deleting a user is similar to that of inserting a user, but using the <code>deleteUser()</code> function. The function accepts a <code>userId</code> of type <code>ObjectId</code>.
```
let userToBeDeleted = User(username: "user1", password: "password")
let deleteResponse = try await dbManager.deleteUser(userId: ObjectId("user id"))
l
```
As usual, <code>deleteUser()</code> returns either true or false.

### Logging a user in
To log in a user, there is a special function: <code>loginUser()</code>.
```
let userToBeLoggedIn = User(username: "username", password: "password")

let loginResponse = dbManager.loginUser(username: userToBeLoggedIn.username, password: userToBeLoggedIn.password)
```
As usual, <code>loginUser()</code> can return either true or false. 

