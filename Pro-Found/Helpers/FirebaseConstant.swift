//
//  FirebaseConstant.swift
//  Pro-Found
//
//  Created by Hsueh Peng Tseng on 2022/6/13.
//

import FirebaseFirestore
import FirebaseStorage

let db = Firestore.firestore()
let dbUsers = db.collection("Users")
let dbCourses = db.collection("Courses")
let dbScheduledCourse = db.collection("ScheduledCourse")
let dbPosts =  db.collection("Posts")
let dbEvents = db.collection("Events")
let dbArticles = db.collection("Articles")
let dbTutors = db.collection("Tutors")
let dbReplies = db.collection("Reply")
let dbChats = db.collection("Chats")

let storage = Storage.storage().reference()
let storageArticleImages = storage.child("ArticleImages")
let storagePostImages = storage.child("PostImages")
let storageEventImages = storage.child("EventImages")
let storageUserProfileImages = storage.child("UserProfileImages")
let storageUserBackgroundImages = storage.child("UserBackgroundImages")
