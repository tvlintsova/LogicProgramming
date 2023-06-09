/* cinema(id, name, address, phone, seats_count, halls_count). */
cinema(1, "5 звезд", "пл. Ленина, 2а", "8-123-456-78-90", 60, 1).
cinema(2, "Киномакс", "Дмитровское шоссе, 89", "8-987-654-32-10", 210, 2).
cinema(3, "Киномакс", "ул. Генерала Кузнецова, 22", "8-987-654-32-10", 100, 1).

/* cinema_hall(id, cinema_id, number_in_cinema, seats_count). */
cinema_hall(1, 1, 1, 60).
cinema_hall(2, 2, 1, 110).
cinema_hall(3, 2, 2, 100).
cinema_hall(4, 3, 1, 100).

/* film(id, title, issue_year, director, genre). */
film(1, "Без ответа", 2023, "Декстер Флетчер", "боевик").
film(2, "Форсаж 10", 2023, "Луи Летерье", "боевик").
film(3, "Реинкарнация", 2018, "Ари Астер", "ужасы").

/* showing(film_id, cinema_id, cinema_hall_id, date, time, price). */
showing(1, 1, 1, "2023-05-25", "20:00", 550).
showing(3, 2, 2, "2023-05-26", "23:30", 700).
showing(3, 2, 3, "2023-05-26", "23:30", 750).
showing(2, 3, 4, "2023-05-27", "18:15", 250).

/* has_1_hall(CinemaId) :- cinema(CinemaId, "5 звезд", "пл. Ленина, 2а", X, Y, Z) ; cinema(CinemaId, "Киномакс", "ул. Генерала Кузнецова, 22", X, Y, Z). */
has_1_hall(CinemaId) :- cinema(CinemaId, "5 звезд", "пл. Ленина, 2а", X, Y, Z).
has_1_hall(CinemaId) :- cinema(CinemaId, "Киномакс", "ул. Генерала Кузнецова, 22", X, Y, Z).

has_2_halls(CinemaId) :- cinema(CinemaId, "Киномакс", "Дмитровское шоссе, 89", X, Y, Z).

showing_in_cinema(FilmId, CinemaId) :- showing(FilmId, CinemaId, Hall, Date, Time, Price).
