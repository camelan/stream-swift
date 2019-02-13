//
//  Activity.swift
//  GetStream
//
//  Created by Alexey Bukhtin on 08/11/2018.
//  Copyright © 2018 Stream.io Inc. All rights reserved.
//

import Foundation

public typealias Activity = EnrichedActivity<String, String, String, DefaultReaction>

open class EnrichedActivity<ActorType: Enrichable,
                            ObjectType: Enrichable,
                            TargetType: Enrichable,
                            ReactionType: ReactionProtocol>: ActivityProtocol {
    /// - Note: These reserved words must not be used as field names:
    ///         activity_id, activity, analytics, extra_context, id, is_read, is_seen, origin, score, site_id, to
    enum CodingKeys: String, CodingKey {
        case id
        case actor
        case verb
        case object
        case target
        case foreignId = "foreign_id"
        case time
        case feedIds = "to"
        case userOwnReactions = "own_reactions"
        case latestReactions = "latest_reactions"
        case reactionCounts = "reaction_counts"
    }
    
    /// The Stream id of the activity.
    public var id: String = ""
    /// The actor performing the activity.
    public let actor: ActorType
    /// The verb of the activity.
    public let verb: Verb
    /// The object of the activity.
    public let object: ObjectType
    /// The optional target of the activity.
    public let target: TargetType?
    /// A unique ID from your application for this activity. IE: pin:1 or like:300.
    public var foreignId: String?
    /// The optional time of the activity, isoformat. Default is the current time.
    public var time: Date?
    /// An array allows you to specify a list of feeds to which the activity should be copied.
    /// One way to think about it is as the CC functionality of email.
    public var feedIds: FeedIds?
    /// Include reactions added by current user to all activities.
    public var userOwnReactions: [ReactionKind: [ReactionType]]?
    /// Include recent reactions to activities.
    public var latestReactions: [ReactionKind: [ReactionType]]?
    /// Include reaction counts to activities.
    public var reactionCounts: [ReactionKind: Int]?
    
    /// Create an activity.
    ///
    /// - Parameters:
    ///     - actor: the actor performing the activity.
    ///     - verb: the verb of the activity.
    ///     - object: the object of the activity.
    ///     - target: the optional target of the activity.
    ///     - foreignId: a unique ID from your application for this activity.
    ///     - time: a time of the activity, isoformat. Default is the current time.
    ///     - feedIds: an array allows you to specify a list of feeds to which the activity should be copied.
    public init(actor: ActorType,
                verb: Verb,
                object: ObjectType,
                target: TargetType? = nil,
                foreignId: String? = nil,
                time: Date? = nil,
                feedIds: FeedIds? = nil) {
        self.actor = actor
        self.verb = verb
        self.object = object
        self.target = target
        self.foreignId = foreignId
        self.time = time
        self.feedIds = feedIds
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(actor.referenceId, forKey: .actor)
        try container.encode(verb, forKey: .verb)
        try container.encode(object.referenceId, forKey: .object)
        try container.encodeIfPresent(target?.referenceId, forKey: .target)
        try container.encodeIfPresent(foreignId, forKey: .foreignId)
        try container.encodeIfPresent(time, forKey: .time)
        try container.encodeIfPresent(feedIds, forKey: .feedIds)
    }
}

// MARK: - Description

extension EnrichedActivity: CustomStringConvertible {
    open var description: String {
        return "\(type(of: self))<id: \(id.isEmpty ? "n/a" : id), fid: \(foreignId ?? "n/a")>\n"
            + "\(actor.referenceId) \(verb) \(object.referenceId) at \(time?.description ?? "<n/a>")\n"
            + "feedIds: \(feedIds?.description ?? "[]")\n"
            + "ownReactions: \(userOwnReactions ?? [:])\n"
            + "latestReactions: \(latestReactions ?? [:])\n"
            + "reactionCounts: \(reactionCounts ?? [:])\n"
    }
}

// MARK: - Error Activity

public struct EnrichingActivityError: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case error
        case referenceId = "reference"
        case referenceType = "reference_type"
    }
    
    public let id: String
    public let error: String
    public let referenceId: String
    public let referenceType: String
}
