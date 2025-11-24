# StreamingGraph Use Cases

This document provides detailed use cases and practical applications of the StreamingGraph data model for a streaming platform.

## Table of Contents
1. [Recommendation Systems](#recommendation-systems)
2. [User Analytics](#user-analytics)
3. [Content Discovery](#content-discovery)
4. [Social Features](#social-features)
5. [Business Intelligence](#business-intelligence)
6. [Content Management](#content-management)
7. [Personalization](#personalization)

---

## Recommendation Systems

### 1. Collaborative Filtering Recommendations

**Business Need**: Recommend content based on similar users' viewing patterns

**Implementation**:
```cypher
// Find users similar to target user
MATCH (target:User {userId: $userId})-[:WATCHED]->(content)<-[:WATCHED]-(similar:User)
WITH target, similar, count(DISTINCT content) AS similarity
ORDER BY similarity DESC LIMIT 20

// Get content watched by similar users but not by target
MATCH (similar)-[:WATCHED]->(recommendation)
WHERE NOT (target)-[:WATCHED]->(recommendation)
  AND (recommendation:Movie OR recommendation:Series)
WITH recommendation, count(DISTINCT similar) AS score
RETURN recommendation.title AS Title,
       recommendation.rating AS Rating,
       score AS RecommendedByUsers
ORDER BY score DESC, Rating DESC
LIMIT 10;
```

**Benefits**:
- Discovers hidden gems based on user behavior
- Improves engagement through relevant suggestions
- Adapts to changing user preferences over time

### 2. Genre-Based Content Recommendations

**Business Need**: Suggest content matching user's genre preferences

**Implementation**:
```cypher
// Identify user's favorite genres
MATCH (u:User {userId: $userId})-[r:RATED]->(content)-[:HAS_GENRE]->(g:Genre)
WHERE r.rating >= 8
WITH u, g, count(*) AS genrePreference
ORDER BY genrePreference DESC
LIMIT 3

// Find highly-rated content in favorite genres
MATCH (g)<-[:HAS_GENRE]-(recommendation)
WHERE NOT (u)-[:WATCHED]->(recommendation)
  AND recommendation.rating >= 7.5
RETURN DISTINCT recommendation.title AS Title,
       recommendation.rating AS Rating,
       collect(DISTINCT g.name)[0..3] AS Genres
ORDER BY recommendation.rating DESC
LIMIT 15;
```

**Benefits**:
- Personalized to user's taste
- Higher likelihood of user satisfaction
- Easy to explain to users ("Because you liked Drama")

### 3. Actor-Based Recommendations

**Business Need**: Recommend content featuring actors from user's favorites

**Implementation**:
```cypher
// Find actors from highly-rated content
MATCH (u:User {userId: $userId})-[r:RATED]->(content)<-[:ACTED_IN]-(actor:Actor)
WHERE r.rating >= 8
WITH u, actor, count(*) AS appearances
ORDER BY appearances DESC
LIMIT 5

// Find other content featuring these actors
MATCH (actor)-[:ACTED_IN]->(recommendation)
WHERE NOT (u)-[:WATCHED]->(recommendation)
  AND recommendation.rating >= 7.0
RETURN DISTINCT recommendation.title AS Title,
       collect(DISTINCT actor.name) AS FeaturedActors,
       recommendation.rating AS Rating
ORDER BY size(FeaturedActors) DESC, Rating DESC
LIMIT 10;
```

**Benefits**:
- Leverages star power
- Helps discover actor's filmography
- High conversion rate due to established preference

### 4. Friend-Based Social Recommendations

**Business Need**: Show what friends are watching

**Implementation**:
```cypher
MATCH (u:User {userId: $userId})-[:FOLLOWS]->(friend:User)
MATCH (friend)-[w:WATCHED]->(content)
WHERE NOT (u)-[:WATCHED]->(content)
  AND w.timestamp > datetime() - duration({days: 30})
WITH content, collect(DISTINCT friend.name) AS friends, count(DISTINCT friend) AS friendCount
RETURN content.title AS Title,
       friendCount AS FriendsWatching,
       friends[0..3] AS SampleFriends,
       content.rating AS Rating
ORDER BY friendCount DESC, Rating DESC
LIMIT 10;
```

**Benefits**:
- Social proof drives engagement
- FOMO (Fear of Missing Out) factor
- Community building

---

## User Analytics

### 5. User Engagement Metrics

**Business Need**: Track how engaged users are with the platform

**Implementation**:
```cypher
MATCH (u:User)-[w:WATCHED]->(content)
WITH u,
     count(DISTINCT content) AS contentWatched,
     avg(w.completionPercentage) AS avgCompletion,
     collect(DISTINCT w.device) AS devices
OPTIONAL MATCH (u)-[r:RATED]->()
WITH u, contentWatched, avgCompletion, devices, count(r) AS ratingsGiven
RETURN u.name AS User,
       u.subscriptionType AS Subscription,
       contentWatched AS ContentWatched,
       round(avgCompletion * 10) / 10 AS AvgCompletionRate,
       ratingsGiven AS RatingsGiven,
       size(devices) AS DevicesUsed,
       CASE 
         WHEN avgCompletion >= 80 THEN 'High'
         WHEN avgCompletion >= 50 THEN 'Medium'
         ELSE 'Low'
       END AS EngagementLevel
ORDER BY contentWatched DESC;
```

**Insights**:
- Identify power users vs. casual viewers
- Track completion rates by subscription tier
- Multi-device usage patterns
- Content rating behavior

### 6. Churn Risk Analysis

**Business Need**: Identify users at risk of canceling subscription

**Implementation**:
```cypher
MATCH (u:User)
OPTIONAL MATCH (u)-[w:WATCHED]->(content)
WHERE w.timestamp > datetime() - duration({days: 30})
WITH u,
     count(w) AS recentViews,
     max(w.timestamp) AS lastView,
     duration.between(max(w.timestamp), datetime()).days AS daysSinceLastView
WHERE recentViews < 2 OR daysSinceLastView > 14
RETURN u.userId AS UserId,
       u.name AS User,
       u.subscriptionType AS Subscription,
       recentViews AS ViewsLast30Days,
       daysSinceLastView AS DaysSinceLastView,
       CASE
         WHEN daysSinceLastView > 30 THEN 'High Risk'
         WHEN daysSinceLastView > 14 OR recentViews = 0 THEN 'Medium Risk'
         ELSE 'Low Risk'
       END AS ChurnRisk
ORDER BY daysSinceLastView DESC;
```

**Actions**:
- Send re-engagement emails
- Offer personalized recommendations
- Provide limited-time promotions
- Survey for feedback

### 7. Content Consumption Patterns

**Business Need**: Understand when and how users watch content

**Implementation**:
```cypher
// Viewing patterns by time of day
MATCH (u:User)-[w:WATCHED]->(content)
WHERE w.timestamp IS NOT NULL
WITH u,
     w.timestamp.hour AS hour,
     w.device AS device,
     labels(content)[0] AS contentType
RETURN hour AS HourOfDay,
       contentType AS ContentType,
       device AS Device,
       count(*) AS ViewCount
ORDER BY hour, ViewCount DESC;
```

**Insights**:
- Peak viewing times
- Device preferences by time
- Weekend vs. weekday patterns
- Content type preferences by time

---

## Content Discovery

### 8. Trending Content

**Business Need**: Highlight what's popular right now

**Implementation**:
```cypher
MATCH (content)<-[w:WATCHED]-(u:User)
WHERE w.timestamp > datetime() - duration({days: 7})
WITH content,
     count(DISTINCT u) AS uniqueViewers,
     count(w) AS totalViews,
     avg(w.completionPercentage) AS avgCompletion
OPTIONAL MATCH (content)<-[r:RATED]-(ru:User)
WHERE r.timestamp > datetime() - duration({days: 7})
WITH content, uniqueViewers, totalViews, avgCompletion,
     avg(r.rating) AS avgRating, count(r) AS ratingCount
WHERE uniqueViewers >= 3
RETURN content.title AS Title,
       labels(content)[0] AS Type,
       uniqueViewers AS UniqueViewers,
       totalViews AS TotalViews,
       round(avgCompletion * 10) / 10 AS AvgCompletion,
       round(avgRating * 10) / 10 AS RecentRating,
       ratingCount AS Ratings
ORDER BY uniqueViewers DESC, avgRating DESC
LIMIT 10;
```

**Benefits**:
- Real-time content promotion
- Social proof for new content
- Helps surface hidden gems

### 9. Similar Content Discovery

**Business Need**: "If you liked X, you'll love Y"

**Implementation**:
```cypher
// Find content similar to a specific movie/series
MATCH (target {title: $contentTitle})-[:HAS_GENRE]->(g:Genre)
WITH target, collect(g) AS targetGenres

MATCH (similar)-[:HAS_GENRE]->(g:Genre)
WHERE similar <> target
  AND g IN targetGenres
  AND (similar:Movie OR similar:Series)
WITH similar, count(DISTINCT g) AS commonGenres, targetGenres
WHERE commonGenres >= 2

OPTIONAL MATCH (target)<-[:ACTED_IN]-(actor:Actor)-[:ACTED_IN]->(similar)
WITH similar, commonGenres, count(DISTINCT actor) AS commonActors

RETURN similar.title AS SimilarContent,
       labels(similar)[0] AS Type,
       similar.rating AS Rating,
       commonGenres AS SharedGenres,
       commonActors AS SharedActors,
       (commonGenres * 2 + commonActors * 3) AS SimilarityScore
ORDER BY SimilarityScore DESC, Rating DESC
LIMIT 10;
```

**Benefits**:
- Keeps users engaged with related content
- Easy transition between content
- Increases viewing time

### 10. New Release Recommendations

**Business Need**: Promote new content to interested users

**Implementation**:
```cypher
// Find new releases matching user preferences
MATCH (u:User {userId: $userId})-[:WATCHED]->(watched)-[:HAS_GENRE]->(g:Genre)
WITH u, g, count(*) AS genreInterest
ORDER BY genreInterest DESC

MATCH (newContent:Movie)-[:HAS_GENRE]->(g)
WHERE newContent.releaseYear >= year(date()) - 1
  AND NOT (u)-[:WATCHED]->(newContent)
WITH u, newContent, collect(DISTINCT g.name) AS matchingGenres, sum(genreInterest) AS relevanceScore

OPTIONAL MATCH (newContent)<-[:ACTED_IN]-(actor:Actor)-[:ACTED_IN]->(watched)<-[r:RATED]-(u)
WHERE r.rating >= 8
WITH newContent, matchingGenres, relevanceScore, count(DISTINCT actor) AS favoriteActors

RETURN newContent.title AS Title,
       newContent.releaseYear AS Year,
       matchingGenres AS Genres,
       favoriteActors AS FavoriteActorsInThis,
       relevanceScore AS RelevanceScore
ORDER BY relevanceScore DESC, favoriteActors DESC
LIMIT 10;
```

**Benefits**:
- Targeted new release promotion
- Higher conversion on new content
- Reduced marketing costs

---

## Social Features

### 11. User Activity Feed

**Business Need**: Show what friends are watching/rating

**Implementation**:
```cypher
MATCH (u:User {userId: $userId})-[:FOLLOWS]->(friend:User)
MATCH (friend)-[activity]->(content)
WHERE (type(activity) = 'WATCHED' OR type(activity) = 'RATED')
  AND activity.timestamp > datetime() - duration({days: 7})
RETURN friend.name AS Friend,
       type(activity) AS Activity,
       content.title AS Content,
       CASE type(activity)
         WHEN 'RATED' THEN activity.rating
         ELSE null
       END AS Rating,
       activity.timestamp AS When
ORDER BY activity.timestamp DESC
LIMIT 20;
```

**Benefits**:
- Social engagement
- Discovery through friends
- Community feeling

### 12. Find Similar Users

**Business Need**: Connect users with similar tastes

**Implementation**:
```cypher
MATCH (u:User {userId: $userId})-[:WATCHED]->(content)<-[:WATCHED]-(similar:User)
WHERE u <> similar
  AND NOT (u)-[:FOLLOWS]->(similar)
WITH u, similar, count(DISTINCT content) AS sharedContent
WHERE sharedContent >= 3

MATCH (u)-[r1:RATED]->(content)<-[r2:RATED]-(similar)
WITH u, similar, sharedContent,
     avg(abs(r1.rating - r2.rating)) AS ratingDifference
WHERE ratingDifference < 2

RETURN similar.userId AS UserId,
       similar.name AS Name,
       sharedContent AS SharedContent,
       round(ratingDifference * 10) / 10 AS AvgRatingDiff,
       (sharedContent * 10 - ratingDifference * 5) AS SimilarityScore
ORDER BY SimilarityScore DESC
LIMIT 10;
```

**Benefits**:
- User discovery
- Network effects
- Increased platform stickiness

---

## Business Intelligence

### 13. Content ROI Analysis

**Business Need**: Evaluate investment returns on content

**Implementation**:
```cypher
MATCH (m:Movie)
WHERE m.budget IS NOT NULL AND m.revenue IS NOT NULL
WITH m,
     m.revenue - m.budget AS profit,
     round((m.revenue - m.budget) * 100.0 / m.budget) / 100 AS roi

OPTIONAL MATCH (m)<-[w:WATCHED]-(u:User)
WITH m, profit, roi, count(w) AS viewCount

RETURN m.title AS Movie,
       m.releaseYear AS Year,
       m.budget AS Budget,
       m.revenue AS Revenue,
       profit AS Profit,
       roi AS ROI_Percentage,
       viewCount AS PlatformViews,
       CASE
         WHEN roi > 1.5 THEN 'High ROI'
         WHEN roi > 0.5 THEN 'Good ROI'
         WHEN roi > 0 THEN 'Break Even'
         ELSE 'Loss'
       END AS Performance
ORDER BY roi DESC;
```

**Insights**:
- Content acquisition strategy
- Budget allocation
- Genre investment decisions

### 14. Subscription Conversion Analysis

**Business Need**: Understand subscription tier performance

**Implementation**:
```cypher
MATCH (u:User)
WITH u.subscriptionType AS tier, count(u) AS userCount

MATCH (users:User {subscriptionType: tier})-[w:WATCHED]->()
WITH tier, userCount,
     count(w) AS totalViews,
     count(DISTINCT users) AS activeUsers

RETURN tier AS SubscriptionTier,
       userCount AS TotalUsers,
       activeUsers AS ActiveUsers,
       round(activeUsers * 100.0 / userCount) AS ActivePercentage,
       totalViews AS TotalViews,
       round(totalViews * 1.0 / userCount) AS AvgViewsPerUser
ORDER BY CASE tier
         WHEN 'Premium' THEN 1
         WHEN 'Standard' THEN 2
         WHEN 'Basic' THEN 3
       END;
```

**Actions**:
- Targeted upgrade campaigns
- Feature optimization by tier
- Pricing strategy adjustments

### 15. Content Gap Analysis

**Business Need**: Identify missing content in catalog

**Implementation**:
```cypher
// Genres with low content count
MATCH (g:Genre)
OPTIONAL MATCH (g)<-[:HAS_GENRE]-(content)
WHERE content:Movie OR content:Series
WITH g, count(content) AS contentCount
WHERE contentCount < 5
RETURN g.name AS Genre,
       contentCount AS ContentCount,
       10 - contentCount AS GapSize
ORDER BY GapSize DESC;

// Popular actor combinations not in catalog
MATCH (a1:Actor)-[:ACTED_IN]->(c1)<-[w:WATCHED]-(u:User)
MATCH (a2:Actor)-[:ACTED_IN]->(c2)<-[:WATCHED]-(u)
WHERE a1 <> a2 AND c1 <> c2
WITH a1, a2, count(DISTINCT u) AS sharedFans
WHERE sharedFans >= 3
OPTIONAL MATCH (a1)-[:ACTED_IN]->(together)<-[:ACTED_IN]-(a2)
WHERE together IS NULL
RETURN a1.name AS Actor1,
       a2.name AS Actor2,
       sharedFans AS SharedFans
ORDER BY sharedFans DESC
LIMIT 10;
```

**Insights**:
- Content acquisition priorities
- Partnership opportunities
- Catalog diversification needs

---

## Content Management

### 16. Content Performance Dashboard

**Business Need**: Monitor content KPIs

**Implementation**:
```cypher
MATCH (content)
WHERE content:Movie OR content:Series
OPTIONAL MATCH (content)<-[w:WATCHED]-(u:User)
OPTIONAL MATCH (content)<-[r:RATED]-(ru:User)
WITH content,
     count(DISTINCT u) AS uniqueViewers,
     count(w) AS totalViews,
     avg(w.completionPercentage) AS avgCompletion,
     count(r) AS ratingCount,
     avg(r.rating) AS avgUserRating
RETURN content.title AS Title,
       labels(content)[0] AS Type,
       content.releaseYear AS Year,
       uniqueViewers AS UniqueViewers,
       totalViews AS TotalViews,
       round(avgCompletion * 10) / 10 AS AvgCompletion,
       ratingCount AS Ratings,
       round(avgUserRating * 10) / 10 AS AvgRating,
       CASE
         WHEN uniqueViewers >= 4 AND avgUserRating >= 8 THEN 'Hit'
         WHEN uniqueViewers >= 3 THEN 'Popular'
         WHEN uniqueViewers <= 1 THEN 'Underperforming'
         ELSE 'Average'
       END AS Status
ORDER BY uniqueViewers DESC;
```

**Benefits**:
- Quick performance overview
- Identify underperforming content
- Success metrics tracking

### 17. Content Lifecycle Management

**Business Need**: Manage content based on performance

**Implementation**:
```cypher
MATCH (content)
WHERE content:Movie OR content:Series
OPTIONAL MATCH (content)<-[w:WATCHED]-(u:User)
WHERE w.timestamp > datetime() - duration({days: 90})
WITH content,
     count(w) AS recent90DayViews,
     max(w.timestamp) AS lastViewed
RETURN content.title AS Title,
       recent90DayViews AS ViewsLast90Days,
       duration.between(lastViewed, datetime()).days AS DaysSinceLastView,
       CASE
         WHEN recent90DayViews = 0 THEN 'Consider Removal'
         WHEN recent90DayViews < 2 THEN 'Low Interest'
         WHEN recent90DayViews >= 5 THEN 'Keep - Popular'
         ELSE 'Monitor'
       END AS Recommendation
ORDER BY recent90DayViews ASC;
```

**Actions**:
- License renewal decisions
- Content removal planning
- Storage optimization

---

## Personalization

### 18. Personalized Homepage

**Business Need**: Customize homepage for each user

**Implementation**:
```cypher
// Get user's top genres
MATCH (u:User {userId: $userId})-[:WATCHED]->()-[:HAS_GENRE]->(g:Genre)
WITH u, g, count(*) AS views
ORDER BY views DESC
LIMIT 3
WITH u, collect(g) AS topGenres

// Continue watching (incomplete content)
MATCH (u)-[w:WATCHED]->(content)
WHERE w.completionPercentage < 100
WITH u, topGenres, collect({
  title: content.title,
  type: labels(content)[0],
  progress: w.completionPercentage
})[0..3] AS continueWatching

// Popular in your genres
MATCH (genre)<-[:HAS_GENRE]-(popular)
WHERE genre IN topGenres
  AND NOT (u)-[:WATCHED]->(popular)
WITH u, continueWatching, collect({
  title: popular.title,
  type: labels(popular)[0],
  rating: popular.rating
})[0..10] AS forYou

// Trending now
MATCH (trending)<-[w:WATCHED]-(others:User)
WHERE w.timestamp > datetime() - duration({days: 7})
  AND NOT (u)-[:WATCHED]->(trending)
WITH continueWatching, forYou, trending, count(*) AS trendScore
ORDER BY trendScore DESC
WITH continueWatching, forYou, collect({
  title: trending.title,
  type: labels(trending)[0],
  views: trendScore
})[0..10] AS trending

RETURN continueWatching AS ContinueWatching,
       forYou AS ForYou,
       trending AS TrendingNow;
```

**Benefits**:
- Higher engagement
- Reduced decision fatigue
- Improved user satisfaction

---

## Summary

These use cases demonstrate the power of graph databases for streaming platforms:

1. **Connected Data**: Relationships between users, content, and creators enable rich recommendations
2. **Real-Time**: Fast graph traversals support immediate personalization
3. **Flexible**: Easy to add new relationships and properties as needs evolve
4. **Insightful**: Graph patterns reveal hidden insights about user behavior
5. **Scalable**: Efficient queries even with millions of nodes and relationships

The StreamingGraph model provides a solid foundation for building modern, engaging streaming platforms with sophisticated recommendation engines and deep analytics capabilities.
