# StreamingGraph Data Model Documentation

## Overview

This document describes the graph data model for a streaming platform built using Neo4j. The model represents the core entities and relationships that power a modern streaming service, enabling rich querying, analytics, and personalized recommendations.

## Graph Database Choice

We use **Neo4j** as the graph database for the following reasons:

- **Relationship-First Design**: Neo4j excels at modeling and querying complex relationships between entities
- **Performance**: Fast traversal of relationships enables real-time recommendations
- **Flexibility**: Schema-less design allows easy evolution of the data model
- **Query Language**: Cypher provides an intuitive, SQL-like syntax for graph queries
- **Analytics**: Built-in graph algorithms for advanced analytics and recommendations

## Node Types

### 1. User
Represents platform subscribers and their profile information.

**Properties:**
- `userId` (String, Unique): Unique identifier for the user
- `name` (String): User's full name
- `email` (String, Indexed): User's email address
- `joinDate` (Date): When the user joined the platform
- `country` (String): User's country of residence
- `subscriptionType` (String): Type of subscription (Basic, Standard, Premium)
- `age` (Integer): User's age

**Use Cases:**
- User profile management
- Subscription analytics
- Demographic targeting
- Personalized recommendations

### 2. Movie
Represents individual movies available on the platform.

**Properties:**
- `movieId` (String, Unique): Unique identifier for the movie
- `title` (String, Indexed): Movie title
- `releaseYear` (Integer, Indexed): Year of release
- `duration` (Integer): Duration in minutes
- `language` (String): Primary language
- `plot` (String): Brief plot description
- `rating` (Float): Average rating (0-10 scale)
- `budget` (Integer): Production budget in USD
- `revenue` (Integer): Box office revenue in USD

**Use Cases:**
- Content catalog management
- Search and discovery
- Financial analytics
- Content recommendations

### 3. Series
Represents TV series and multi-episode content.

**Properties:**
- `seriesId` (String, Unique): Unique identifier for the series
- `title` (String, Indexed): Series title
- `releaseYear` (Integer, Indexed): Year of first episode
- `seasons` (Integer): Number of seasons
- `episodes` (Integer): Total number of episodes
- `language` (String): Primary language
- `plot` (String): Brief series description
- `rating` (Float): Average rating (0-10 scale)
- `status` (String): Status (Ongoing, Completed, Cancelled)

**Use Cases:**
- Series catalog management
- Binge-watching analytics
- Season-based recommendations
- Content lifecycle tracking

### 4. Actor
Represents actors and actresses who perform in content.

**Properties:**
- `actorId` (String, Unique): Unique identifier for the actor
- `name` (String, Indexed): Actor's full name
- `birthDate` (Date): Date of birth
- `nationality` (String): Country of origin
- `biography` (String): Brief biography

**Use Cases:**
- Cast information
- Actor-based recommendations
- Career analytics
- Talent discovery

### 5. Director
Represents directors who create content.

**Properties:**
- `directorId` (String, Unique): Unique identifier for the director
- `name` (String, Indexed): Director's full name
- `birthDate` (Date): Date of birth
- `nationality` (String): Country of origin
- `biography` (String): Brief biography
- `awardsCount` (Integer): Number of major awards won

**Use Cases:**
- Director filmography
- Quality indicators
- Director-based recommendations
- Creator analytics

### 6. Genre
Represents content categories and themes.

**Properties:**
- `name` (String, Unique): Genre name (Action, Drama, Comedy, etc.)
- `description` (String): Genre description

**Use Cases:**
- Content categorization
- Genre-based filtering
- Preference analysis
- Recommendation algorithms

## Relationship Types

### 1. WATCHED
Connects Users to Movies or Series they have viewed.

**Properties:**
- `timestamp` (DateTime): When the content was watched
- `completionPercentage` (Integer): How much was watched (0-100)
- `device` (String): Device used (Smart TV, Mobile, Laptop, Tablet)
- `currentEpisode` (Integer, Optional): For series, the last episode watched

**Direction:** (User)-[:WATCHED]->(Movie|Series)

**Use Cases:**
- Viewing history
- Engagement metrics
- Completion rate analysis
- Device usage patterns

### 2. RATED
Connects Users to content they have rated.

**Properties:**
- `rating` (Integer): User's rating (1-10 scale)
- `timestamp` (DateTime): When the rating was given
- `review` (String, Optional): User's written review

**Direction:** (User)-[:RATED]->(Movie|Series)

**Use Cases:**
- User preferences
- Content quality metrics
- Review aggregation
- Personalized recommendations

### 3. ACTED_IN
Connects Actors to Movies or Series they performed in.

**Properties:**
- `character` (String): Name of the character played
- `role` (String): Type of role (Lead, Supporting, Guest)
- `seasons` (Array[Integer], Optional): For series, which seasons they appeared in

**Direction:** (Actor)-[:ACTED_IN]->(Movie|Series)

**Use Cases:**
- Cast information
- Actor filmography
- Character search
- Co-star discovery

### 4. DIRECTED
Connects Directors to Movies they directed.

**Properties:**
- `year` (Integer): Year the movie was directed

**Direction:** (Director)-[:DIRECTED]->(Movie)

**Use Cases:**
- Director filmography
- Creative credit attribution
- Director-based search
- Quality indicators

### 5. HAS_GENRE
Connects Movies or Series to their Genres.

**Properties:** None

**Direction:** (Movie|Series)-[:HAS_GENRE]->(Genre)

**Use Cases:**
- Content categorization
- Genre-based filtering
- Multi-genre analysis
- Recommendation algorithms

### 6. FOLLOWS
Connects Users who follow each other.

**Properties:**
- `since` (Date): When the follow relationship was established

**Direction:** (User)-[:FOLLOWS]->(User)

**Use Cases:**
- Social features
- Friend recommendations
- Social influence analysis
- Community building

### 7. ADDED_TO_WATCHLIST
Connects Users to content in their watchlist.

**Properties:**
- `addedDate` (Date): When the content was added
- `priority` (String): Priority level (High, Medium, Low)

**Direction:** (User)-[:ADDED_TO_WATCHLIST]->(Movie|Series)

**Use Cases:**
- Watchlist management
- Intent signals
- Future engagement prediction
- Reminder notifications

## Graph Schema Diagram

```
(User)-[:WATCHED]->(Movie)
(User)-[:WATCHED]->(Series)
(User)-[:RATED]->(Movie)
(User)-[:RATED]->(Series)
(User)-[:FOLLOWS]->(User)
(User)-[:ADDED_TO_WATCHLIST]->(Movie)
(User)-[:ADDED_TO_WATCHLIST]->(Series)

(Actor)-[:ACTED_IN]->(Movie)
(Actor)-[:ACTED_IN]->(Series)

(Director)-[:DIRECTED]->(Movie)

(Movie)-[:HAS_GENRE]->(Genre)
(Series)-[:HAS_GENRE]->(Genre)
```

## Query Patterns

### 1. Recommendation Algorithms

#### Collaborative Filtering
Find content watched by users with similar viewing patterns.

```cypher
MATCH (u:User)-[:WATCHED]->(c)<-[:WATCHED]-(similar:User)
WHERE u.userId = $userId
WITH similar, count(DISTINCT c) AS commonContent
ORDER BY commonContent DESC LIMIT 10
MATCH (similar)-[:WATCHED]->(recommendation)
WHERE NOT (u)-[:WATCHED]->(recommendation)
RETURN recommendation, count(*) AS score
ORDER BY score DESC
```

#### Content-Based Filtering
Find content similar to what the user has liked.

```cypher
MATCH (u:User)-[r:RATED]->(c)-[:HAS_GENRE]->(g)
WHERE u.userId = $userId AND r.rating >= 8
WITH u, g, count(*) AS genreCount
ORDER BY genreCount DESC LIMIT 3
MATCH (g)<-[:HAS_GENRE]-(recommendation)
WHERE NOT (u)-[:WATCHED]->(recommendation)
RETURN recommendation, count(*) AS score
ORDER BY score DESC
```

### 2. Social Recommendations

Find what friends are watching.

```cypher
MATCH (u:User)-[:FOLLOWS]->(friend)-[:WATCHED]->(c)
WHERE u.userId = $userId AND NOT (u)-[:WATCHED]->(c)
RETURN c, count(DISTINCT friend) AS friendCount
ORDER BY friendCount DESC
```

### 3. Analytics Queries

#### Engagement Metrics
```cypher
MATCH (u:User)-[w:WATCHED]->(c)
RETURN avg(w.completionPercentage) AS avgCompletion,
       count(w) AS totalViews
```

#### Popular Content
```cypher
MATCH (c)<-[:WATCHED]-(u)
RETURN c.title, count(u) AS views
ORDER BY views DESC
LIMIT 10
```

## Best Practices

### 1. Indexing
- Always create unique constraints on ID properties
- Index frequently searched properties (title, name, email)
- Index properties used in WHERE clauses

### 2. Query Optimization
- Use LIMIT to constrain result sets
- Use WITH clauses to filter early
- Leverage indexes in MATCH patterns
- Use EXPLAIN and PROFILE for query analysis

### 3. Data Modeling
- Keep relationship properties lightweight
- Use appropriate data types
- Normalize where appropriate
- Consider query patterns when modeling

### 4. Scalability
- Partition large result sets
- Use batch operations for bulk imports
- Monitor query performance
- Consider read replicas for analytics

## Future Enhancements

### Potential Additions
1. **Episode Node**: For granular series tracking
2. **Review Node**: For detailed user reviews
3. **Playlist Node**: For user-created collections
4. **Studio Node**: For production companies
5. **Award Node**: For awards and nominations
6. **Subtitle/Audio Tracks**: For localization support
7. **Device Node**: For device-specific analytics
8. **Payment/Transaction**: For subscription analytics

### Advanced Relationships
1. **SIMILAR_TO**: Pre-computed content similarity
2. **RECOMMENDED_FOR**: Cached recommendations
3. **CO_STARS_WITH**: Actor collaboration network
4. **SEQUEL_OF/PREQUEL_OF**: Content continuity
5. **INSPIRED_BY**: Content lineage

## Technical Requirements

### Neo4j Version
- Minimum: Neo4j 4.0+
- Recommended: Neo4j 5.x for latest features

### Resources
- RAM: Minimum 4GB, Recommended 8GB+
- Storage: SSD recommended for performance
- CPU: Multi-core for parallel query execution

### Configuration
```
# Recommended neo4j.conf settings
dbms.memory.heap.initial_size=2G
dbms.memory.heap.max_size=4G
dbms.memory.pagecache.size=2G
```

## References

- [Neo4j Documentation](https://neo4j.com/docs/)
- [Cypher Query Language](https://neo4j.com/docs/cypher-manual/current/)
- [Graph Data Science Library](https://neo4j.com/docs/graph-data-science/current/)
- [Neo4j Best Practices](https://neo4j.com/developer/guide-performance-tuning/)
