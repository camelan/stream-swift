//
//  Feed+Following.swift
//  GetStream-iOS
//
//  Created by Alexey Bukhtin on 02/01/2019.
//  Copyright © 2019 Stream.io Inc. All rights reserved.
//

import Foundation

extension Feed {
    /// Follows a target feed.
    ///
    /// - Parameters:
    ///     - target: the target feed this feed should follow, e.g. user:44.
    ///     - activityCopyLimit: how many activities should be copied from the target feed, max 1000, default 100.
    /// - Returns: an object to cancel the request.
    @discardableResult
    public func follow(toTarget target: FeedId, activityCopyLimit: Int = 100, completion: @escaping StatusCodeCompletion) -> Cancellable {
        let activityCopyLimit = max(0, min(1000, activityCopyLimit))
        let endpoint = FeedEndpoint.follow(feedId, target: target, activityCopyLimit: activityCopyLimit)
        
        return client.request(endpoint: endpoint) { $0.parseStatusCode(completion) }
    }
    
    @discardableResult
    public func unfollow(fromTarget target: FeedId, keepHistory: Bool = false, completion: @escaping StatusCodeCompletion) -> Cancellable {
        return client.request(endpoint: FeedEndpoint.unfollow(feedId, target: target, keepHistory: keepHistory)) {
            $0.parseStatusCode(completion)
        }
    }
    
    /// Returns a paginated list of followers.
    ///
    /// - Parameters:
    ///     - offset: number of followers to skip before returning results, max 400.
    ///     - limit: amount of results per request, max 500, default 25.
    ///     - completion: a result with `Follower`'s or an error.
    /// - Note: the number of followers that can be retrieved is limited to 1000.
    /// - Returns: an object to cancel the request.
    @discardableResult
    public func followers(offset: Int = 0, limit: Int = 25, completion: @escaping FollowersCompletion) -> Cancellable {
        let limit = max(0, min(500, limit))
        let offset = max(0, min(400, offset))
        
        return client.request(endpoint: FeedEndpoint.followers(feedId, offset: offset, limit: limit)) {
            $0.parse(completion)
        }
    }
    
    /// Returns a paginated list of the feeds which are followed by the feed.
    ///
    /// - Parameters:
    ///     - filter: list of feeds to filter results on.
    ///     - offset: number of followers to skip before returning results, max 400.
    ///     - limit: amount of results per request, max 500, default 25.
    ///     - completion: a result with `Follower`'s or an error.
    /// - Note: the number of followers that can be retrieved is limited to 1000.
    /// - Returns: an object to cancel the request.
    @discardableResult
    public func following(filter: FeedIds = [],
                          offset: Int = 0,
                          limit: Int = 25,
                          completion: @escaping FollowersCompletion) -> Cancellable {
        let limit = max(0, min(500, limit))
        let offset = max(0, min(400, offset))
        
        return client.request(endpoint: FeedEndpoint.following(feedId, filter: filter, offset: offset, limit: limit)) {
            $0.parse(completion)
        }
    }
}