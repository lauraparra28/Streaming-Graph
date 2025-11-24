# StreamingGraph Visual Diagram

This document provides visual representations of the graph data model.

## Overall Graph Structure

```
                                    ┌─────────────┐
                                    │    Genre    │
                                    │             │
                                    │  • name     │
                                    └──────▲──────┘
                                           │
                                           │ HAS_GENRE
                                           │
                    ┌──────────────────────┴─────────────────────┐
                    │                                             │
          ┌─────────┴─────────┐                        ┌─────────┴─────────┐
          │      Movie         │                        │      Series        │
          │                    │                        │                    │
          │  • movieId         │                        │  • seriesId        │
          │  • title           │                        │  • title           │
          │  • releaseYear     │                        │  • releaseYear     │
          │  • duration        │                        │  • seasons         │
          │  • rating          │                        │  • episodes        │
          │  • budget          │                        │  • rating          │
          │  • revenue         │                        │  • status          │
          └─────────┬─────────┘                        └─────────┬─────────┘
                    │                                             │
                    │                                             │
         ┌──────────┼──────────┬─────────────────────────────────┼──────────┐
         │          │          │                                  │          │
         │ ACTED_IN │ DIRECTED │ WATCHED                  WATCHED │ ACTED_IN │
         │          │          │                                  │          │
    ┌────▼───┐ ┌───▼────┐ ┌───▼─────────────────────────────────▼───┐ ┌────▼───┐
    │ Actor  │ │Director│ │                User                      │ │ Actor  │
    │        │ │        │ │                                          │ │        │
    │• name  │ │• name  │ │  • userId         • subscriptionType    │ │• name  │
    │• birth │ │• birth │ │  • name           • age                 │ │        │
    └────────┘ └────────┘ │  • email          • country             │ └────────┘
                          │  • joinDate                             │
                          └──────────┬──────────────────────────────┘
                                     │
                            ┌────────┼────────┐
                            │        │        │
                         RATED    FOLLOWS  ADDED_TO_WATCHLIST
                            │        │        │
                            ▼        ▼        ▼
                     (back to       User    Content
                      content)   (social)  (intent)
```

## Node Types Detail

### User Node
```
┌─────────────────────────────────┐
│           User                  │
├─────────────────────────────────┤
│ Properties:                     │
│  • userId (unique)              │
│  • name                         │
│  • email (indexed)              │
│  • joinDate                     │
│  • country                      │
│  • subscriptionType             │
│  • age                          │
├─────────────────────────────────┤
│ Outgoing Relationships:         │
│  → WATCHED (Movie/Series)       │
│  → RATED (Movie/Series)         │
│  → FOLLOWS (User)               │
│  → ADDED_TO_WATCHLIST (Content) │
└─────────────────────────────────┘
```

### Movie Node
```
┌─────────────────────────────────┐
│           Movie                 │
├─────────────────────────────────┤
│ Properties:                     │
│  • movieId (unique)             │
│  • title (indexed)              │
│  • releaseYear (indexed)        │
│  • duration                     │
│  • language                     │
│  • plot                         │
│  • rating                       │
│  • budget                       │
│  • revenue                      │
├─────────────────────────────────┤
│ Incoming Relationships:         │
│  ← WATCHED (User)               │
│  ← RATED (User)                 │
│  ← ACTED_IN (Actor)             │
│  ← DIRECTED (Director)          │
│  ← ADDED_TO_WATCHLIST (User)    │
│ Outgoing Relationships:         │
│  → HAS_GENRE (Genre)            │
└─────────────────────────────────┘
```

### Series Node
```
┌─────────────────────────────────┐
│           Series                │
├─────────────────────────────────┤
│ Properties:                     │
│  • seriesId (unique)            │
│  • title (indexed)              │
│  • releaseYear (indexed)        │
│  • seasons                      │
│  • episodes                     │
│  • language                     │
│  • plot                         │
│  • rating                       │
│  • status                       │
├─────────────────────────────────┤
│ Incoming Relationships:         │
│  ← WATCHED (User)               │
│  ← RATED (User)                 │
│  ← ACTED_IN (Actor)             │
│  ← ADDED_TO_WATCHLIST (User)    │
│ Outgoing Relationships:         │
│  → HAS_GENRE (Genre)            │
└─────────────────────────────────┘
```

### Actor Node
```
┌─────────────────────────────────┐
│           Actor                 │
├─────────────────────────────────┤
│ Properties:                     │
│  • actorId (unique)             │
│  • name (indexed)               │
│  • birthDate                    │
│  • nationality                  │
│  • biography                    │
├─────────────────────────────────┤
│ Outgoing Relationships:         │
│  → ACTED_IN (Movie/Series)      │
│    Properties:                  │
│      - character                │
│      - role                     │
│      - seasons (for series)     │
└─────────────────────────────────┘
```

### Director Node
```
┌─────────────────────────────────┐
│           Director              │
├─────────────────────────────────┤
│ Properties:                     │
│  • directorId (unique)          │
│  • name (indexed)               │
│  • birthDate                    │
│  • nationality                  │
│  • biography                    │
│  • awardsCount                  │
├─────────────────────────────────┤
│ Outgoing Relationships:         │
│  → DIRECTED (Movie)             │
│    Properties:                  │
│      - year                     │
└─────────────────────────────────┘
```

### Genre Node
```
┌─────────────────────────────────┐
│           Genre                 │
├─────────────────────────────────┤
│ Properties:                     │
│  • name (unique)                │
│  • description                  │
├─────────────────────────────────┤
│ Incoming Relationships:         │
│  ← HAS_GENRE (Movie/Series)     │
└─────────────────────────────────┘
```

## Relationship Types Detail

### WATCHED
```
User ──[WATCHED]──> Movie/Series

Properties:
  • timestamp (DateTime, indexed)
  • completionPercentage (0-100)
  • device (String)
  • currentEpisode (Integer, optional)

Use Case: Track viewing history and engagement
```

### RATED
```
User ──[RATED]──> Movie/Series

Properties:
  • rating (Integer, 1-10, indexed)
  • timestamp (DateTime)
  • review (String, optional)

Use Case: User preferences and content quality metrics
```

### ACTED_IN
```
Actor ──[ACTED_IN]──> Movie/Series

Properties:
  • character (String, indexed)
  • role (Lead/Supporting/Guest)
  • seasons (Array[Integer], for series)

Use Case: Cast information and actor-based recommendations
```

### DIRECTED
```
Director ──[DIRECTED]──> Movie

Properties:
  • year (Integer)

Use Case: Director filmography and quality indicators
```

### HAS_GENRE
```
Movie/Series ──[HAS_GENRE]──> Genre

Properties: None

Use Case: Content categorization and genre-based filtering
```

### FOLLOWS
```
User ──[FOLLOWS]──> User

Properties:
  • since (Date)

Use Case: Social features and friend recommendations
```

### ADDED_TO_WATCHLIST
```
User ──[ADDED_TO_WATCHLIST]──> Movie/Series

Properties:
  • addedDate (Date)
  • priority (High/Medium/Low)

Use Case: Watchlist management and intent signals
```

## Example Graph Patterns

### Pattern 1: User's Viewing History
```
(User:USR001)
    ├─[WATCHED]──> (Movie:Inception)
    ├─[WATCHED]──> (Movie:La La Land)
    └─[WATCHED]──> (Series:Stranger Things)
```

### Pattern 2: Movie with Full Metadata
```
(Director:Nolan) ─[DIRECTED]─> (Movie:Inception) ─[HAS_GENRE]─> (Genre:Sci-Fi)
                                       ▲                    └─[HAS_GENRE]─> (Genre:Thriller)
                                       │
                        [ACTED_IN]─────┤
                                       │
                                (Actor:Scarlett)
```

### Pattern 3: Collaborative Filtering
```
(User:Alice) ─[WATCHED]─> (Movie:X) <─[WATCHED]─ (User:Bob)
                                                       │
                                                  [WATCHED]
                                                       ▼
                                                  (Movie:Y)
                                             (Recommend to Alice)
```

### Pattern 4: Social Network
```
(User:Alice) ─[FOLLOWS]─> (User:Bob) ─[FOLLOWS]─> (User:Carol)
     ▲                         │
     │                    [WATCHED]
     │                         ▼
     └──────[FOLLOWS]──── (User:David)
```

### Pattern 5: Genre-Based Discovery
```
(User:Alice) ─[RATED:9]─> (Movie:Inception) ─[HAS_GENRE]─> (Genre:Sci-Fi)
                                                                   ▲
                                                            [HAS_GENRE]
                                                                   │
                                                            (Movie:Dune)
                                                      (Recommend to Alice)
```

## Query Patterns Visualized

### Recommendation Query Flow
```
1. Find User
   (User:USR001)
        │
        ▼
2. Find Similar Users
   (User:USR001) ─[WATCHED]─> (Content) <─[WATCHED]─ (SimilarUsers)
        │
        ▼
3. Find Their Content
   (SimilarUsers) ─[WATCHED]─> (Recommendations)
        │
        ▼
4. Filter & Rank
   WHERE NOT (User:USR001)─[WATCHED]─>(Recommendations)
   ORDER BY count(SimilarUsers) DESC
```

### Content Analytics Flow
```
1. Aggregate Views
   (Content) <─[WATCHED]─ (Users)
        │
        ▼
2. Calculate Metrics
   • count(Users) = Unique Viewers
   • count(WATCHED) = Total Views
   • avg(completionPercentage) = Engagement
        │
        ▼
3. Segment & Report
   GROUP BY content.title
   ORDER BY metrics DESC
```

## Graph Traversal Examples

### 2-Hop Pattern: Friend of Friend
```
(User:Alice) ─[FOLLOWS]─> (Friend) ─[FOLLOWS]─> (FriendOfFriend)
```

### 3-Hop Pattern: Actor Co-stars
```
(Actor:A) ─[ACTED_IN]─> (Movie) <─[ACTED_IN]─ (Actor:B)
```

### Variable Length: Content Similarity Chain
```
(Movie:A) ─[HAS_GENRE*1..2]─> (Genre) <─[HAS_GENRE*1..2]─ (Movie:B)
```

### Shortest Path: Actor Connection
```
shortestPath(
  (Actor:Tom Hanks) ─[*]─ (Actor:Emma Stone)
)
Through: Movies, Directors, Co-stars
```

## Performance Optimization

### Indexed Properties
```
User:
  • userId (UNIQUE CONSTRAINT) ──> O(1) lookup
  • email (INDEX) ──────────────> O(log n) search
  • name (INDEX) ───────────────> O(log n) search

Movie:
  • movieId (UNIQUE CONSTRAINT) ─> O(1) lookup
  • title (INDEX) ──────────────> O(log n) search
  • releaseYear (INDEX) ────────> O(log n) range query

WATCHED:
  • timestamp (INDEX) ──────────> O(log n) time-based queries

RATED:
  • rating (INDEX) ─────────────> O(log n) rating-based filters
```

### Query Optimization Tips
```
✓ GOOD: Use indexes
  MATCH (u:User {userId: 'USR001'})  ← Uses unique constraint
  
✗ BAD: Full scan
  MATCH (u:User) WHERE u.userId = 'USR001'  ← May not use index

✓ GOOD: Early filtering
  MATCH (u:User {userId: 'USR001'})-[:WATCHED]->(m)
  
✗ BAD: Late filtering  
  MATCH (u:User)-[:WATCHED]->(m)
  WHERE u.userId = 'USR001'

✓ GOOD: Limit results
  RETURN results LIMIT 10
  
✗ BAD: Unlimited results
  RETURN results  ← May return millions
```

## Legend

```
┌─────┐
│ Node│  = Entity (User, Movie, etc.)
└─────┘

─────>  = Directed Relationship

────── = Property or connection

[TYPE]  = Relationship Type

• item  = Property

▼ ▲ │   = Flow direction

← →     = Bidirectional (conceptual)
```

## Summary

This graph model provides:
- **Rich Relationships**: Connect users, content, and creators
- **Flexible Queries**: Traverse any path through the graph
- **Performance**: Optimized with indexes and constraints
- **Scalability**: Designed for millions of nodes and relationships
- **Insights**: Enable complex analytics and recommendations

For implementation details, see [DATA_MODEL.md](DATA_MODEL.md)
For setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md)
For practical examples, see [USE_CASES.md](USE_CASES.md)
