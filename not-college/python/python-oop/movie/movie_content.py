import media
import movie_website

toy_story= media.Movie('Toy Story', storyline='To infinity and beyond',
					   image='https://upload.wikimedia.org/wikipedia/en/1/13/Toy_Story.jpg',
					   trailer='https://www.youtube.com/watch?v=KYz2wyBy3kc')

avatar   = media.Movie('Avatar', storyline='Iconic Sci-fi movie',
					   image='https://upload.wikimedia.org/wikipedia/en/b/b0/Avatar-Teaser-Poster.jpg',
					   trailer='https://www.youtube.com/watch?v=cRdxXPV9GNQ')

the_matrix = media.Movie('The Matrix', storyline='We don\'t live in a similation, or do we?',
					   image='https://upload.wikimedia.org/wikipedia/en/c/c1/The_Matrix_Poster.jpg',
					   trailer='https://www.youtube.com/watch?v=vKQi3bBA1y8')

casino_royale= media.Movie('Casino royale', storyline='James Bond Movie',
					   image='https://upload.wikimedia.org/wikipedia/en/1/15/Casino_Royale_2_-_UK_cinema_poster.jpg',
					   trailer='https://www.youtube.com/watch?v=fl5WHj0bZ2Q')

star_trek = media.Movie('Star Trek', storyline='Star Trek Discovery',
					   image='http://www.anenglishmaninsandiego.com/wp-content/uploads/2017/09/poster-Star-Trek-Discovery-netflix-poster.jpg',
					   trailer='https://www.youtube.com/watch?v=oWnYtyNKPsA')

last_air_bender = media.Movie('The last airbender', storyline='Only the avatar',
					   image='https://www.justwatch.com/images/poster/462193/s592/avatar-the-last-airbender',
					   trailer='https://www.youtube.com/watch?v=Rz7EsOua-D4')

movie_website.open_movies_page([casino_royale, the_matrix, avatar,toy_story, star_trek, last_air_bender])
