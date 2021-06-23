USE albums_db;

SHOW TABLES;

DESCRIBE albums;

SELECT artist FROM albums;

SELECT DISTINCT artist FROM albums;

SELECT release_date from albums ORDER BY release_date;

#3. a. How many rows are in the albums table?  -31

#b. How many unique artist names are in the albums table?  -23

#c. What is the primary key for the albums table?  -id 

#d. What is the oldest release date for any album in the albums table?   -1967 What is the most recent release date? -2011


#4. a. The name of all albums by Pink Floyd. -The Dark Side of the Moon, The Wall

#b. The year Sgt. Pepper's Lonely Hearts Club Band was released. -1967

#c. The genre for the album Nevermind. -Grunge, Alternative rock

#d. Which albums were released in the 1990s -The Bodyguard, Jagged Little Pill, Come On Over, Falling into You, Let's Talk About Love, Dangerous, The Immaculate Collection, Titanic: Music from the Motion Picture, Metallica, Nevermind, Supernatural

#e. Which albums had less than 20 million certified sales. -Grease: The Original Soundtrack from the Motion Picture, Bad, Sgt. Pepper's Lonely Hearts Club Band, Dirty Dancing, Let's Talk About Love, Dangerous, The Immaculate Collection, Abbey Road, Born in the U.S.A., Brothers in Arms, Titanic: Music from the Motion Picture, Nevermind, The Wall

#f. All the albums with a genre of "Rock". Why do these query results not include albums with a genre of "Hard rock" or "Progressive rock"?
#Sgt. Pepper's Lonely Hearts Club Band,1,Abbey Road,Born in the U.S.A.,Supernatural.  --Not a string literal

SELECT name FROM albums WHERE artist = 'Pink Floyd';

SELECT release_date FROM albums WHERE name =  "Sgt. Pepper's Lonely Hearts Club Band";

SELECT genre FROM albums WHERE name = 'Nevermind';  

SELECT name, release_date FROM albums WHERE release_date BETWEEN '1990' AND '1999';

SELECT name FROM albums WHERE sales < 20.0;

SELECT name FROM albums WHERE genre = 'Rock';

