//
// IADisquser.m
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


#import "IADisquser.h"
#import "IADisqusConfig.h"
//#import "AFHTTPClient.h"
#import <AFHTTPRequestOperationManager.h>

@implementation IADisquser

#pragma mark - View comments
+ (void)getCommentsWithParameters:(NSDictionary *)parameters success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock {
    // make a http client for disqus
    AFHTTPRequestOperationManager *disqusClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:DISQUS_BASE_URL]];
    
    // make and send a get request
    [disqusClient GET:@"threads/listPosts.json"
               parameters:parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      // fetch the json response to a dictionary
                      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                      
                      // check the code (success is 0)
                      NSNumber *code = [responseDictionary objectForKey:@"code"];
                      
                      if ([code integerValue] != 0) {   // there's an error
                          NSString *errorMessage = @"Error on fetching comments from disqus";
                          
                          NSError *error = [NSError errorWithDomain:@"com.ikhsanassaat.disquser" code:25 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil]];
                          failBlock(error);
                      } else {  // fetching comments in json succeeded, now on to parsing
                          // mutable array for handling comments
                          NSMutableArray *comments = [NSMutableArray array];
                          
                          // parse into array of comments
                          NSArray *commentsArray = [responseDictionary objectForKey:@"response"];
                          if ([commentsArray count] == 0) {
                              successBlock(nil);
                          } else {
                              // setting date format
                              NSDateFormatter *df = [[NSDateFormatter alloc] init];
                              NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                              [df setLocale:locale];
                              [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                              
                              // traverse the array, getting data for comments
                              for (NSDictionary *commentDictionary in commentsArray) {
                                  // for every comment, wrap them with IADisqusComment
                                  IADisqusComment *aDisqusComment = [[IADisqusComment alloc] init];
                                  
                                  aDisqusComment.authorName = [[commentDictionary objectForKey:@"author"] objectForKey:@"name"];
                                  aDisqusComment.authorAvatar = [[[commentDictionary objectForKey:@"author"] objectForKey:@"avatar"] objectForKey:@"cache"];
                                  aDisqusComment.authorEmail = [[commentDictionary objectForKey:@"author"] objectForKey:@"email"];
                                  aDisqusComment.authorURL = [[commentDictionary objectForKey:@"author"] objectForKey:@"url"];
                                  aDisqusComment.ipAddress = [commentDictionary objectForKey:@"ipAddress"];
                                  aDisqusComment.forumName = [commentDictionary objectForKey:@"forum"];
                                  aDisqusComment.likes = [commentDictionary objectForKey:@"likes"];
                                  aDisqusComment.dislikes = [commentDictionary objectForKey:@"dislikes"];
                                  aDisqusComment.rawMessage = [commentDictionary objectForKey:@"raw_message"];
                                  aDisqusComment.htmlMessage = [commentDictionary objectForKey:@"message"];
                                  aDisqusComment.date = [df dateFromString:[[commentDictionary objectForKey:@"createdAt"] stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
                                  aDisqusComment.threadID = [commentDictionary objectForKey:@"thread"];
                                  
                                  // add the comment to the mutable array
                                  [comments addObject:aDisqusComment];
                              }
                              
                              // release date formatting
                              
                              // pass it to the block
                              successBlock(comments);
                          }
                      }
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      // pass error to the block
                      failBlock(error);
                  }];
}

+ (void)getCommentsFromThreadID:(NSString *)threadID success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock {
    // make the parameters dictionary 
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                threadID, @"thread",
                                nil];
    
    // send the request
    [IADisquser getCommentsWithParameters:parameters success:successBlock fail:failBlock];
}

+ (void)getCommentsFromThreadIdentifier:(NSString *)threadIdentifier success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock {
    // make the parameters dictionary 
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                DISQUS_FORUM_NAME, @"forum",
                                threadIdentifier, @"thread:ident",
                                nil];
    
    // send the request
    [IADisquser getCommentsWithParameters:parameters success:successBlock fail:failBlock];
}

+ (void)getCommentsFromThreadLink:(NSString *)link success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock {
    // make the parameters dictionary 
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                DISQUS_FORUM_NAME, @"forum",
                                link, @"thread:link",
                                nil];
    
    // send the request
    [IADisquser getCommentsWithParameters:parameters success:successBlock fail:failBlock];
    
}

#pragma mark - Post comments
+ (void)getThreadIdParameters:(NSDictionary *)parameters success:(DisqusGetThreadIdSuccess)successBlock fail:(DisqusFail)failBlock {
    // make a http client for disqus
    AFHTTPRequestOperationManager *disqusClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:DISQUS_BASE_URL]];
    
    // fire the request
    [disqusClient GET:@"threads/details.json"
               parameters:parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      // fetch the json response to a dictionary
                      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                      
                      // get the code
                      NSNumber *code = [responseDictionary objectForKey:@"code"];
                      
                      if ([code integerValue] != 0) {
                          // there's an error
                          NSString *errorMessage = @"Error on getting the thread ID from disqus";
                          
                          NSError *error = [NSError errorWithDomain:@"com.ikhsanassaat.disquser" code:26 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil]];
                          failBlock(error);
                      } else {
                          // get the thread ID, pass it to the block
                          NSNumber *threadId = [[responseDictionary objectForKey:@"response"] objectForKey:@"id"];
                          successBlock(threadId);
                      }
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      failBlock(error);
                  }];
}

+ (void)getThreadIdWithIdentifier:(NSString *)threadIdentifier success:(DisqusGetThreadIdSuccess)successBlock fail:(DisqusFail)failBlock {
    // make parameters
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                DISQUS_FORUM_NAME, @"forum",
                                threadIdentifier, @"thread:ident",
                                nil];
    
    // call general method
    [IADisquser getThreadIdParameters:parameters success:successBlock fail:failBlock];
}

+ (void)getThreadIdWithLink:(NSString *)link success:(DisqusGetThreadIdSuccess)successBlock fail:(DisqusFail)failBlock {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                DISQUS_FORUM_NAME, @"forum",
                                link, @"thread:link",
                                nil];
    
    // call general method
    [IADisquser getThreadIdParameters:parameters success:successBlock fail:failBlock];
}

+ (void)postComment:(IADisqusComment *)comment success:(DisqusPostCommentSuccess)successBlock fail:(DisqusFail)failBlock {
    // make a disqus client 
    AFHTTPRequestOperationManager *disqusClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:DISQUS_BASE_URL]];
    //[disqusClient setParameterEncoding:AFFormURLParameterEncoding];
    
    [disqusClient POST:@"posts/create.json"
                parameters:@{@"api_secret" : DISQUS_API_SECRET, @"thread" : comment.threadID, @"author_name" : comment.authorName, @"author_email" : comment.authorEmail, @"message" : comment.rawMessage}
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       // fetch the json response to a dictionary
                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                       
                       // check the code (success is 0)
                       NSNumber *code = [responseDictionary objectForKey:@"code"];
                       
                       if ([code integerValue] != 0) {
                           // there's an error
                           NSString *errorMessage = @"Error on posting comment to disqus";
                           
                           NSError *error = [NSError errorWithDomain:@"com.ikhsanassaat.disquser" code:27 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil]];
                           failBlock(error);
                       } else {
                           successBlock();
                       }
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       failBlock(error);
                   }];
}

@end
