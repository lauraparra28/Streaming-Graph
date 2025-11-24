# 🎬 StreamingGraph: Data Model for a Streaming Platform

A comprehensive graph data model for a streaming platform, representing core domain entities such as Users, Movies, Series, Actors, Directors, and Genres using Neo4j.

## 📋 Overview

This repository contains a complete graph database model designed for modern streaming platforms. The model enables:

- 🎯 **Rich Querying**: Complex queries across entities and relationships
- 📊 **Advanced Analytics**: User engagement, content performance, and trends
- 🤖 **Recommendation Systems**: Collaborative filtering and content-based recommendations
- 👥 **Social Features**: User connections and social recommendations
- 📈 **Business Intelligence**: Revenue analysis, user retention, and content ROI

## 🗂️ Repository Structure

```
Streaming-Graph/
├── README.md              # This file - project overview and setup
├── DATA_MODEL.md          # Detailed data model documentation
├── schema.cypher          # Database schema and constraints
├── sample_data.cypher     # Sample data for testing
└── queries.cypher         # 30+ example queries for common use cases
```

## 🎯 Core Entities

### Nodes
- **User**: Platform subscribers with viewing history and preferences
- **Movie**: Individual films with metadata and ratings
- **Series**: Multi-episode content with season/episode information
- **Actor**: Performers in movies and series
- **Director**: Content creators and filmmakers
- **Genre**: Content categories (Action, Drama, Sci-Fi, etc.)

### Relationships
- **WATCHED**: Users viewing content (with completion tracking)
- **RATED**: User ratings and reviews
- **ACTED_IN**: Actor performances with character information
- **DIRECTED**: Director-movie associations
- **HAS_GENRE**: Content categorization
- **FOLLOWS**: User social network
- **ADDED_TO_WATCHLIST**: User watchlist management

## 🚀 Getting Started

### Prerequisites

- [Neo4j Desktop](https://neo4j.com/download/) or Neo4j Database (version 4.0+)
- Basic understanding of graph databases and Cypher query language

### Installation Steps

1. **Install Neo4j**
   - Download and install [Neo4j Desktop](https://neo4j.com/download/)
   - Or use [Neo4j Aura](https://neo4j.com/cloud/aura/) for cloud deployment

2. **Create a New Database**
   - Open Neo4j Desktop
   - Create a new project and database
   - Start the database

3. **Clone This Repository**
   ```bash
   git clone https://github.com/lauraparra28/Streaming-Graph.git
   cd Streaming-Graph
   ```

4. **Set Up the Schema**
   - Open Neo4j Browser (usually at http://localhost:7474)
   - Copy and execute the contents of `schema.cypher`
   - This creates all necessary constraints and indexes

5. **Load Sample Data**
   - In Neo4j Browser, copy and execute `sample_data.cypher`
   - This populates the database with sample users, movies, series, and relationships

6. **Run Example Queries**
   - Try queries from `queries.cypher` to explore the data
   - Modify queries to match your specific needs

## 📖 Usage Examples

### Basic Query: Find All Movies in a Genre
```cypher
MATCH (m:Movie)-[:HAS_GENRE]->(g:Genre {name: 'Sci-Fi'})
RETURN m.title, m.releaseYear, m.rating
ORDER BY m.rating DESC;
```

### Recommendation: Movies Based on Similar Users
```cypher
MATCH (u:User {userId: 'USR001'})-[:WATCHED]->(c)<-[:WATCHED]-(similar:User)
WITH similar, count(DISTINCT c) AS commonWatches
MATCH (similar)-[:WATCHED]->(recommendation:Movie)
WHERE NOT (u)-[:WATCHED]->(recommendation)
RETURN recommendation.title, count(*) AS recommendedBy
ORDER BY recommendedBy DESC LIMIT 5;
```

### Analytics: User Engagement by Subscription Type
```cypher
MATCH (u:User)-[w:WATCHED]->(content)
RETURN u.subscriptionType AS subscription,
       count(DISTINCT u) AS users,
       count(w) AS totalViews,
       avg(w.completionPercentage) AS avgCompletion
ORDER BY users DESC;
```

## 📊 Use Cases

### 1. Personalized Recommendations
- Collaborative filtering based on similar users
- Content-based filtering using genres and actors
- Social recommendations from friends
- Trending content discovery

### 2. Content Analytics
- Most popular movies and series
- Genre performance analysis
- Completion rate tracking
- Viewing pattern analysis

### 3. User Analytics
- Engagement metrics by subscription tier
- User retention analysis
- Demographic insights
- Viewing habits and preferences

### 4. Business Intelligence
- Revenue and ROI analysis for movies
- Content acquisition strategy
- Subscription conversion optimization
- Device usage patterns

### 5. Social Features
- User following and follower networks
- Friend activity feeds
- Social proof for content
- Community recommendations

## 📚 Documentation

- **[DATA_MODEL.md](DATA_MODEL.md)**: Comprehensive data model documentation
  - Node types and properties
  - Relationship types and patterns
  - Query patterns and examples
  - Best practices and optimization tips

- **[schema.cypher](schema.cypher)**: Database schema definition
  - Unique constraints
  - Property indexes
  - Relationship indexes

- **[sample_data.cypher](sample_data.cypher)**: Sample dataset
  - 5 users
  - 5 movies and 4 series
  - 5 actors and 4 directors
  - 8 genres
  - Multiple relationships demonstrating real-world scenarios

- **[queries.cypher](queries.cypher)**: 30+ example queries
  - Basic data exploration
  - User analytics
  - Recommendation algorithms
  - Advanced analytics
  - Business intelligence

## 🔧 Configuration

### Recommended Neo4j Settings

For optimal performance with this data model:

```properties
# Memory Configuration
dbms.memory.heap.initial_size=2G
dbms.memory.heap.max_size=4G
dbms.memory.pagecache.size=2G

# Query Configuration
dbms.transaction.timeout=30s
```

## 🎓 Learning Resources

### Neo4j Resources
- [Neo4j Graph Academy](https://graphacademy.neo4j.com/) - Free courses
- [Cypher Query Language](https://neo4j.com/docs/cypher-manual/current/)
- [Neo4j Documentation](https://neo4j.com/docs/)

### Graph Database Concepts
- [Introduction to Graph Databases](https://neo4j.com/developer/graph-database/)
- [Graph Data Modeling](https://neo4j.com/developer/guide-data-modeling/)
- [Cypher Tutorial](https://neo4j.com/developer/cypher/)

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Add more sample data
- Create additional query examples
- Improve documentation
- Suggest model enhancements
- Report issues

## 📝 License

This project is available for educational and personal use.

## 👥 Authors

Created for demonstrating graph database capabilities in streaming platform scenarios.

## 🙏 Acknowledgments

- Neo4j for the excellent graph database platform
- Inspiration from real-world streaming services like Netflix, Disney+, and HBO Max
