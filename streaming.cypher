CREATE CONSTRAINT user_id IF NOT EXISTS
FOR (u:User) REQUIRE u.id IS UNIQUE;

CREATE CONSTRAINT movie_id IF NOT EXISTS
FOR (m:Movie) REQUIRE m.id IS UNIQUE;

CREATE CONSTRAINT series_id IF NOT EXISTS
FOR (s:Series) REQUIRE s.id IS UNIQUE;

CREATE CONSTRAINT actor_id IF NOT EXISTS
FOR (a:Actor) REQUIRE a.id IS UNIQUE;

CREATE CONSTRAINT director_id IF NOT EXISTS
FOR (d:Director) REQUIRE d.id IS UNIQUE;

CREATE CONSTRAINT genre_id IF NOT EXISTS
FOR (g:Genre) REQUIRE g.id IS UNIQUE;

CREATE (g1:Genre {id: 501, name: "Sci-Fi"});
CREATE (g2:Genre {id: 502, name: "Drama"});
CREATE (g3:Genre {id: 503, name: "Mystery"});
CREATE (g4:Genre {id: 504, name: "Adventure"});
CREATE (g5:Genre {id: 505, name: "Comedy"});
CREATE (g6:Genre {id: 506, name: "Action"});

CREATE (u1:User {id: 1, name: "Laura"});
CREATE (u2:User {id: 2, name: "Carlos"});
CREATE (u3:User {id: 3, name: "Diego"});
CREATE (u4:User {id: 4, name: "Andres"});
CREATE (u5:User {id: 5, name: "Carol"});
CREATE (u6:User {id: 6, name: "Juliana"});
CREATE (u7:User {id: 7, name: "Diana"});
CREATE (u8:User {id: 8, name: "Santiago"});
CREATE (u9:User {id: 9, name: "Daniel"});
CREATE (u10:User {id: 10, name: "Ricardo"});

CREATE (m1:Movie {id:101, title: "Inception", year: 2010});
CREATE (m2:Movie {id:102, title: "Interstellar", year: 2014});
CREATE (m3:Movie {id:103, title: "The Wolf of Wall Street", year: 2013});
CREATE (m4:Movie {id:104, title: "Jumanjy: Welcome to the Jungle", year: 2017});
CREATE (m5:Movie {id:105, title: "The Matrix", year: 1999});

CREATE (s1:Series {id:201, title: "Stranger Things", year: 2016});
CREATE (s2:Series {id:202, title: "Escobar, Patron del Mal", year: 2012});
CREATE (s3:Series {id:203, title: "The Last of Us", year: 2023});
CREATE (s4:Series {id:204, title: "Black Mirror", year: 2011});
CREATE (s5:Series {id:205, title: "The Office", year: 2005});

CREATE (a1:Actor {id:301, name: "Leonardo DiCaprio"});
CREATE (a2:Actor {id:302, name: "Matthew McConaughey"});
CREATE (a3:Actor {id:303, name: "Winona Ryder"});
CREATE (a4:Actor {id:304, name: "Pedro Pascal"});
CREATE (a5:Actor {id:305, name: "Millie Bobby"});
CREATE (a6:Actor {id:306, name: "Dwayne Johnson"});
CREATE (a7:Actor {id:307, name: "Keanu Reeves"});
CREATE (a8:Actor {id:308, name: "Andres Parra"});
CREATE (a9:Actor {id:309, name: "Steve Carell"});
CREATE (a10:Actor {id:310, name: "Bryce Dallas Howard"});
	
CREATE (d1:Director {id:401, name: "Christopher Nolan"});
CREATE (d2:Director {id:402, name: "The Duffer Brothers"});
CREATE (d3:Director {id:403, name: "Martin Scorsese"});
CREATE (d4:Director {id:404, name: "Jake Kasdan"});
CREATE (d5:Director {id:405, name: "Carlos Moreno"});
CREATE (d6:Director {id:406, name: "The Wachowskis"});
CREATE (d7:Director {id:407, name: "Jodie Foster"});
CREATE (d8:Director {id:408, name: "Ken Kwapis"});
CREATE (d9:Director {id:409, name: "Neil Druckmann "});


MATCH (m1:Movie {id:101}), (g1:Genre {id: 501})  CREATE (m1)-[:IN_GENRE]->(g1);
MATCH (m2:Movie {id:102}), (g1:Genre {id: 501})  CREATE (m2)-[:IN_GENRE]->(g1);
MATCH (m3:Movie {id:103}), (g3:Genre {id: 503})  CREATE (m3)-[:IN_GENRE]->(g3);
MATCH (m3:Movie {id:103}), (g5:Genre {id: 505})  CREATE (m3)-[:IN_GENRE]->(g5);
MATCH (m4:Movie {id:104}), (g4:Genre {id: 504})  CREATE (m4)-[:IN_GENRE]->(g4);
MATCH (m5:Movie {id:105}), (g1:Genre {id: 501})  CREATE (m5)-[:IN_GENRE]->(g1);

MATCH (s1:Series {id:201}), (g1:Genre {id: 501}) CREATE (s1)-[:IN_GENRE]->(g1);
MATCH (s1:Series {id:201}), (g3:Genre {id: 503}) CREATE (s1)-[:IN_GENRE]->(g3);
MATCH (s2:Series {id:202}), (g2:Genre {id: 502}) CREATE (s2)-[:IN_GENRE]->(g2);
MATCH (s2:Series {id:202}), (g3:Genre {id: 503}) CREATE (s2)-[:IN_GENRE]->(g3);
MATCH (s3:Series {id:203}), (g2:Genre {id: 502}) CREATE (s3)-[:IN_GENRE]->(g2);
MATCH (s4:Series {id:204}), (g1:Genre {id: 501}) CREATE (s4)-[:IN_GENRE]->(g1);
MATCH (s4:Series {id:204}), (g6:Genre {id: 506}) CREATE (s4)-[:IN_GENRE]->(g6);
MATCH (s5:Series {id:205}), (g5:Genre {id: 505}) CREATE (s5)-[:IN_GENRE]->(g5);

MATCH (a1:Actor {id:301}),  (m1:Movie {id:101}) CREATE (a1)-[:ACTED_IN]->(m1);
MATCH (a2:Actor {id:302}),  (m2:Movie {id:102}) CREATE (a2)-[:ACTED_IN]->(m2);
MATCH (a1:Actor {id:301}),  (m3:Movie {id:103}) CREATE (a1)-[:ACTED_IN]->(m3);
MATCH (a6:Actor {id:306}),  (m4:Movie {id:104}) CREATE (a6)-[:ACTED_IN]->(m4);
MATCH (a7:Actor {id:307}),  (m5:Movie {id:105}) CREATE (a7)-[:ACTED_IN]->(m5);
MATCH (a3:Actor {id:303}),  (s1:Series {id:201}) CREATE (a3)-[:ACTED_IN]->(s1);
MATCH (a4:Actor {id:304}),  (s3:Series {id:203}) CREATE (a4)-[:ACTED_IN]->(s3);
MATCH (a5:Actor {id:305}),  (s1:Series {id:201}) CREATE (a5)-[:ACTED_IN]->(s1);
MATCH (a8:Actor {id:308}),  (s2:Series {id:202}) CREATE (a8)-[:ACTED_IN]->(s2);
MATCH (a9:Actor {id:309}),  (s5:Series {id:205}) CREATE (a9)-[:ACTED_IN]->(s5);
MATCH (a10:Actor {id:310}), (s4:Series {id:204}) CREATE (a10)-[:ACTED_IN]->(s4);

MATCH (d1:Director {id:401}), (m1:Movie {id:101})  CREATE (d1)-[:DIRECTED]->(m1);
MATCH (d1:Director {id:401}), (m2:Movie {id:102})  CREATE (d1)-[:DIRECTED]->(m2);
MATCH (d2:Director {id:402}), (s1:Series {id:201}) CREATE (d2)-[:DIRECTED]->(s1);
MATCH (d3:Director {id:403}), (m3:Movie {id:103})  CREATE (d3)-[:DIRECTED]->(m3);
MATCH (d4:Director {id:404}), (m4:Movie {id:104})  CREATE (d4)-[:DIRECTED]->(m4);
MATCH (d5:Director {id:405}), (s2:Series {id:202}) CREATE (d5)-[:DIRECTED]->(s2);
MATCH (d6:Director {id:406}), (m5:Movie {id:105})  CREATE (d6)-[:DIRECTED]->(m5);
MATCH (d7:Director {id:407}), (s4:Series {id:204}) CREATE (d7)-[:DIRECTED]->(s4);
MATCH (d8:Director {id:408}), (s5:Series {id:205}) CREATE (d8)-[:DIRECTED]->(s5);
MATCH (d9:Director {id:409}), (s3:Series {id:203}) CREATE (d9)-[:DIRECTED]->(s3);

MATCH (u1:User {id: 1}), (m1:Movie {id:101})    CREATE (u1)-[:WATCHED {rating: 5}]->(m1);
MATCH (u1:User {id: 1}), (s1:Series {id:201})   CREATE (u1)-[:WATCHED {rating: 3}]->(s1);
MATCH (u2:User {id: 2}), (m2:Movie {id:102})    CREATE (u2)-[:WATCHED {rating: 5}]->(m2);
MATCH (u3:User {id: 3}), (m3:Movie {id:103})    CREATE (u3)-[:WATCHED {rating: 4}]->(m3);
MATCH (u4:User {id: 4}), (s2:Series {id:202})   CREATE (u4)-[:WATCHED {rating: 4}]->(s2);
MATCH (u5:User {id: 5}), (m5:Movie {id:105})    CREATE (u5)-[:WATCHED {rating: 4}]->(m5);
MATCH (u6:User {id: 6}), (s3:Series {id:203})   CREATE (u6)-[:WATCHED {rating: 5}]->(s3);
MATCH (u7:User {id: 7}), (m4:Movie {id:104})    CREATE (u7)-[:WATCHED {rating: 4}]->(m4);
MATCH (u8:User {id: 8}), (s4:Series {id:204})   CREATE (u8)-[:WATCHED {rating: 6}]->(s4);
MATCH (u9:User {id: 9}), (s5:Series {id:205})   CREATE (u9)-[:WATCHED {rating: 5}]->(s5);
MATCH (u10:User {id: 10}), (s1:Series {id:201}) CREATE (u10)-[:WATCHED {rating: 4}]->(s1);
