// StreamingGraph - Graph Data Model Schema
// Neo4j Cypher Script for Schema Creation

// ============================================
// NODE CONSTRAINTS AND INDEXES
// ============================================

// User Node Constraints
CREATE CONSTRAINT user_id_unique IF NOT EXISTS
FOR (u:User) REQUIRE u.userId IS UNIQUE;

CREATE INDEX user_email_index IF NOT EXISTS
FOR (u:User) ON (u.email);

CREATE INDEX user_name_index IF NOT EXISTS
FOR (u:User) ON (u.name);

// Movie Node Constraints
CREATE CONSTRAINT movie_id_unique IF NOT EXISTS
FOR (m:Movie) REQUIRE m.movieId IS UNIQUE;

CREATE INDEX movie_title_index IF NOT EXISTS
FOR (m:Movie) ON (m.title);

CREATE INDEX movie_release_year_index IF NOT EXISTS
FOR (m:Movie) ON (m.releaseYear);

// Series Node Constraints
CREATE CONSTRAINT series_id_unique IF NOT EXISTS
FOR (s:Series) REQUIRE s.seriesId IS UNIQUE;

CREATE INDEX series_title_index IF NOT EXISTS
FOR (s:Series) ON (s.title);

CREATE INDEX series_release_year_index IF NOT EXISTS
FOR (s:Series) ON (s.releaseYear);

// Actor Node Constraints
CREATE CONSTRAINT actor_id_unique IF NOT EXISTS
FOR (a:Actor) REQUIRE a.actorId IS UNIQUE;

CREATE INDEX actor_name_index IF NOT EXISTS
FOR (a:Actor) ON (a.name);

// Director Node Constraints
CREATE CONSTRAINT director_id_unique IF NOT EXISTS
FOR (d:Director) REQUIRE d.directorId IS UNIQUE;

CREATE INDEX director_name_index IF NOT EXISTS
FOR (d:Director) ON (d.name);

// Genre Node Constraints
CREATE CONSTRAINT genre_name_unique IF NOT EXISTS
FOR (g:Genre) REQUIRE g.name IS UNIQUE;

// ============================================
// RELATIONSHIP INDEXES
// ============================================

// Index for WATCHED relationships by timestamp
CREATE INDEX watched_timestamp_index IF NOT EXISTS
FOR ()-[r:WATCHED]-() ON (r.timestamp);

// Index for RATED relationships by rating value
CREATE INDEX rated_rating_index IF NOT EXISTS
FOR ()-[r:RATED]-() ON (r.rating);

// Index for ACTED_IN relationships by character
CREATE INDEX acted_in_character_index IF NOT EXISTS
FOR ()-[r:ACTED_IN]-() ON (r.character);
