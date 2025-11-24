// StreamingGraph - Sample Data
// Neo4j Cypher Script for Loading Sample Data

// ============================================
// CLEAR EXISTING DATA (USE WITH CAUTION)
// ============================================
// MATCH (n) DETACH DELETE n;

// ============================================
// CREATE GENRES
// ============================================
CREATE (action:Genre {name: 'Action', description: 'High-energy films with physical stunts'})
CREATE (drama:Genre {name: 'Drama', description: 'Serious, plot-driven presentations'})
CREATE (comedy:Genre {name: 'Comedy', description: 'Light-hearted and humorous content'})
CREATE (scifi:Genre {name: 'Sci-Fi', description: 'Science fiction and futuristic themes'})
CREATE (thriller:Genre {name: 'Thriller', description: 'Suspenseful and exciting stories'})
CREATE (romance:Genre {name: 'Romance', description: 'Love and romantic relationships'})
CREATE (horror:Genre {name: 'Horror', description: 'Scary and frightening content'})
CREATE (documentary:Genre {name: 'Documentary', description: 'Non-fiction informative content'});

// ============================================
// CREATE ACTORS
// ============================================
CREATE (actor1:Actor {
    actorId: 'ACT001',
    name: 'Emma Stone',
    birthDate: date('1988-11-06'),
    nationality: 'American',
    biography: 'Academy Award-winning actress known for her versatile roles'
})
CREATE (actor2:Actor {
    actorId: 'ACT002',
    name: 'Ryan Gosling',
    birthDate: date('1980-11-12'),
    nationality: 'Canadian',
    biography: 'Actor and musician known for dramatic and romantic roles'
})
CREATE (actor3:Actor {
    actorId: 'ACT003',
    name: 'Scarlett Johansson',
    birthDate: date('1984-11-22'),
    nationality: 'American',
    biography: 'Acclaimed actress known for action and dramatic roles'
})
CREATE (actor4:Actor {
    actorId: 'ACT004',
    name: 'Morgan Freeman',
    birthDate: date('1937-06-01'),
    nationality: 'American',
    biography: 'Legendary actor with distinctive voice and powerful presence'
})
CREATE (actor5:Actor {
    actorId: 'ACT005',
    name: 'Tom Hanks',
    birthDate: date('1956-07-09'),
    nationality: 'American',
    biography: 'Two-time Academy Award winner known for iconic roles'
});

// ============================================
// CREATE DIRECTORS
// ============================================
CREATE (director1:Director {
    directorId: 'DIR001',
    name: 'Christopher Nolan',
    birthDate: date('1970-07-30'),
    nationality: 'British-American',
    biography: 'Known for mind-bending narratives and visual storytelling',
    awardsCount: 5
})
CREATE (director2:Director {
    directorId: 'DIR002',
    name: 'Greta Gerwig',
    birthDate: date('1983-08-04'),
    nationality: 'American',
    biography: 'Acclaimed writer-director known for character-driven stories',
    awardsCount: 3
})
CREATE (director3:Director {
    directorId: 'DIR003',
    name: 'Steven Spielberg',
    birthDate: date('1946-12-18'),
    nationality: 'American',
    biography: 'One of the most influential filmmakers in cinematic history',
    awardsCount: 15
})
CREATE (director4:Director {
    directorId: 'DIR004',
    name: 'Denis Villeneuve',
    birthDate: date('1967-10-03'),
    nationality: 'Canadian',
    biography: 'Visionary director known for epic sci-fi and thriller films',
    awardsCount: 4
});

// ============================================
// CREATE MOVIES
// ============================================
CREATE (movie1:Movie {
    movieId: 'MOV001',
    title: 'Inception',
    releaseYear: 2010,
    duration: 148,
    language: 'English',
    plot: 'A thief who steals corporate secrets through dream-sharing technology',
    rating: 8.8,
    budget: 160000000,
    revenue: 829895144
})
CREATE (movie2:Movie {
    movieId: 'MOV002',
    title: 'La La Land',
    releaseYear: 2016,
    duration: 128,
    language: 'English',
    plot: 'A jazz pianist and an aspiring actress fall in love in Los Angeles',
    rating: 8.0,
    budget: 30000000,
    revenue: 446092357
})
CREATE (movie3:Movie {
    movieId: 'MOV003',
    title: 'The Shawshank Redemption',
    releaseYear: 1994,
    duration: 142,
    language: 'English',
    plot: 'Two imprisoned men bond over years, finding redemption through compassion',
    rating: 9.3,
    budget: 25000000,
    revenue: 28341469
})
CREATE (movie4:Movie {
    movieId: 'MOV004',
    title: 'Dune',
    releaseYear: 2021,
    duration: 155,
    language: 'English',
    plot: 'A noble family becomes embroiled in a war for a desert planet',
    rating: 8.0,
    budget: 165000000,
    revenue: 401771771
})
CREATE (movie5:Movie {
    movieId: 'MOV005',
    title: 'Forrest Gump',
    releaseYear: 1994,
    duration: 142,
    language: 'English',
    plot: 'The story of a simple man who witnesses and influences major events',
    rating: 8.8,
    budget: 55000000,
    revenue: 678151134
});

// ============================================
// CREATE SERIES
// ============================================
CREATE (series1:Series {
    seriesId: 'SER001',
    title: 'Stranger Things',
    releaseYear: 2016,
    seasons: 4,
    episodes: 42,
    language: 'English',
    plot: 'A group of kids uncover supernatural mysteries in their small town',
    rating: 8.7,
    status: 'Ongoing'
})
CREATE (series2:Series {
    seriesId: 'SER002',
    title: 'The Crown',
    releaseYear: 2016,
    seasons: 6,
    episodes: 60,
    language: 'English',
    plot: 'Chronicles the life of Queen Elizabeth II',
    rating: 8.6,
    status: 'Completed'
})
CREATE (series3:Series {
    seriesId: 'SER003',
    title: 'Breaking Bad',
    releaseYear: 2008,
    seasons: 5,
    episodes: 62,
    language: 'English',
    plot: 'A chemistry teacher turns to manufacturing methamphetamine',
    rating: 9.5,
    status: 'Completed'
})
CREATE (series4:Series {
    seriesId: 'SER004',
    title: 'Black Mirror',
    releaseYear: 2011,
    seasons: 6,
    episodes: 27,
    language: 'English',
    plot: 'Anthology series exploring dark aspects of technology and society',
    rating: 8.7,
    status: 'Ongoing'
});

// ============================================
// CREATE USERS
// ============================================
CREATE (user1:User {
    userId: 'USR001',
    name: 'Alice Johnson',
    email: 'alice.johnson@email.com',
    joinDate: date('2020-05-15'),
    country: 'United States',
    subscriptionType: 'Premium',
    age: 28
})
CREATE (user2:User {
    userId: 'USR002',
    name: 'Bob Smith',
    email: 'bob.smith@email.com',
    joinDate: date('2019-03-20'),
    country: 'Canada',
    subscriptionType: 'Standard',
    age: 35
})
CREATE (user3:User {
    userId: 'USR003',
    name: 'Carol Martinez',
    email: 'carol.martinez@email.com',
    joinDate: date('2021-08-10'),
    country: 'Mexico',
    subscriptionType: 'Premium',
    age: 42
})
CREATE (user4:User {
    userId: 'USR004',
    name: 'David Lee',
    email: 'david.lee@email.com',
    joinDate: date('2020-11-25'),
    country: 'United Kingdom',
    subscriptionType: 'Basic',
    age: 31
})
CREATE (user5:User {
    userId: 'USR005',
    name: 'Eva Chen',
    email: 'eva.chen@email.com',
    joinDate: date('2022-01-05'),
    country: 'Australia',
    subscriptionType: 'Premium',
    age: 25
});

// ============================================
// CREATE RELATIONSHIPS: MOVIES - DIRECTORS
// ============================================
MATCH (m:Movie {movieId: 'MOV001'}), (d:Director {directorId: 'DIR001'})
CREATE (d)-[:DIRECTED {year: 2010}]->(m);

MATCH (m:Movie {movieId: 'MOV004'}), (d:Director {directorId: 'DIR004'})
CREATE (d)-[:DIRECTED {year: 2021}]->(m);

MATCH (m:Movie {movieId: 'MOV005'}), (d:Director {directorId: 'DIR003'})
CREATE (d)-[:DIRECTED {year: 1994}]->(m);

// ============================================
// CREATE RELATIONSHIPS: MOVIES - ACTORS
// ============================================
MATCH (a:Actor {actorId: 'ACT001'}), (m:Movie {movieId: 'MOV002'})
CREATE (a)-[:ACTED_IN {character: 'Mia Dolan', role: 'Lead'}]->(m);

MATCH (a:Actor {actorId: 'ACT002'}), (m:Movie {movieId: 'MOV002'})
CREATE (a)-[:ACTED_IN {character: 'Sebastian Wilder', role: 'Lead'}]->(m);

MATCH (a:Actor {actorId: 'ACT003'}), (m:Movie {movieId: 'MOV001'})
CREATE (a)-[:ACTED_IN {character: 'Ariadne', role: 'Supporting'}]->(m);

MATCH (a:Actor {actorId: 'ACT004'}), (m:Movie {movieId: 'MOV003'})
CREATE (a)-[:ACTED_IN {character: 'Red', role: 'Lead'}]->(m);

MATCH (a:Actor {actorId: 'ACT005'}), (m:Movie {movieId: 'MOV005'})
CREATE (a)-[:ACTED_IN {character: 'Forrest Gump', role: 'Lead'}]->(m);

// ============================================
// CREATE RELATIONSHIPS: SERIES - ACTORS
// ============================================
MATCH (a:Actor {actorId: 'ACT003'}), (s:Series {seriesId: 'SER004'})
CREATE (a)-[:ACTED_IN {character: 'Multiple Roles', role: 'Guest', seasons: [5]}]->(s);

// ============================================
// CREATE RELATIONSHIPS: MOVIES - GENRES
// ============================================
MATCH (m:Movie {movieId: 'MOV001'}), (g:Genre {name: 'Sci-Fi'})
CREATE (m)-[:HAS_GENRE]->(g);

MATCH (m:Movie {movieId: 'MOV001'}), (g:Genre {name: 'Thriller'})
CREATE (m)-[:HAS_GENRE]->(g);

MATCH (m:Movie {movieId: 'MOV001'}), (g:Genre {name: 'Action'})
CREATE (m)-[:HAS_GENRE]->(g);

MATCH (m:Movie {movieId: 'MOV002'}), (g:Genre {name: 'Romance'})
CREATE (m)-[:HAS_GENRE]->(g);

MATCH (m:Movie {movieId: 'MOV002'}), (g:Genre {name: 'Drama'})
CREATE (m)-[:HAS_GENRE]->(g);

MATCH (m:Movie {movieId: 'MOV003'}), (g:Genre {name: 'Drama'})
CREATE (m)-[:HAS_GENRE]->(g);

MATCH (m:Movie {movieId: 'MOV004'}), (g:Genre {name: 'Sci-Fi'})
CREATE (m)-[:HAS_GENRE]->(g);

MATCH (m:Movie {movieId: 'MOV004'}), (g:Genre {name: 'Action'})
CREATE (m)-[:HAS_GENRE]->(g);

MATCH (m:Movie {movieId: 'MOV005'}), (g:Genre {name: 'Drama'})
CREATE (m)-[:HAS_GENRE]->(g);

MATCH (m:Movie {movieId: 'MOV005'}), (g:Genre {name: 'Romance'})
CREATE (m)-[:HAS_GENRE]->(g);

// ============================================
// CREATE RELATIONSHIPS: SERIES - GENRES
// ============================================
MATCH (s:Series {seriesId: 'SER001'}), (g:Genre {name: 'Sci-Fi'})
CREATE (s)-[:HAS_GENRE]->(g);

MATCH (s:Series {seriesId: 'SER001'}), (g:Genre {name: 'Horror'})
CREATE (s)-[:HAS_GENRE]->(g);

MATCH (s:Series {seriesId: 'SER002'}), (g:Genre {name: 'Drama'})
CREATE (s)-[:HAS_GENRE]->(g);

MATCH (s:Series {seriesId: 'SER002'}), (g:Genre {name: 'Documentary'})
CREATE (s)-[:HAS_GENRE]->(g);

MATCH (s:Series {seriesId: 'SER003'}), (g:Genre {name: 'Drama'})
CREATE (s)-[:HAS_GENRE]->(g);

MATCH (s:Series {seriesId: 'SER003'}), (g:Genre {name: 'Thriller'})
CREATE (s)-[:HAS_GENRE]->(g);

MATCH (s:Series {seriesId: 'SER004'}), (g:Genre {name: 'Sci-Fi'})
CREATE (s)-[:HAS_GENRE]->(g);

MATCH (s:Series {seriesId: 'SER004'}), (g:Genre {name: 'Thriller'})
CREATE (s)-[:HAS_GENRE]->(g);

// ============================================
// CREATE RELATIONSHIPS: USERS - WATCHED
// ============================================
MATCH (u:User {userId: 'USR001'}), (m:Movie {movieId: 'MOV001'})
CREATE (u)-[:WATCHED {
    timestamp: datetime('2023-06-15T20:30:00'),
    completionPercentage: 100,
    device: 'Smart TV'
}]->(m);

MATCH (u:User {userId: 'USR001'}), (m:Movie {movieId: 'MOV002'})
CREATE (u)-[:WATCHED {
    timestamp: datetime('2023-07-20T19:15:00'),
    completionPercentage: 100,
    device: 'Laptop'
}]->(m);

MATCH (u:User {userId: 'USR001'}), (s:Series {seriesId: 'SER001'})
CREATE (u)-[:WATCHED {
    timestamp: datetime('2023-08-10T21:00:00'),
    completionPercentage: 75,
    device: 'Mobile',
    currentEpisode: 30
}]->(s);

MATCH (u:User {userId: 'USR002'}), (m:Movie {movieId: 'MOV003'})
CREATE (u)-[:WATCHED {
    timestamp: datetime('2023-05-10T18:45:00'),
    completionPercentage: 100,
    device: 'Tablet'
}]->(m);

MATCH (u:User {userId: 'USR002'}), (s:Series {seriesId: 'SER003'})
CREATE (u)-[:WATCHED {
    timestamp: datetime('2023-09-05T22:30:00'),
    completionPercentage: 100,
    device: 'Smart TV',
    currentEpisode: 62
}]->(s);

MATCH (u:User {userId: 'USR003'}), (m:Movie {movieId: 'MOV004'})
CREATE (u)-[:WATCHED {
    timestamp: datetime('2023-10-01T20:00:00'),
    completionPercentage: 100,
    device: 'Smart TV'
}]->(m);

MATCH (u:User {userId: 'USR004'}), (m:Movie {movieId: 'MOV005'})
CREATE (u)-[:WATCHED {
    timestamp: datetime('2023-04-20T19:30:00'),
    completionPercentage: 85,
    device: 'Laptop'
}]->(m);

MATCH (u:User {userId: 'USR005'}), (s:Series {seriesId: 'SER004'})
CREATE (u)-[:WATCHED {
    timestamp: datetime('2023-11-15T21:45:00'),
    completionPercentage: 50,
    device: 'Mobile',
    currentEpisode: 13
}]->(s);

// ============================================
// CREATE RELATIONSHIPS: USERS - RATED
// ============================================
MATCH (u:User {userId: 'USR001'}), (m:Movie {movieId: 'MOV001'})
CREATE (u)-[:RATED {
    rating: 9,
    timestamp: datetime('2023-06-15T22:00:00'),
    review: 'Mind-bending masterpiece!'
}]->(m);

MATCH (u:User {userId: 'USR001'}), (m:Movie {movieId: 'MOV002'})
CREATE (u)-[:RATED {
    rating: 8,
    timestamp: datetime('2023-07-20T21:00:00'),
    review: 'Beautiful cinematography and music'
}]->(m);

MATCH (u:User {userId: 'USR002'}), (m:Movie {movieId: 'MOV003'})
CREATE (u)-[:RATED {
    rating: 10,
    timestamp: datetime('2023-05-10T20:30:00'),
    review: 'An absolute classic. Perfect in every way.'
}]->(m);

MATCH (u:User {userId: 'USR002'}), (s:Series {seriesId: 'SER003'})
CREATE (u)-[:RATED {
    rating: 10,
    timestamp: datetime('2023-09-05T23:00:00'),
    review: 'Best series I have ever watched!'
}]->(s);

MATCH (u:User {userId: 'USR003'}), (m:Movie {movieId: 'MOV004'})
CREATE (u)-[:RATED {
    rating: 8,
    timestamp: datetime('2023-10-01T22:30:00'),
    review: 'Stunning visuals and great world-building'
}]->(m);

MATCH (u:User {userId: 'USR005'}), (s:Series {seriesId: 'SER004'})
CREATE (u)-[:RATED {
    rating: 9,
    timestamp: datetime('2023-11-15T22:30:00'),
    review: 'Thought-provoking and dark'
}]->(s);

// ============================================
// CREATE RELATIONSHIPS: USERS - FOLLOWS
// ============================================
MATCH (u1:User {userId: 'USR001'}), (u2:User {userId: 'USR002'})
CREATE (u1)-[:FOLLOWS {since: date('2021-03-15')}]->(u2);

MATCH (u1:User {userId: 'USR001'}), (u3:User {userId: 'USR003'})
CREATE (u1)-[:FOLLOWS {since: date('2021-09-20')}]->(u3);

MATCH (u2:User {userId: 'USR002'}), (u1:User {userId: 'USR001'})
CREATE (u2)-[:FOLLOWS {since: date('2021-04-10')}]->(u1);

MATCH (u3:User {userId: 'USR003'}), (u4:User {userId: 'USR004'})
CREATE (u3)-[:FOLLOWS {since: date('2022-01-05')}]->(u4);

MATCH (u4:User {userId: 'USR004'}), (u5:User {userId: 'USR005'})
CREATE (u4)-[:FOLLOWS {since: date('2022-06-12')}]->(u5);

MATCH (u5:User {userId: 'USR005'}), (u1:User {userId: 'USR001'})
CREATE (u5)-[:FOLLOWS {since: date('2022-08-18')}]->(u1);

// ============================================
// CREATE RELATIONSHIPS: USERS - ADDED_TO_WATCHLIST
// ============================================
MATCH (u:User {userId: 'USR001'}), (m:Movie {movieId: 'MOV004'})
CREATE (u)-[:ADDED_TO_WATCHLIST {
    addedDate: date('2023-09-25'),
    priority: 'High'
}]->(m);

MATCH (u:User {userId: 'USR002'}), (s:Series {seriesId: 'SER001'})
CREATE (u)-[:ADDED_TO_WATCHLIST {
    addedDate: date('2023-08-15'),
    priority: 'Medium'
}]->(s);

MATCH (u:User {userId: 'USR003'}), (m:Movie {movieId: 'MOV001'})
CREATE (u)-[:ADDED_TO_WATCHLIST {
    addedDate: date('2023-10-05'),
    priority: 'High'
}]->(m);

MATCH (u:User {userId: 'USR004'}), (s:Series {seriesId: 'SER002'})
CREATE (u)-[:ADDED_TO_WATCHLIST {
    addedDate: date('2023-07-30'),
    priority: 'Low'
}]->(s);

MATCH (u:User {userId: 'USR005'}), (m:Movie {movieId: 'MOV003'})
CREATE (u)-[:ADDED_TO_WATCHLIST {
    addedDate: date('2023-11-01'),
    priority: 'High'
}]->(m);
