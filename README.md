# Table


<img src="https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/486/383/datas/original.png"
     alt="Register, Home, Join Group"
     height=275 />
<img src="https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/486/388/datas/original.png"
     alt="Group Details, Group Chat, Group Members"
     height=275 />
<img src="https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/486/402/datas/original.png"
     alt="Planning, Member Map, Profile"
     height=275 />
 <img src="https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/486/453/datas/original.png"
      alt="Friends List, Friend Requests, Edit Profile"
      height=275 />
     
## It's all on the table

Making plans to go out with friends can be hard. With people living in different places, liking different cuisines, or having different available times, visualizing all the possible options is difficult. Organizing in a group chat is cluttered, inefficient, and often leads to plans dissipating before they’ve even been discussed. In other words, it’s hard to see what options are on the Table. We wanted to create a platform that makes it easy for anyone to make and execute plans with their friends and family.

Table’s flagship feature is its groups. Using a simple, 6-digit code, you can create and join groups with other members. Through these groups, users can make event suggestions. These suggestions take in a date, start and end time, title, description, and location. We’ve also added a Friends system, which allows users to connect with friends on the app to easily plan group events and meetups. 

Your suggested events are shared with the rest of your group, and the Google Maps API is used to estimate the time it would take for different friends to reach the suggested location. Based on those times and where your friends want to go, they can vote on the different locations, ultimately picking one. This alleviates the hustle of trying to coordinate between multiple people, and at the same time uses a modular interface to separate event meetings.

Suggestions confirmed by a group vote become “plans”, with information on the timing and location of the first stop shared among group members. Users can view upcoming plans, and share pictures/videos of things that happened at past plans that became events through the built-in chat. Through this, you can also talk to friends about the trips you might want to plan. 

(Suggested events are voted on by the group, with information on the timing and location of the first stop shared among group members. The votes, along with the event, are finalized when users are ready to go)

When it's time for you to meet up, the app will send you a reminder notification, and will also notify you when your friends arrive and check in on the app. The Home Page will display the future trips you have planned and any notifications you might have, including friend requests. We built this app in Flutter, to cater to both iOS and Android users. All of our data is stored using the Firebase Realtime Database since it allows us the client to receive real-time updates to information such as even plans, group locations, and voting results. A Node.js server is responsible for sending push notifications to users through the Firebase Cloud Messaging System.

Have fun and remember, everything is on the Table!

## Credits
- [Bharat Kathi](https://github.com/bk1031)
  - Front-end Profiles Development
  - Server-side Development
- [Thomas Liang](https://github.com/thomasliang123)
  - Front-end Events Development
 - [Rohan Viswanathan](https://github.com/rohanviswanathan)
    - Front-end Groups Development
- [Kashyap Chaturvedula](https://github.com/kashyap456)
  - Database Design
  - Front-end Maps Development
