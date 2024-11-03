/*
Movie ( mID, title, year, director )
电影（电影编号，电影名，上映年份，导演）

Reviewer ( rID, name )
评论者（评论者编号，评论者姓名）

Rating ( rID, mID, stars, ratingDate )
评论（评论者编号，电影编号，评分，评论日期）
*/

--1.Find all movies.
SELECT *
FROM Movie;

--2.Find all reviewers whose name include ‘er’.
SELECT *
FROM Reviewer
WHERE name Like '%er%';

--3.Find the titles of all movies released before 1980.
SELECT title
FROM Movie
WHERE year<1980;

--4.Find the reviewer names who have ratings with all movies.
SELECT name
FROM Reviewer NATURAL JOIN Rating
GROUP BY rID, name
HAVING COUNT(DISTINCT mID) = (SELECT COUNT(*) FROM Movie);

--5.Find the titles of all movies directed by Steven Spielberg.
SELECT title
FROM Movie
WHERE director='Steven Spielberg';

--6.Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT DISTINCT year
FROM Movie NATURAL JOIN Rating
WHERE stars in (4,5)
ORDER BY year ASC;

--7.Find the titles of all movies that have no ratings.
SELECT title
FROM Movie
WHERE mID NOT in
(SELECT DISTINCT mID FROM Rating);

--8.Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
SELECT DISTINCT name
FROM Reviewer NATURAL JOIN Rating
WHERE ratingDate IS NULL;

--9.Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
--Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
SELECT Reviewer.name AS "reviewer",Movie.title AS "movie",
    Rating.stars AS "stars",Rating.ratingdate AS "rating date"
FROM Rating
    LEFT OUTER JOIN Reviewer ON Reviewer.rid = Rating.rid
    LEFT OUTER JOIN Movie ON Movie.mid = Rating.mid
ORDER BY Reviewer.name, Movie.title, Rating.stars;

--10.For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
--return the reviewer's name and the title of the movie.
SELECT Reviewer.name, Movie.title
FROM Rating R1
    LEFT OUTER JOIN Rating R2 ON R2.rID = R1.rID
    LEFT OUTER JOIN movie ON Movie.mID = R2.mID
    LEFT OUTER JOIN reviewer ON Reviewer.rID = R2.rID
WHERE R1.mID = R2.mID
    AND R1.ratingdate < R2.ratingdate
    AND R1.stars < R2.stars;

--11.For each movie that has at least one rating, find the highest number of stars that movie received. 
--Return the movie title and number of stars. Sort by movie title.
SELECT Movie.title,MAX(Rating.stars) AS max_stars
FROM Rating
    LEFT OUTER JOIN Movie ON Movie.mid = Rating.mid
GROUP BY Movie.title
ORDER BY Movie.title;

--12.List movie titles and average ratings, from highest-rated to lowest-rated. 
--If two or more movies have the same average rating, list them in alphabetical order.
SELECT Movie.title,AVG(Rating.stars)
FROM Rating LEFT OUTER JOIN Movie ON Rating.mID = Movie.mID
GROUP BY Movie.title
ORDER BY AVG(Rating.stars) DESC,Movie.title ASC;

--13.Find the names of all reviewers who have contributed three or more ratings. 
--(As an extra challenge, try writing the query without HAVING or without COUNT.)
SELECT Reviewer.name
FROM Rating LEFT OUTER JOIN Reviewer
    ON Rating.rID = Reviewer.rID
GROUP BY Reviewer.name
HAVING COUNT(*) >=3;

--14.Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT Reviewer.name
FROM Rating 
    LEFT OUTER JOIN Reviewer ON Rating.rID=Reviewer.rID
    LEFT OUTER JOIN Movie ON Rating.mID=Movie.mID
WHERE Movie.title='Gone with the Wind';

--15.For any rating where the reviewer is the same as the director of the movie, 
--return the reviewer name, movie title, and number of stars.
SELECT Reviewer.name,Movie.title,Rating.stars
FROM Rating
    LEFT OUTER JOIN Movie ON Rating.mID=Movie.mID
    LEFT OUTER JOIN Reviewer ON Rating.rID=Reviewer.rID
WHERE Movie.director=Reviewer.name;

--16.Return all reviewer names and movie names together in a single list, alphabetized. 
--(Sorting by the first name of the reviewer and first word in the title is fine; 
--no need for special processing on last names or removing "The".)
SELECT name AS "name"
FROM Reviewer
UNION
SELECT title AS "name"
FROM Movie
ORDER BY name;

--17.Find the titles of all movies not reviewed by Chris Jackson.
SELECT title
FROM Movie
WHERE mID NOT in
    (
        SELECT DISTINCT mID
        FROM Rating
            LEFT OUTER JOIN Reviewer ON Rating.rID=Reviewer.rID
        WHERE Reviewer.name='Chris Jackson'
    );

--18.For all pairs of reviewers such that both reviewers gave a rating to the same movie, 
--return the names of both reviewers. Eliminate duplicates, 
--don't pair reviewers with themselves, and include each pair only once. 
--For each pair, return the names in the pair in alphabetical order.
SELECT DISTINCT Re1.name AS "reviewer1",Re2.name AS "reviewer2"
FROM Rating R1
    LEFT JOIN Rating R2 ON R1.mID=R2.mID
    LEFT JOIN Reviewer Re1 ON R1.rID=Re1.rID
    LEFT JOIN Reviewer Re2 ON R2.rID=Re2.rID
WHERE Re1.rID<RE2.rID;

--19.For each rating that is the lowest (fewest stars) currently in the database, 
--return the reviewer name, movie title, and number of stars.
SELECT Reviewer.name, Movie.title, Rating.stars
FROM Rating
    LEFT OUTER JOIN Movie ON Movie.mID = Rating.mID
    LEFT OUTER JOIN Reviewer ON Reviewer.rID = Rating.rID
WHERE Rating.stars = (
    SELECT MIN(stars)
    FROM Rating
);

--20.For each movie, return the title and the 'rating spread', 
--that is, the difference between highest and lowest ratings given to that movie. 
--Sort by rating spread from highest to lowest, then by movie title.
SELECT Movie.title,
    MAX(Rating.stars) - MIN(Rating.stars) AS "rating spread"
FROM rating
    LEFT OUTER JOIN Movie ON Movie.mid = Rating.mid
WHERE Rating.stars IS NOT NULL
GROUP BY Movie.title
ORDER BY MAX(Rating.stars) - MIN(Rating.stars) DESC, Movie.title ASC;

--21.Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
--(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
--Don't just calculate the overall average rating before and after 1980.) 
SELECT AVG(before.avg) -AVG(after.avg) AS "difference"
FROM
    (SELECT AVG(Rating.stars) AS "avg"
    FROM Rating 
        LEFT OUTER JOIN Movie ON Rating.mID=Movie.mID
    WHERE Rating.stars IS NOT NULL
    GROUP BY Movie.mID,Movie.year
    HAVING Movie.year<1980) AS before,
    (SELECT AVG(Rating.stars) AS "avg"
    FROM Rating 
        LEFT OUTER JOIN Movie ON Rating.mID=Movie.mID
    WHERE Rating.stars IS NOT NULL
    GROUP BY Movie.mID,Movie.year
    HAVING Movie.year>1980)AS after;

--22.Some directors directed more than one movie. 
--For all such directors, return the titles of all movies directed by them, 
--along with the director name. Sort by director name, then movie title. 
--(As an extra challenge, try writing the query both with and without COUNT.) 
SELECT director AS"director name",title AS"movie title"
FROM Movie
WHERE director IN(
    SELECT director
    FROM Movie
    GROUP BY director
    HAVING COUNT(*)>1
)
ORDER BY director, title;

--23.Find the movie(s) with the highest average rating. 
--Return the movie title(s) and average rating. 
--(Hint: This query is more difficult to write in SQLite than other systems; 
--you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
SELECT Movie.title,AVG(Rating.stars) AS "average rating"
FROM Rating 
    LEFT OUTER JOIN Movie ON Rating.mID=Movie.mID
GROUP BY Movie.title
HAVING AVG(Rating.stars)=
    (
        SELECT MAX(average)
        FROM (
            SELECT AVG(stars) AS average
            FROM Rating
            GROUP BY Rating.mID
        )
    );

--24.Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 
--(Hint: This query may be more difficult to write in SQLite than other systems; 
--you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 
SELECT Movie.title,AVG(Rating.stars) AS "average rating"
FROM Rating 
    LEFT OUTER JOIN Movie ON Rating.mID=Movie.mID
GROUP BY Movie.title
HAVING AVG(Rating.stars)=
    (
        SELECT MIN(average)
        FROM (
            SELECT AVG(stars) AS average
            FROM Rating
            GROUP BY Rating.mID
        )
    );

--25.For each director, return the director's name together with the title(s) of the movie(s) they directed 
--that received the highest rating among all of their movies, 
--and the value of that rating. Ignore movies whose director is NULL.
SELECT DISTINCT M1.director,M1.title,Rating.stars
FROM Rating
    LEFT OUTER JOIN Movie M1 ON Rating.mID=M1.mID
WHERE M1.director IS NOT NULL
    AND Rating.stars=
        (
            SELECT MAX(Rating.stars)
            FROM Rating
                LEFT OUTER JOIN Movie M2 ON Rating.mID=M2.mID
            WHERE M1.director=M2.director
        );
