# StreamingGraph Setup Guide

This guide provides step-by-step instructions for setting up the StreamingGraph database model in Neo4j.

## Table of Contents
1. [Environment Setup](#environment-setup)
2. [Database Creation](#database-creation)
3. [Schema Setup](#schema-setup)
4. [Data Import](#data-import)
5. [Verification](#verification)
6. [Troubleshooting](#troubleshooting)

## Environment Setup

### Option 1: Neo4j Desktop (Recommended for Development)

1. **Download Neo4j Desktop**
   - Visit [neo4j.com/download](https://neo4j.com/download/)
   - Download Neo4j Desktop for your operating system
   - Install following the platform-specific instructions

2. **Launch Neo4j Desktop**
   - Open Neo4j Desktop application
   - Sign in or create a free account

3. **System Requirements**
   - OS: Windows 10+, macOS 10.13+, or Linux
   - RAM: Minimum 4GB, Recommended 8GB+
   - Disk Space: At least 1GB free
   - Java: Automatically bundled with Neo4j Desktop

### Option 2: Neo4j Aura (Cloud-Based)

1. **Create an Aura Account**
   - Visit [neo4j.com/cloud/aura](https://neo4j.com/cloud/aura/)
   - Sign up for a free tier account

2. **Create a Database**
   - Click "Create Database"
   - Select "Free" tier
   - Wait for provisioning (2-5 minutes)
   - Save the connection credentials

### Option 3: Docker

```bash
# Pull Neo4j image
docker pull neo4j:latest

# Run Neo4j container
docker run \
    --name streaming-graph-neo4j \
    -p 7474:7474 -p 7687:7687 \
    -e NEO4J_AUTH=neo4j/password \
    -v $HOME/neo4j/data:/data \
    neo4j:latest
```

## Database Creation

### Using Neo4j Desktop

1. **Create New Project**
   - Click "New" → "Create Project"
   - Name it "StreamingGraph"

2. **Add Database**
   - Click "Add" → "Local DBMS"
   - Name: "StreamingGraph-DB"
   - Password: Choose a secure password
   - Version: Select latest (5.x or 4.4+)
   - Click "Create"

3. **Configure Database**
   - Click the three dots (⋮) on your database
   - Select "Settings"
   - Adjust memory settings if needed:
     ```
     dbms.memory.heap.initial_size=1G
     dbms.memory.heap.max_size=2G
     dbms.memory.pagecache.size=1G
     ```
   - Click "Apply"

4. **Start Database**
   - Click "Start" button
   - Wait for the status to show "Active"

5. **Open Neo4j Browser**
   - Click "Open" → "Neo4j Browser"
   - Browser opens at http://localhost:7474

### Using Neo4j Aura

1. **Access Your Database**
   - From your Aura dashboard, click on your database
   - Click "Query" to open Neo4j Browser

2. **Note Your Connection Details**
   - Connection URI: `neo4j+s://xxxxx.databases.neo4j.io`
   - Username: Usually `neo4j`
   - Password: Set during creation

## Schema Setup

### Step 1: Connect to Database

If using Neo4j Browser locally:
- URL: `bolt://localhost:7687`
- Username: `neo4j`
- Password: Your chosen password

### Step 2: Clear Existing Data (Optional)

⚠️ **Warning**: This will delete ALL data in the database!

```cypher
MATCH (n)
DETACH DELETE n;
```

### Step 3: Execute Schema Script

1. **Open schema.cypher file**
   - Locate `schema.cypher` in your cloned repository
   - Open it with a text editor

2. **Copy and Execute**
   - Copy the entire contents of `schema.cypher`
   - Paste into Neo4j Browser query editor
   - Click the "Run" button (▶) or press Ctrl+Enter

3. **Verify Constraints and Indexes**
   ```cypher
   // List all constraints
   SHOW CONSTRAINTS;
   
   // List all indexes
   SHOW INDEXES;
   ```

Expected output:
- 6 unique constraints (one for each node type)
- Multiple indexes on frequently queried properties

### Step 4: Confirm Schema Creation

Run this query to verify the schema is ready:

```cypher
CALL db.schema.visualization();
```

You should see a visual representation of your schema (though no data yet).

## Data Import

### Step 1: Load Sample Data

1. **Open sample_data.cypher**
   - Locate `sample_data.cypher` in the repository
   - Open with text editor

2. **Import in Sections** (Recommended)

   **Section 1: Genres**
   ```cypher
   // Copy and run just the Genres section
   CREATE (action:Genre {name: 'Action', ...})
   ...
   ```

   **Section 2: Actors**
   ```cypher
   // Copy and run just the Actors section
   CREATE (actor1:Actor {...})
   ...
   ```

   **Section 3: Directors**
   ```cypher
   // Copy and run just the Directors section
   CREATE (director1:Director {...})
   ...
   ```

   **Section 4: Movies**
   ```cypher
   // Copy and run just the Movies section
   CREATE (movie1:Movie {...})
   ...
   ```

   **Section 5: Series**
   ```cypher
   // Copy and run just the Series section
   CREATE (series1:Series {...})
   ...
   ```

   **Section 6: Users**
   ```cypher
   // Copy and run just the Users section
   CREATE (user1:User {...})
   ...
   ```

   **Section 7: Relationships**
   ```cypher
   // Copy and run each relationship section
   MATCH (m:Movie {...}), (d:Director {...})
   CREATE (d)-[:DIRECTED {...}]->(m);
   ...
   ```

3. **Or Import All at Once**
   - Copy the entire `sample_data.cypher` content
   - Paste into Neo4j Browser
   - Execute (may take 10-30 seconds)

### Step 2: Verify Data Import

Count nodes by type:
```cypher
MATCH (n)
RETURN labels(n)[0] AS NodeType, count(n) AS Count
ORDER BY NodeType;
```

Expected counts:
- User: 5
- Movie: 5
- Series: 4
- Actor: 5
- Director: 4
- Genre: 8

Count relationships:
```cypher
MATCH ()-[r]->()
RETURN type(r) AS RelationType, count(r) AS Count
ORDER BY RelationType;
```

## Verification

### Test Basic Queries

1. **List All Movies**
   ```cypher
   MATCH (m:Movie)
   RETURN m.title, m.releaseYear, m.rating
   ORDER BY m.rating DESC;
   ```

2. **Find Users and Their Watched Content**
   ```cypher
   MATCH (u:User)-[:WATCHED]->(content)
   RETURN u.name, content.title, labels(content)[0] AS type
   LIMIT 10;
   ```

3. **Visualize Sample Graph**
   ```cypher
   MATCH (n)
   RETURN n
   LIMIT 100;
   ```
   Click the "Graph" tab to see visual representation

### Run Example Queries

Open `queries.cypher` and try running some example queries:

```cypher
// Query 1: Movies with genres
MATCH (m:Movie)-[:HAS_GENRE]->(g:Genre)
RETURN m.title AS Movie, collect(g.name) AS Genres
ORDER BY m.releaseYear DESC;

// Query 9: Collaborative filtering recommendations
MATCH (targetUser:User {userId: 'USR001'})-[:WATCHED]->(content)<-[:WATCHED]-(similarUser:User)
WITH targetUser, similarUser, count(DISTINCT content) AS commonWatches
WHERE commonWatches > 0
MATCH (similarUser)-[:WATCHED]->(recommendation)
WHERE NOT (targetUser)-[:WATCHED]->(recommendation)
RETURN DISTINCT recommendation.title AS Recommendation
LIMIT 5;
```

### Performance Check

Check query performance with PROFILE:

```cypher
PROFILE
MATCH (u:User {userId: 'USR001'})-[:WATCHED]->(m:Movie)
RETURN m.title;
```

Look for:
- Index usage in the execution plan
- Low db hits relative to rows returned
- No Cartesian products or inefficient operations

## Troubleshooting

### Common Issues

#### 1. "Constraint already exists" Error

**Problem**: Running schema.cypher multiple times

**Solution**: Drop existing constraints first
```cypher
DROP CONSTRAINT user_id_unique IF EXISTS;
// Repeat for each constraint
```

Or use the `IF NOT EXISTS` clause (already in schema.cypher)

#### 2. "Node not found" During Data Import

**Problem**: Trying to create relationships before nodes exist

**Solution**: Import data in correct order:
1. Genres (no dependencies)
2. Actors (no dependencies)
3. Directors (no dependencies)
4. Movies (no dependencies)
5. Series (no dependencies)
6. Users (no dependencies)
7. All relationships (depend on nodes existing)

#### 3. Memory Issues

**Problem**: Database runs out of memory during import

**Solution**: Increase heap size in neo4j.conf
```properties
dbms.memory.heap.max_size=4G
```

Or import data in smaller batches

#### 4. Connection Refused

**Problem**: Cannot connect to database

**Solution**: 
- Verify database is running (green status in Neo4j Desktop)
- Check firewall settings
- Verify correct port (7687 for bolt, 7474 for browser)
- Try reconnecting with correct credentials

#### 5. Slow Query Performance

**Problem**: Queries taking too long

**Solution**:
- Verify indexes are created: `SHOW INDEXES;`
- Use EXPLAIN/PROFILE to analyze queries
- Add missing indexes on frequently queried properties
- Consider adding more memory

### Getting Help

- **Neo4j Community Forum**: [community.neo4j.com](https://community.neo4j.com)
- **Neo4j Documentation**: [neo4j.com/docs](https://neo4j.com/docs)
- **Stack Overflow**: Tag your question with `neo4j` and `cypher`
- **Neo4j Discord**: Active community support

## Next Steps

After successful setup:

1. **Explore Sample Data**: Run queries from `queries.cypher`
2. **Read Documentation**: Review `DATA_MODEL.md` for details
3. **Customize Data**: Modify sample data for your use case
4. **Build Applications**: Connect your application using Neo4j drivers
5. **Add More Data**: Scale up with your own dataset

## Advanced Configuration

### Production Deployment

For production use, consider:

1. **Security**
   ```properties
   # Enable authentication
   dbms.security.auth_enabled=true
   
   # Use strong passwords
   # Implement role-based access control
   ```

2. **Performance**
   ```properties
   # Optimize for workload
   dbms.memory.heap.max_size=8G
   dbms.memory.pagecache.size=4G
   
   # Transaction timeout
   dbms.transaction.timeout=30s
   ```

3. **Backup**
   ```bash
   # Regular backups
   neo4j-admin backup --backup-dir=/backups/streaming-graph
   ```

4. **Monitoring**
   - Enable metrics collection
   - Set up alerts for memory usage
   - Monitor query performance
   - Track connection pools

### Scaling Considerations

For large datasets:

1. **Use Batch Imports**: Neo4j Admin Import tool
2. **Enable Clustering**: Neo4j Enterprise edition
3. **Read Replicas**: For analytics workloads
4. **Query Optimization**: Regular query profiling
5. **Data Archiving**: Move old data to separate instance

## Appendix

### Neo4j Browser Shortcuts

- **Run Query**: Ctrl+Enter (Cmd+Enter on Mac)
- **Clear Editor**: Ctrl+Shift+K
- **Toggle Fullscreen**: Esc
- **Previous Query**: Ctrl+↑
- **Next Query**: Ctrl+↓

### Useful Commands

```cypher
// Database info
CALL dbms.components();

// Show all labels
CALL db.labels();

// Show all relationship types
CALL db.relationshipTypes();

// Show all property keys
CALL db.propertyKeys();

// Database statistics
CALL apoc.meta.stats();
```

### Resources

- Sample datasets: [neo4j.com/developer/example-data](https://neo4j.com/developer/example-data/)
- Graph modeling tools: [arrows.app](https://arrows.app)
- Neo4j drivers: Available for Python, Java, JavaScript, .NET, Go
