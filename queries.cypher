// StreamingGraph - Query Examples
// Neo4j Cypher Queries for Common Use Cases

// ============================================
// BASIC QUERIES - Data Exploration
// ============================================

// Query 1: Get all movies with their genres
MATCH (m:Movie)-[:HAS_GENRE]->(g:Genre)
RETURN m.title AS Movie, m.releaseYear AS Year, collect(g.name) AS Genres
ORDER BY m.releaseYear DESC;

// Query 2: Get all series with episode count
MATCH (s:Series)
RETURN s.title AS Series, s.seasons AS Seasons, s.episodes AS Episodes, s.rating AS Rating, s.status AS Status
ORDER BY s.rating DESC;

// Query 3: List all actors and their movies/series
MATCH (a:Actor)-[r:ACTED_IN]->(content)
WHERE content:Movie OR content:Series
RETURN a.name AS Actor, 
       labels(content)[0] AS Type,
       content.title AS Title, 
       r.character AS Character,
       r.role AS Role
ORDER BY a.name;

// Query 4: Get directors and their movies
MATCH (d:Director)-[:DIRECTED]->(m:Movie)
RETURN d.name AS Director, collect(m.title) AS Movies, d.awardsCount AS Awards
ORDER BY d.awardsCount DESC;

// ============================================
// USER ANALYTICS QUERIES
// ============================================

// Query 5: Most active users (by watch count)
MATCH (u:User)-[w:WATCHED]->()
RETURN u.name AS User, u.subscriptionType AS Subscription, count(w) AS WatchCount
ORDER BY WatchCount DESC;

// Query 6: User viewing history with ratings
MATCH (u:User {userId: 'USR001'})-[w:WATCHED]->(content)
OPTIONAL MATCH (u)-[r:RATED]->(content)
RETURN content.title AS Title, 
       labels(content)[0] AS Type,
       w.timestamp AS WatchedOn,
       w.completionPercentage AS Completed,
       r.rating AS UserRating,
       r.review AS Review
ORDER BY w.timestamp DESC;

// Query 7: Users' watchlists
MATCH (u:User)-[a:ADDED_TO_WATCHLIST]->(content)
WHERE content:Movie OR content:Series
RETURN u.name AS User, 
       content.title AS Title,
       labels(content)[0] AS Type,
       a.priority AS Priority,
       a.addedDate AS AddedDate
ORDER BY u.name, a.addedDate DESC;

// Query 8: User social network (followers and following)
MATCH (u:User {userId: 'USR001'})-[:FOLLOWS]->(following:User)
OPTIONAL MATCH (follower:User)-[:FOLLOWS]->(u)
RETURN u.name AS User,
       collect(DISTINCT following.name) AS Following,
       collect(DISTINCT follower.name) AS Followers;

// ============================================
// RECOMMENDATION QUERIES
// ============================================

// Query 9: Collaborative Filtering - Recommend movies based on similar users
// Find users who watched similar content to a specific user
MATCH (targetUser:User {userId: 'USR001'})-[:WATCHED]->(content)<-[:WATCHED]-(similarUser:User)
WITH targetUser, similarUser, count(DISTINCT content) AS commonWatches
WHERE commonWatches > 0
MATCH (similarUser)-[:WATCHED]->(recommendation)
WHERE NOT (targetUser)-[:WATCHED]->(recommendation)
  AND (recommendation:Movie OR recommendation:Series)
RETURN DISTINCT recommendation.title AS Recommendation,
       labels(recommendation)[0] AS Type,
       recommendation.rating AS Rating,
       count(DISTINCT similarUser) AS RecommendedBy
ORDER BY RecommendedBy DESC, Rating DESC
LIMIT 5;

// Query 10: Genre-based recommendations
// Recommend content based on user's favorite genres
MATCH (u:User {userId: 'USR001'})-[:WATCHED]->(watched)-[:HAS_GENRE]->(g:Genre)
WITH u, g, count(*) AS genreCount
ORDER BY genreCount DESC
LIMIT 3
MATCH (g)<-[:HAS_GENRE]-(recommendation)
WHERE NOT (u)-[:WATCHED]->(recommendation)
  AND (recommendation:Movie OR recommendation:Series)
RETURN DISTINCT recommendation.title AS Recommendation,
       labels(recommendation)[0] AS Type,
       recommendation.rating AS Rating,
       collect(DISTINCT g.name) AS MatchingGenres
ORDER BY recommendation.rating DESC
LIMIT 10;

// Query 11: Actor-based recommendations
// Recommend content featuring actors from highly-rated content
MATCH (u:User {userId: 'USR001'})-[r:RATED]->(content)
WHERE r.rating >= 8
MATCH (content)<-[:ACTED_IN]-(actor:Actor)-[:ACTED_IN]->(recommendation)
WHERE NOT (u)-[:WATCHED]->(recommendation)
  AND (recommendation:Movie OR recommendation:Series)
RETURN DISTINCT recommendation.title AS Recommendation,
       labels(recommendation)[0] AS Type,
       recommendation.rating AS Rating,
       collect(DISTINCT actor.name) AS Actors
ORDER BY recommendation.rating DESC
LIMIT 10;

// Query 12: Friend recommendations
// What are my friends watching that I haven't?
MATCH (u:User {userId: 'USR001'})-[:FOLLOWS]->(friend:User)
MATCH (friend)-[:WATCHED]->(content)
WHERE NOT (u)-[:WATCHED]->(content)
  AND (content:Movie OR content:Series)
WITH content, collect(DISTINCT friend.name) AS watchedByFriends, count(DISTINCT friend) AS friendCount
RETURN content.title AS Recommendation,
       labels(content)[0] AS Type,
       content.rating AS Rating,
       friendCount AS FriendsWatched,
       watchedByFriends AS WatchedBy
ORDER BY friendCount DESC, Rating DESC
LIMIT 10;

// ============================================
// CONTENT ANALYTICS QUERIES
// ============================================

// Query 13: Most popular content (by views)
MATCH (content)<-[w:WATCHED]-()
WHERE content:Movie OR content:Series
RETURN content.title AS Title,
       labels(content)[0] AS Type,
       count(w) AS Views,
       content.rating AS Rating
ORDER BY Views DESC
LIMIT 10;

// Query 14: Average ratings by genre
MATCH (content)-[:HAS_GENRE]->(g:Genre)
WHERE content:Movie OR content:Series
RETURN g.name AS Genre,
       count(content) AS ContentCount,
       round(avg(content.rating) * 100) / 100 AS AvgRating
ORDER BY AvgRating DESC;

// Query 15: Most prolific actors (by number of roles)
MATCH (a:Actor)-[r:ACTED_IN]->(content)
WHERE content:Movie OR content:Series
RETURN a.name AS Actor,
       count(DISTINCT content) AS Roles,
       collect(DISTINCT content.title)[0..5] AS SampleWorks
ORDER BY Roles DESC;

// Query 16: Content with best ratings and most views
MATCH (content)<-[w:WATCHED]-()
WHERE (content:Movie OR content:Series) AND content.rating >= 8.0
WITH content, count(w) AS views
RETURN content.title AS Title,
       labels(content)[0] AS Type,
       content.rating AS Rating,
       views AS Views
ORDER BY Rating DESC, Views DESC
LIMIT 10;

// ============================================
// ADVANCED ANALYTICS QUERIES
// ============================================

// Query 17: Find content with specific actor combinations
MATCH (a1:Actor {name: 'Tom Hanks'})-[:ACTED_IN]->(content)<-[:ACTED_IN]-(a2:Actor)
WHERE a2.name <> 'Tom Hanks'
RETURN content.title AS Title,
       labels(content)[0] AS Type,
       collect(DISTINCT a2.name) AS CoStars
ORDER BY content.title;

// Query 18: User engagement metrics
MATCH (u:User)-[w:WATCHED]->(content)
WITH u, avg(w.completionPercentage) AS avgCompletion, count(w) AS totalWatched
RETURN u.name AS User,
       u.subscriptionType AS Subscription,
       totalWatched AS ContentWatched,
       round(avgCompletion * 100) / 100 AS AvgCompletionRate
ORDER BY totalWatched DESC;

// Query 19: Genre preferences by subscription type
MATCH (u:User)-[:WATCHED]->(content)-[:HAS_GENRE]->(g:Genre)
WITH u.subscriptionType AS subscription, g.name AS genre, count(*) AS watchCount
RETURN subscription, genre, watchCount
ORDER BY subscription, watchCount DESC;

// Query 20: Content discovery paths
// How did users discover content? (through genres, actors, or friends)
MATCH (u:User {userId: 'USR001'})-[:WATCHED]->(content)
OPTIONAL MATCH (content)-[:HAS_GENRE]->(g:Genre)
OPTIONAL MATCH (content)<-[:ACTED_IN]-(a:Actor)
OPTIONAL MATCH (u)-[:FOLLOWS]->(friend:User)-[:WATCHED]->(content)
RETURN content.title AS Title,
       collect(DISTINCT g.name) AS Genres,
       collect(DISTINCT a.name)[0..3] AS TopActors,
       count(DISTINCT friend) AS WatchedByFriends
ORDER BY WatchedByFriends DESC;

// ============================================
// BUSINESS INTELLIGENCE QUERIES
// ============================================

// Query 21: Revenue analysis for movies
MATCH (m:Movie)
WHERE m.budget IS NOT NULL AND m.revenue IS NOT NULL
RETURN m.title AS Movie,
       m.budget AS Budget,
       m.revenue AS Revenue,
       round((m.revenue - m.budget) * 100.0 / m.budget) / 100 AS ROI_Percentage,
       m.revenue - m.budget AS Profit
ORDER BY Profit DESC;

// Query 22: Content library statistics
MATCH (m:Movie)
WITH count(m) AS movieCount
MATCH (s:Series)
WITH movieCount, count(s) AS seriesCount
MATCH (a:Actor)
WITH movieCount, seriesCount, count(a) AS actorCount
MATCH (d:Director)
WITH movieCount, seriesCount, actorCount, count(d) AS directorCount
MATCH (g:Genre)
RETURN movieCount AS Movies,
       seriesCount AS Series,
       actorCount AS Actors,
       directorCount AS Directors,
       count(g) AS Genres;

// Query 23: User retention by subscription type
MATCH (u:User)
WITH u.subscriptionType AS subscriptionType, 
     count(u) AS userCount,
     avg(duration.inMonths(u.joinDate, date()).months) AS avgTenureMonths
RETURN subscriptionType,
       userCount AS Users,
       round(avgTenureMonths * 100) / 100 AS AvgTenureMonths
ORDER BY Users DESC;

// Query 24: Most influential users (by follower count)
MATCH (u:User)<-[f:FOLLOWS]-()
WITH u, count(f) AS followerCount
OPTIONAL MATCH (u)-[:WATCHED]->(content)
OPTIONAL MATCH (u)-[r:RATED]->()
RETURN u.name AS User,
       u.subscriptionType AS Subscription,
       followerCount AS Followers,
       count(DISTINCT content) AS ContentWatched,
       count(r) AS RatingsGiven
ORDER BY followerCount DESC;

// Query 25: Content completion rates
MATCH (content)<-[w:WATCHED]-()
WHERE content:Movie OR content:Series
WITH content, 
     avg(w.completionPercentage) AS avgCompletion,
     count(w) AS viewCount
WHERE viewCount >= 2
RETURN content.title AS Title,
       labels(content)[0] AS Type,
       round(avgCompletion * 100) / 100 AS AvgCompletionRate,
       viewCount AS Views
ORDER BY AvgCompletionRate DESC, Views DESC;

// ============================================
// SHORTEST PATH & GRAPH ALGORITHMS
// ============================================

// Query 26: Shortest path between two actors (Kevin Bacon style)
MATCH path = shortestPath(
  (a1:Actor {name: 'Tom Hanks'})-[*]-(a2:Actor {name: 'Emma Stone'})
)
RETURN [node IN nodes(path) | 
  CASE 
    WHEN node:Actor THEN node.name
    WHEN node:Movie THEN node.title
    WHEN node:Series THEN node.title
    ELSE labels(node)[0]
  END
] AS ConnectionPath;

// Query 27: Find all content in a specific genre with high ratings
MATCH (g:Genre {name: 'Sci-Fi'})<-[:HAS_GENRE]-(content)
WHERE content.rating >= 8.0
RETURN content.title AS Title,
       labels(content)[0] AS Type,
       content.rating AS Rating,
       content.releaseYear AS Year
ORDER BY content.rating DESC;

// Query 28: User taste profile
MATCH (u:User {userId: 'USR001'})-[r:RATED]->(content)-[:HAS_GENRE]->(g:Genre)
WITH u, g, avg(r.rating) AS avgRatingForGenre, count(*) AS ratedCount
RETURN u.name AS User,
       g.name AS Genre,
       round(avgRatingForGenre * 100) / 100 AS AvgRating,
       ratedCount AS RatedCount
ORDER BY AvgRating DESC, RatedCount DESC;

// Query 29: Content with similar genres
MATCH (target:Movie {title: 'Inception'})-[:HAS_GENRE]->(g:Genre)
WITH target, collect(g) AS targetGenres
MATCH (similar)-[:HAS_GENRE]->(g:Genre)
WHERE similar <> target 
  AND (similar:Movie OR similar:Series)
  AND g IN targetGenres
WITH similar, count(DISTINCT g) AS commonGenres
WHERE commonGenres >= 2
RETURN similar.title AS SimilarContent,
       labels(similar)[0] AS Type,
       similar.rating AS Rating,
       commonGenres AS SharedGenres
ORDER BY SharedGenres DESC, Rating DESC
LIMIT 10;

// Query 30: Time-based viewing patterns
MATCH (u:User)-[w:WATCHED]->(content)
WITH u, content, w.timestamp.hour AS hour
WHERE hour IS NOT NULL
RETURN hour AS HourOfDay,
       count(*) AS ViewCount
ORDER BY hour;
