# chat_app

This is a real-time two-sided chat application built using Flutter, Firebase Firestore, and Firebase Authentication. Below are the key features included in the app.

Features Overview
1. User Authentication - 
Users can sign up and log in using Firebase Authentication.
After a successful login, users are redirected to the chat screen automatically.
Users can log out anytime, returning to the login screen.

2. Real-time Chat Updates - 
Messages are stored in Firebase Firestore (a NoSQL cloud database).
The app listens to live updates using StreamBuilder, ensuring messages appear instantly without refreshing.

3. Auto-Navigation After Login - 
The app checks if a user is already logged in.
If logged in, it skips the login screen and directly opens the chat screen.
If not logged in, the app shows the login/signup page.

4 Sending and Receiving Messages - 
Users can send messages, which get stored in Firestore along with a timestamp.
Messages are instantly delivered to the recipient using real-time Firestore updates.
Messages are displayed in a chat UI similar to WhatsApp or Messenger.

5. Single Message Deletion - 
Users can delete individual messages from the chat.
This removes the message from Firestore, and the UI updates immediately.

6. Full Chat Deletion - 
Users have an option to delete the entire conversation.
This clears all messages from Firestore for both users.

7. Two-Sided Chat - 
The app supports two-way messaging, meaning both users can see messages in real-time.
Messages include sender, receiver, timestamp, and text content.
  
Summary - 

- Firebase Authentication for login/logout
- Firestore Database for storing messages
- StreamBuilder for live chat updates
- Auto-navigation after login
- Message sending & receiving
- Single message deletion
- Full chat deletion
- Two-sided chat system

