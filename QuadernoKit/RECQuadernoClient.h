//
//  RECQuadernoClient.h
//  
//  Copyright (c) 2013 Recrea (http://recreahq.com/)
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

#import <Foundation/Foundation.h>


/**
 * `RECQuadernoClient` is the base object for all transactions with the Quaderno API
 */
@interface RECQuadernoClient : NSObject

/**
 * The URL used to monitor reachability and construct requests from relative paths.
 */
@property (nonatomic, strong, readonly) NSURL *baseURL;

/**
 * The request rate limit for a particular user.
 */
@property (nonatomic, readonly) NSUInteger rateLimit;

/**
 * The remaining requests available for a particular user.
 */
@property (nonatomic, readonly) NSUInteger remainingRequests;


///---------------------
/// @name Initialization
///---------------------

/**
 * Initializes a `RECQuadernoClient` object with the specified authentication token and account.
 *
 * @param authToken Authentication token to access the Quaderno backend.
 * @param account   Name of a valid account registered in Quaderno.
 *
 * @return The newly-initialized Quaderno API client
 */
- (instancetype)initWithAuthenticationToken:(NSString *)authToken account:(NSString *)account;

/**
 * Initializes a `RECQuadernoClient` object with the specified authentication token, account and hostname.
 *
 * This is the designated initializer. If `baseURL` is nil the default URL is used instead.
 *
 * Note that this method is provided only for testing or debugging purposes. Most of the times you will be using `initWithAuthenticationToken:account:`.
 *
 * @param authToken Authentication token that grants access to backend.
 * @param baseURL   A custom base URL to use instead of the default.
 *
 * @return The newly-initialized Quaderno API client
 */
- (instancetype)initWithAuthenticationToken:(NSString *)authToken baseURL:(NSURL *)baseURL;


///---------------------------
/// @name Testing connectivity
///---------------------------

/**
 * Check whether or not the Quaderno backend is available
 *
 * @param response A block object to be executed when the task finishes. This block has no return value and takes one argument: whether or not the ping was successful.
 */
- (void)ping:(void (^)(BOOL success))response;


///---------------------------------------
/// @name Checking connection entitlements
///---------------------------------------

/**
 * Get the connection entitlements for current user.
 *
 * The connection entitlements are currently two: a request rate limit and the number of requests available. For example:
 *
 *	@{
 *		@"limit": @100,
 *		@"remaining": @100
 *	}
 *
 * @param connectionEntitlements A block object to be executed when the task finishes. This block has no return value and takes two arguments: a dictionary with the entitlements parameters and the error describing the network or parsing error that occurred. If the request fails `rateLimit` is set to nil.
 */
- (void)getConnectionEntitlements:(void (^)(NSDictionary *entitlements, NSError *error))connectionEntitlements;


@end
