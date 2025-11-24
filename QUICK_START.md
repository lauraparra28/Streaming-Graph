# StreamingGraph Quick Start Guide

Get up and running with StreamingGraph in 5 minutes!

## Prerequisites

- Neo4j Desktop or Neo4j Aura account
- 10 minutes of time

## Step-by-Step Setup

### 1. Install Neo4j (2 minutes)

**Option A: Neo4j Desktop (Local)**
- Download from [neo4j.com/download](https://neo4j.com/download/)
- Install and launch
- Create new project called "StreamingGraph"
- Add local DBMS (version 4.4+ or 5.x)
- Set password and start the database

**Option B: Neo4j Aura (Cloud)**
- Sign up at [neo4j.com/cloud/aura](https://neo4j.com/cloud/aura/)
- Create free database
- Save connection credentials

### 2. Open Neo4j Browser (30 seconds)

- Click "Open" on your database
- Neo4j Browser opens in your web browser
- Default URL: `http://localhost:7474`

### 3. Create Schema (1 minute)

Copy and paste the entire content of `schema.cypher` into Neo4j Browser, then click Run (▶) or press Ctrl+Enter.

**Verify:**
```cypher
SHOW CONSTRAINTS;
```
You should see 6 constraints.

### 4. Load Sample Data (2 minutes)

Copy and paste the entire content of `sample_data.cypher` into Neo4j Browser and execute.

**Verify:**
```cypher
MATCH (n) RETURN labels(n)[0] AS Type, count(n) AS Count;
```
Expected: 31 total nodes (5 users, 5 movies, 4 series, 5 actors, 4 directors, 8 genres)

### 5. Run Your First Query (1 minute)

Try these queries:

**See all movies:**
```cypher
MATCH (m:Movie)
RETURN m.title, m.rating, m.releaseYear
ORDER BY m.rating DESC;
```

**Visualize the graph:**
```cypher
MATCH (n)
RETURN n
LIMIT 50;
```
Click "Graph" view to see the visual representation.

**Get recommendations for a user:**
```cypher
MATCH (u:User {userId: 'USR001'})-[:WATCHED]->(c)<-[:WATCHED]-(similar:User)
WITH similar, count(c) AS common
MATCH (similar)-[:WATCHED]->(rec)
WHERE NOT (u)-[:WATCHED]->(rec)
RETURN rec.title AS Recommendation, count(*) AS Score
ORDER BY Score DESC
LIMIT 5;
```

## Quick Tips

### Navigate Neo4j Browser
- **Run query**: Ctrl+Enter (Cmd+Enter on Mac)
- **Clear editor**: Type new query
- **Previous query**: Click on previous results
- **Switch views**: Graph / Table / Text buttons

### Essential Cypher Patterns

**Find nodes:**
```cypher
MATCH (n:NodeType)
WHERE n.property = 'value'
RETURN n;
```

**Follow relationships:**
```cypher
MATCH (a:User)-[r:WATCHED]->(b:Movie)
RETURN a.name, b.title;
```

**Count things:**
```cypher
MATCH (n:Movie)
RETURN count(n);
```

**Filter results:**
```cypher
MATCH (m:Movie)
WHERE m.rating >= 8.0
RETURN m.title
ORDER BY m.rating DESC
LIMIT 10;
```

## What's Next?

### Learn More
1. Explore [queries.cypher](queries.cypher) - 30+ example queries
2. Read [USE_CASES.md](USE_CASES.md) - Real-world applications
3. Review [DATA_MODEL.md](DATA_MODEL.md) - Complete data model details

### Customize
1. Add your own data to `sample_data.cypher`
2. Modify node properties in `schema.cypher`
3. Create custom queries for your needs

### Build Applications
Connect from your favorite language:
- **Python**: `neo4j` driver
- **JavaScript**: `neo4j-driver` package
- **Java**: Neo4j Java Driver
- **.NET**: Neo4j.Driver package

Example Python connection:
```python
from neo4j import GraphDatabase

driver = GraphDatabase.driver(
    "bolt://localhost:7687",
    auth=("neo4j", "your-password")
)

with driver.session() as session:
    result = session.run(
        "MATCH (m:Movie) RETURN m.title LIMIT 5"
    )
    for record in result:
        print(record["m.title"])

driver.close()
```

## Troubleshooting

**Problem: Can't connect to database**
- Verify database is running (green status)
- Check correct port (7687 for bolt, 7474 for browser)
- Verify credentials

**Problem: Query too slow**
- Check indexes are created: `SHOW INDEXES;`
- Use PROFILE to analyze: `PROFILE MATCH ...`
- Add more memory in settings

**Problem: "Constraint already exists"**
- Schema already loaded - skip to data import
- Or drop constraints first: `DROP CONSTRAINT constraint_name;`

**Problem: "Node not found" during import**
- Load nodes before relationships
- Run sample_data.cypher in sections

## Common Commands

```cypher
// Delete all data (⚠️ USE WITH CAUTION)
MATCH (n) DETACH DELETE n;

// Count all nodes
MATCH (n) RETURN count(n);

// Count all relationships
MATCH ()-[r]->() RETURN count(r);

// Show database info
CALL dbms.components();

// List all labels (node types)
CALL db.labels();

// List all relationship types
CALL db.relationshipTypes();

// Show schema
CALL db.schema.visualization();
```

## Resources

- **Neo4j Documentation**: [neo4j.com/docs](https://neo4j.com/docs/)
- **Cypher Cheat Sheet**: [neo4j.com/docs/cypher-cheat-sheet](https://neo4j.com/docs/cypher-cheat-sheet/)
- **Community Forum**: [community.neo4j.com](https://community.neo4j.com)
- **Graph Academy**: [graphacademy.neo4j.com](https://graphacademy.neo4j.com/) (Free courses)

## Need Help?

1. Check [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed instructions
2. Review [DATA_MODEL.md](DATA_MODEL.md) for model details
3. Post questions with `neo4j` tag on Stack Overflow
4. Visit Neo4j Community Forum

---

**You're all set! 🎉 Start exploring the graph and building amazing applications.**
