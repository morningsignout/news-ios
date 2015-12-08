//
// IADisqusComment.m
// Disquser
// 
// Copyright (c) 2011 Ikhsan Assaat. All Rights Reserved 
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import "IADisqusComment.h"

@implementation IADisqusComment

//@synthesize forumName, authorName, authorAvatar, authorEmail, authorURL, rawMessage, htmlMessage, date, likes, dislikes, ipAddress, threadID;

- (instancetype)initWithForum:(NSString *)forum AuthorName:(NSString *)authorName AuthorAvatar:(NSString *)authorAvatar AuthorEmail:(NSString *)authorEmail AuthorURL:(NSString *)authorURL RawMessage:(NSString *)rawMsg HTMLMessage:(NSString *)htmlMsg Date:(NSDate *)date Likes:(NSNumber *)likes dislikes:(NSNumber *)dislikes IPAddress:(NSString *)ip ThreadID:(NSNumber *)threadID {
    if (self = [super init]) {
        self.forumName = forum;
        self.authorName = authorName;
        self.authorAvatar = authorAvatar;
        self.authorEmail = authorEmail;
        self.authorURL = authorURL;
        self.rawMessage = rawMsg;
        self.htmlMessage = htmlMsg;
        self.date = date;
        self.likes = likes;
        self.dislikes = dislikes;
        self.ipAddress = ip;
        self.threadID = threadID;
    }
    return self;
}

@end
